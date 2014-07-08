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
	
	for (WDTool *tool in [WDToolManager sharedInstance].tools) {
		if ([tool isKindOfClass:[WDStencilTool class]]) {
			if ([(WDStencilTool *)tool type] == kHouse) {
				house = tool;
				break;
			}
		}
	}
	
	[self.houseButton setTool:house];
	
	[self.houseButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
	// TODO: if not already loaded, load base plan on canvas
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
