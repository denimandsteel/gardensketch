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
	
	WDTool *house = [WDToolManager sharedInstance].house;
	WDTool *houseL1 = [WDToolManager sharedInstance].houseL1;
	WDTool *houseL2 = [WDToolManager sharedInstance].houseL2;
	WDTool *houseL3 = [WDToolManager sharedInstance].houseL3;
	WDTool *houseL4 = [WDToolManager sharedInstance].houseL4;
	WDTool *houseRectHor = [WDToolManager sharedInstance].houseRectHor;
	WDTool *houseRectVer = [WDToolManager sharedInstance].houseRectVer;
	WDTool *scale = [WDToolManager sharedInstance].scale;
	WDTool *select = [WDToolManager sharedInstance].select;
		
	[self.houseButton setTool:house];
	[self.houseButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	[self.houseButton setBackgroundImage:[UIImage imageNamed:@"select_background_colour"] forState:UIControlStateSelected];
	
	[self.houseL1Button setTool:houseL1];
	[self.houseL1Button addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	[self.houseL1Button setBackgroundImage:[UIImage imageNamed:@"select_background_colour"] forState:UIControlStateSelected];
	
	[self.houseL2Button setTool:houseL2];
	[self.houseL2Button addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	[self.houseL2Button setBackgroundImage:[UIImage imageNamed:@"select_background_colour"] forState:UIControlStateSelected];
	
	[self.houseL3Button setTool:houseL3];
	[self.houseL3Button addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	[self.houseL3Button setBackgroundImage:[UIImage imageNamed:@"select_background_colour"] forState:UIControlStateSelected];
	
	[self.houseL4Button setTool:houseL4];
	[self.houseL4Button addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	[self.houseL4Button setBackgroundImage:[UIImage imageNamed:@"select_background_colour"] forState:UIControlStateSelected];
	
	[self.houseRectHorButton setTool:houseRectHor];
	[self.houseRectHorButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	[self.houseRectHorButton setBackgroundImage:[UIImage imageNamed:@"select_background_colour"] forState:UIControlStateSelected];
	
	[self.houseRectVerButton setTool:houseRectVer];
	[self.houseRectVerButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	[self.houseRectVerButton setBackgroundImage:[UIImage imageNamed:@"select_background_colour"] forState:UIControlStateSelected];
	
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
	
	[self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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

- (IBAction)doneTapped:(id)sender {
	NSInteger northTabIndex = 2;
	[self.sidebar setSelectedIndex:northTabIndex];
}

@end
