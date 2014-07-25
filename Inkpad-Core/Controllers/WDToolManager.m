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
		WDSelectionTool *select = (WDSelectionTool *)[WDSelectionTool tool];
		
		WDFreehandTool *freehand = (WDFreehandTool *)[WDFreehandTool tool];
		
        WDFreehandTool *enclosed = (WDFreehandTool *)[WDFreehandTool tool];
        enclosed.closeShape = YES;
		
		WDStencilTool *plant = (WDStencilTool *)[WDStencilTool tool];
		[plant setType:kPlant];
		[plant setRandomRotation:YES];
		[plant setRepeatCount:2];
		
		WDShapeTool *line = (WDShapeTool *)[WDShapeTool tool];
		[line setShapeMode:WDShapeLine];
		
		WDStencilTool *shrub = (WDStencilTool *)[WDStencilTool tool];
		[shrub setType:kShrub];
		[shrub setRandomRotation:YES];
		
		WDStencilTool *verticalHedge = (WDStencilTool *)[WDStencilTool tool];
		[verticalHedge setType:kHedge];
		
		WDStencilTool *horizontalHedge = (WDStencilTool *)[WDStencilTool tool];
		[horizontalHedge setType:kHedge];
		[horizontalHedge setInitialRotation:M_PI/2];
		
		WDStencilTool *deciduousTree = (WDStencilTool *)[WDStencilTool tool];
		[deciduousTree setType:kTreeDeciduous];
		[deciduousTree setRandomRotation:YES];
		
		WDStencilTool *coniferousTree = (WDStencilTool *)[WDStencilTool tool];
		[coniferousTree setType:kTreeConiferous];
		[coniferousTree setRandomRotation:YES];

		WDStencilTool *sidewalk = (WDStencilTool *)[WDStencilTool tool];
		[sidewalk setType:kSidewalk];
		
		WDStencilTool *gazebo = (WDStencilTool *)[WDStencilTool tool];
		[gazebo setType:kGazebo];
		
		WDStencilTool *shed = (WDStencilTool *)[WDStencilTool tool];
		[shed setType:kShed];
		
		WDStencilTool *waterFeature = (WDStencilTool *)[WDStencilTool tool];
		[waterFeature setType:kWaterFeature];
        
		WDStencilTool *house = (WDStencilTool *)[WDStencilTool tool];
		[house setType:kHouse];
		
		WDScaleTool *scale = (WDScaleTool *)[WDScaleTool tool];
		
		tools_ = @[select,
                   freehand,
				   line,
				   enclosed,
				   plant,
				   shrub,
				   verticalHedge,
				   horizontalHedge,
				   deciduousTree,
				   coniferousTree,
				   sidewalk,
				   gazebo,
				   shed,
				   waterFeature,
				   house,
				   scale];
		
		self.select = select;
		self.freehand = freehand;
		self.enclosed = enclosed;
		self.plant = plant;
		self.shrub = shrub;
		self.verticalHedge = verticalHedge;
		self.horizontalHedge = horizontalHedge;
		self.deciduousTree = deciduousTree;
		self.coniferousTree = coniferousTree;
		self.sidewalk = sidewalk;
		self.gazebo = gazebo;
		self.shed = shed;
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
