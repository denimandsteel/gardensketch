//
//  StructureViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-16.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "HouseViewController.h"
#import "WDToolManager.h"
#import "WDStencilTool.h"
#import "WDScaleTool.h"
#import "WDSelectionTool.h"
#import "WDDrawingManager.h"
#import "WDDrawingController.h"
#import "Constants.h"

@interface HouseViewController ()

@end

@implementation HouseViewController

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
	
	WDTool *house = nil;
	WDTool *houseL1 = nil;
	WDTool *houseL2 = nil;
	WDTool *houseL3 = nil;
	WDTool *houseL4 = nil;
	WDTool *houseRectHor = nil;
	WDTool *houseRectVer = nil;
	WDTool *scale = nil;
	WDTool *select = nil;
	
	for (WDTool *tool in [WDToolManager sharedInstance].tools) {
		if ([tool isKindOfClass:[WDStencilTool class]]) {
			if ([(WDStencilTool *)tool type] == kHouse) {
				house = tool;
			} else if ([(WDStencilTool *)tool type] == kHouseL1) {
				houseL1 = tool;
			} else if ([(WDStencilTool *)tool type] == kHouseL2) {
				houseL2 = tool;
			} else if ([(WDStencilTool *)tool type] == kHouseL3) {
				houseL3 = tool;
			} else if ([(WDStencilTool *)tool type] == kHouseL4) {
				houseL4 = tool;
			} else if ([(WDStencilTool *)tool type] == kHouseRectHor) {
				houseRectHor = tool;
			} else if ([(WDStencilTool *)tool type] == kHouseRectVer) {
				houseRectVer = tool;
			}
		} else if ([tool isKindOfClass:[WDScaleTool class]]) {
			scale = tool;
		} else if ([tool isKindOfClass:[WDSelectionTool class]]) {
			select = tool;
		}
	}
	
	[self.houseButton setTool:house];
	[self.houseButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.houseL1Button setTool:houseL1];
	[self.houseL1Button addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.houseL2Button setTool:houseL2];
	[self.houseL2Button addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.houseL3Button setTool:houseL3];
	[self.houseL3Button addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.houseL4Button setTool:houseL4];
	[self.houseL4Button addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.houseRectHorButton setTool:houseRectHor];
	[self.houseRectHorButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.houseRectVerButton setTool:houseRectVer];
	[self.houseRectVerButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.scaleButton setTool:scale];
	[self.scaleButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.selectButton setTool:select];
	[self.selectButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
	WDDrawingManager *drawingManager = [WDDrawingManager sharedInstance];
	WDDocument *basePlanDocument = [drawingManager openBasePlanDocumentWithCompletionHandler:nil];
	[self.sidebar.canvasController setDocument:basePlanDocument];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
           selector:@selector(selectionChanged:)
               name:WDSelectionChangedNotification
             object:self.sidebar.canvasController.drawingController];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.selectButton setTitleColor:GS_COLOR_DARK_GREY_TEXT forState:UIControlStateNormal];
	[self.selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	
	[self.selectButton setImage:[UIImage imageNamed:@"Select_Colour"] forState:UIControlStateNormal];
	[self.selectButton setImage:[UIImage imageNamed:@"Select_White"] forState:UIControlStateSelected];
	
	[self.selectButton setBackgroundImage:[UIImage imageNamed:@"select_background_white"] forState:UIControlStateNormal];
	[self.selectButton setBackgroundImage:[UIImage imageNamed:@"select_background_colour"] forState:UIControlStateSelected];
	
	[self.selectButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
	
	[self.selectButton.layer setCornerRadius:3.0];
	[self.selectButton.layer setMasksToBounds:YES];
	
	[self.scaleButton setTitleColor:GS_COLOR_DARK_GREY_TEXT forState:UIControlStateNormal];
	[self.scaleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	
	[self.scaleButton setImage:[UIImage imageNamed:@"Resize_Colour"] forState:UIControlStateNormal];
	[self.scaleButton setImage:[UIImage imageNamed:@"Resize_White"] forState:UIControlStateSelected];
	
	[self.scaleButton setBackgroundImage:[UIImage imageNamed:@"select_background_white"] forState:UIControlStateNormal];
	[self.scaleButton setBackgroundImage:[UIImage imageNamed:@"select_background_colour"] forState:UIControlStateSelected];
	
	[self.scaleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
	
	[self.scaleButton.layer setCornerRadius:3.0];
	[self.scaleButton.layer setMasksToBounds:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
	WDLayer *baseLayer = self.sidebar.canvasController.drawingController.drawing.layers.firstObject;
	[[WDDrawingManager sharedInstance] setBasePlanLayer:baseLayer];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) chooseTool:(id)sender
{
    [WDToolManager sharedInstance].activeTool = ((WDToolButton *)sender).tool;
}

- (void) selectionChanged:(NSNotification *)aNotification
{
    self.deleteButton.enabled = (self.sidebar.canvasController.drawingController.selectedObjects.count > 0) ? YES : NO;
}

- (IBAction)deleteTapped:(id)sender {
	[self.sidebar.canvasController delete:self];
}

@end
