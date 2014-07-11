//
//  WDToolManager.m
//  Inkpad
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2011-2013 Steve Sprang
//

#import "WDAddAnchorTool.h"
#import "WDEyedropperTool.h"
#import "WDEraserTool.h"
#import "WDFreehandTool.h"
#import "WDPenTool.h"
#import "WDRotateTool.h"
#import "WDScaleTool.h"
#import "WDScissorTool.h"
#import "WDSelectionTool.h"
#import "WDShapeTool.h"
#import "WDTextTool.h"
#import "WDStencilTool.h"
#import "WDToolManager.h"


NSString *WDActiveToolDidChange = @"WDActiveToolDidChange";

@implementation WDToolManager

@synthesize activeTool = activeTool_;
@synthesize tools = tools_;

+ (WDToolManager *) sharedInstance
{
    static WDToolManager *toolManager_ = nil;
    
    if (!toolManager_) {
        toolManager_ = [[WDToolManager alloc] init];
        toolManager_.activeTool = (toolManager_.tools)[0];
    }
    
    return toolManager_;
}

- (NSArray *) tools
{
    if (!tools_) {
        WDFreehandTool *closedFreehand = (WDFreehandTool *)[WDFreehandTool tool];
        closedFreehand.closeShape = YES;
		
		WDStencilTool *bigPlant = (WDStencilTool *)[WDStencilTool tool];
		[bigPlant setType:kPlantBig];
		[bigPlant setRandomRotation:YES];
		[bigPlant setRepeatCount:2];
		
		WDStencilTool *smallPlant = (WDStencilTool *)[WDStencilTool tool];
		[smallPlant setType:kPlantSmall];
		[smallPlant setRandomRotation:YES];
		[smallPlant setRepeatCount:2];
		
		WDStencilTool *shrub = (WDStencilTool *)[WDStencilTool tool];
		[shrub setType:kShrub];
		[shrub setRandomRotation:YES];
		
		WDStencilTool *hedgeVertical = (WDStencilTool *)[WDStencilTool tool];
		[hedgeVertical setType:kHedge];
		
		WDStencilTool *hedgeHorizontal = (WDStencilTool *)[WDStencilTool tool];
		[hedgeHorizontal setType:kHedge];
		[hedgeHorizontal setInitialRotation:M_PI/2];
		
		WDStencilTool *deciduousTree = (WDStencilTool *)[WDStencilTool tool];
		[deciduousTree setType:kTreeDeciduous];
		[deciduousTree setRandomRotation:YES];
		
		WDStencilTool *confirousTree = (WDStencilTool *)[WDStencilTool tool];
		[confirousTree setType:kTreeConiferous];
		[confirousTree setRandomRotation:YES];

		WDStencilTool *sidewalk = (WDStencilTool *)[WDStencilTool tool];
		[sidewalk setType:kSidewalk];
		
		WDStencilTool *gazebo = (WDStencilTool *)[WDStencilTool tool];
		[gazebo setType:kGazebo];
		
		WDStencilTool *shed = (WDStencilTool *)[WDStencilTool tool];
		[shed setType:kShed];
        
		WDStencilTool *house = (WDStencilTool *)[WDStencilTool tool];
		[house setType:kHouse];
		
		tools_ = @[[WDSelectionTool tool],
                   [WDFreehandTool tool],
				   closedFreehand,
				   bigPlant,
				   smallPlant,
				   shrub,
				   hedgeVertical,
				   hedgeHorizontal,
				   deciduousTree,
				   confirousTree,
				   sidewalk,
				   gazebo,
				   shed,
				   house,
				   [WDScaleTool tool]];
    }
    
    return tools_;
}

- (void) setActiveTool:(WDTool *)activeTool
{
    [activeTool_ deactivated];
    activeTool_ = activeTool;
    [activeTool_ activated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WDActiveToolDidChange object:nil userInfo:nil];
}

@end
