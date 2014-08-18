//
//  PropertyViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-13.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "PropertyViewController.h"
#import "WDDrawingManager.h"
#import "WDDrawing.h"
#import "Constants.h"
#import "WDDrawingController.h"
#import "Mixpanel.h"
#import "WDDocument.h"

@interface PropertyViewController ()

@end

@implementation PropertyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	for (PropertyShapeButton *shape in self.shapes) {
		shape.primaryFrame = shape.frame;
		shape.secondaryFrame = CGRectMake(40, 90, shape.bounds.size.width / 2, shape.bounds.size.height / 2);
	}
	
	[self.firstField setDelegate:self];
	[self.secondField setDelegate:self];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawingChanged:)
                                                 name:UIDocumentStateChangedNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
	// TODO: make sure SelectTool is the active tool
	WDDrawingManager *drawingManager = [WDDrawingManager sharedInstance];
	WDDocument *basePlanDocument = [drawingManager openBasePlanDocumentWithCompletionHandler:nil];
	[self.sidebar.canvasController setDocument:basePlanDocument];
}

- (void)viewWillAppear:(BOOL)animated
{
	CGRect firstFrame = self.firstField.frame;
	firstFrame.size.height = 50;
	[self.firstField setFrame:firstFrame];
	
	CGRect secondFrame = self.secondField.frame;
	secondFrame.size.height = 50;
	[self.secondField setFrame:secondFrame];
	
	[self.firstField setBackgroundColor:GS_COLOR_LIGHT_GREY_BACKGROUND];
	[self.secondField setBackgroundColor:GS_COLOR_LIGHT_GREY_BACKGROUND];
	
	[self.firstField setFont:GS_FONT_AVENIR_HEAD];
	[self.secondField setFont:GS_FONT_AVENIR_HEAD];
	
	[self.firstField.layer setBorderColor:[UIColor clearColor].CGColor];
	[self.secondField.layer setBorderColor:[UIColor clearColor].CGColor];
	
	CGSize basePlanSize = [WDDrawingManager sharedInstance].basePlanSize;
	
	[self updateTextfieldsWithSize:basePlanSize];
	
	[self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)updateTextfieldsWithSize:(CGSize)size
{
	if (size.width > 0 && size.height > 0) {
		[self.firstField setText:[NSString stringWithFormat:@"%lu", (long)[@(size.width / 32) integerValue]]];
		[self.secondField setText:[NSString stringWithFormat:@"%lu", (long)[@(size.height / 32) integerValue]]];
	} else {
		[self.firstField setText:[NSString stringWithFormat:@"%lu", (long)[@(2048 / 32) integerValue]]];
		[self.secondField setText:[NSString stringWithFormat:@"%lu", (long)[@(2048 / 32) integerValue]]];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	// TODO: write methods to access the drawing :
	[[WDDrawingManager sharedInstance] setBasePlanSize:self.sidebar.canvasController.drawingController.drawing.dimensions];
	WDLayer *baseLayer = self.sidebar.canvasController.drawingController.drawing.layers.firstObject;
	[[WDDrawingManager sharedInstance] setBasePlanLayer:baseLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 
 Property Boundaries
 The red lines mark the property boundaries.
 
 You can draw and write notes outside the red lines, but be mindful of where you can actually plant.
 
*/

- (IBAction)shapeSelected:(id)sender {
	CGSize size;
	switch ([(UIButton *)sender tag]) {
		case 0:
			size = CGSizeMake(1024, 2048);
			break;
		case 1:
			size = CGSizeMake(2048, 2048);
			break;
		case 2:
			size = CGSizeMake(2048, 1024);
			break;
		default:
			size = CG_DEFAULT_CANVAS_SIZE;
			break;
	}
	[self setPlanSize:size];
	[self.firstField setText:[NSString stringWithFormat:@"%lu", (long)[@(size.width / 32) integerValue]]];
	[self.secondField setText:[NSString stringWithFormat:@"%lu", (long)[@(size.height / 32) integerValue]]];
}

- (IBAction)doneTapped:(id)sender {
	NSInteger structureTabIndex = 1;
	[self.sidebar setSelectedIndex:structureTabIndex];
}

- (void)setPlanSize:(CGSize)size
{
	WDDrawing *basePlanDrawing = self.sidebar.canvasController.drawing;
	[basePlanDrawing setHeight:size.height];
	[basePlanDrawing setWidth:size.width];
	
	[[WDDrawingManager sharedInstance] setBasePlanSize:size];
	
	WDLayer *baseLayer = self.sidebar.canvasController.drawing.layers.firstObject;
	
	[[WDDrawingManager sharedInstance] setBasePlanLayer:baseLayer];
	
	NSLog(@"Setting plan size to %f, %f", size.width, size.height);
	
	[[Mixpanel sharedInstance] track:@"Property_Dimensions" properties:@{@"width": @(size.width/32), @"height": @(size.height/32)}];
}

- (CGSize)sizeFromTextfields
{
	CGSize size = CG_DEFAULT_CANVAS_SIZE;
	
	if (![self.firstField.text isEqualToString:@""]) {
		size.width = [self.firstField.text integerValue] * 32;
	}
	
	if (![self.secondField.text isEqualToString:@""]) {
		size.height = [self.secondField.text integerValue] * 32;
	}
	
	return size;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self setPlanSize:[self sizeFromTextfields]];
}

- (void) drawingChanged:(NSNotification *)aNotification
{
    WDDocument *document = [aNotification object];
	if ([document.filename isEqualToString:GS_BASE_PLAN_FILE_NAME]) {
		[self updateTextfieldsWithSize:document.drawing.dimensions];
	}
}

@end
