//
//  StructureViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-16.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "StructureViewController.h"
#import "WDToolManager.h"
#import "WDStencilTool.h"
#import "WDScaleTool.h"
#import "WDSelectionTool.h"
#import "WDDrawingManager.h"
#import "WDDrawingController.h"

@interface StructureViewController ()

@end

@implementation StructureViewController

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
	WDTool *scale = nil;
	WDTool *select = nil;
	
	for (WDTool *tool in [WDToolManager sharedInstance].tools) {
		if ([tool isKindOfClass:[WDStencilTool class]]) {
			if ([(WDStencilTool *)tool type] == kHouse) {
				house = tool;
			}
		} else if ([tool isKindOfClass:[WDScaleTool class]]) {
			scale = tool;
		} else if ([tool isKindOfClass:[WDSelectionTool class]]) {
			select = tool;
		}
	}
	
	[self.houseButton setTool:house];
	[self.houseButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
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


@end
