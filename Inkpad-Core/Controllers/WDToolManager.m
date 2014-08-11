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
		[plant setRepeatCount:1];
		
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
		
		WDStencilTool *flowerPot = (WDStencilTool *)[WDStencilTool tool];
		[flowerPot setType:kFlowerPot];
        
		WDStencilTool *house = (WDStencilTool *)[WDStencilTool tool];
		[house setType:kHouse];
		
		WDStencilTool *houseL1 = (WDStencilTool *)[WDStencilTool tool];
		[houseL1 setType:kHouseL1];
		
		WDStencilTool *houseL2 = (WDStencilTool *)[WDStencilTool tool];
		[houseL2 setType:kHouseL2];
		
		WDStencilTool *houseL3 = (WDStencilTool *)[WDStencilTool tool];
		[houseL3 setType:kHouseL3];
		
		WDStencilTool *houseL4 = (WDStencilTool *)[WDStencilTool tool];
		[houseL4 setType:kHouseL4];
		
		WDStencilTool *houseRectHor = (WDStencilTool *)[WDStencilTool tool];
		[houseRectHor setType:kHouseRectHor];
		
		WDStencilTool *houseRectVer = (WDStencilTool *)[WDStencilTool tool];
		[houseRectVer setType:kHouseRectVer];
		
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
				   flowerPot,
				   house,
				   houseL1,
				   houseL2,
				   houseL3,
				   houseL4,
				   houseRectHor,
				   houseRectVer,
				   scale];
		
		self.select = select;
		self.freehand = freehand;
		self.enclosed = enclosed;
		self.line = line;
		self.plant = plant;
		self.shrub = shrub;
		self.hedge = horizontalHedge;
		self.deciduousTree = deciduousTree;
		self.coniferousTree = coniferousTree;
		self.tile = sidewalk;
		self.gazebo = gazebo;
		self.shed = shed;
		self.waterFeature = waterFeature;
		self.flowerPot = flowerPot;
		self.house = house;
		self.houseL1 = houseL1;
		self.houseL2 = houseL2;
		self.houseL3 = houseL3;
		self.houseL4 = houseL4;
		self.houseRectHor = houseRectHor;
		self.houseRectVer = houseRectVer;
		self.scale = scale;
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
