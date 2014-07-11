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
	
	self.isInShapeMode = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
	// TODO: make sure SelectTool is the active tool
	WDDrawingManager *drawingManager = [WDDrawingManager sharedInstance];
	WDDocument *basePlanDocument = [drawingManager openBasePlanDocumentWithCompletionHandler:nil];
	[self.sidebar.canvasController setDocument:basePlanDocument];
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
	if (self.isInShapeMode) {
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
		
		[self.sizeView setAlpha:0.0];
		[self.sizeView setHidden:NO];
		[UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
			for (PropertyShapeButton *shape in self.shapes) {
				if (shape != sender) {
					[shape setAlpha:0.0];
				}
			}
		} completion:^(BOOL success) {
			if (success) {
				for (PropertyShapeButton *shape in self.shapes) {
					if (shape != sender) {
						[shape setHidden:YES];
					}
				}
			}
		}];
		
		[self moveShapeUp:sender];
		
		self.isInShapeMode = NO;
	} else {
		[self changeShapeTapped:nil];
	}
}

- (void)moveShapeUp:(PropertyShapeButton *)shape
{
	[UIView animateWithDuration:.3 delay:.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[shape setFrame:shape.secondaryFrame];
		[self.sizeView setAlpha:1.0];
	} completion:^(BOOL success) {
		
	}];
}

- (IBAction)changeShapeTapped:(id)sender {
	for (PropertyShapeButton *shape in self.shapes) {
		[shape setHidden:NO];
		[shape setAlpha:0.0];
	}
	[UIView animateWithDuration:.3 animations:^{
		for (PropertyShapeButton *shape in self.shapes) {
			[shape setAlpha:1.0];
			[shape setFrame:shape.primaryFrame];
		}
		[self.sizeView setAlpha:0.0];
	} completion:^(BOOL success) {
		[self.sizeView setHidden:YES];
	}];
	
	self.isInShapeMode = YES;
}

- (IBAction)doneTapped:(id)sender {
	NSInteger structureTabIndex = 1;
	[self.sidebar setSelectedIndex:structureTabIndex];
	
	CGSize size = CG_DEFAULT_CANVAS_SIZE;
	
	if (![self.firstField.text isEqualToString:@""]) {
		size.width = [self.firstField.text integerValue] * 32;
	}
	
	if (![self.secondField.text isEqualToString:@""]) {
		size.height = [self.secondField.text integerValue] * 32;
	}
	
	[self setPlanSize:size];
}

- (void)setPlanSize:(CGSize)size
{
	WDDrawing *basePlanDrawing = self.sidebar.canvasController.drawing;
	[basePlanDrawing setHeight:size.height];
	[basePlanDrawing setWidth:size.width];
	
	// TODO: send notification for base plan size being changed
	[[WDDrawingManager sharedInstance] setBasePlanSize:size];
	
	WDLayer *baseLayer = self.sidebar.canvasController.drawing.layers.firstObject;
	
	[[WDDrawingManager sharedInstance] setBasePlanLayer:baseLayer];
	
	NSLog(@"Setting plan size to %f, %f", size.width, size.height);
}

@end
