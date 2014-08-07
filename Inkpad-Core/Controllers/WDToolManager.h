//
//  WDToolManager.h
//  Inkpad
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2011-2013 Steve Sprang
//

#import <Foundation/Foundation.h>
#import "WDShapeTool.h"
#import "WDScaleTool.h"
#import "WDStencilTool.h"
#import "WDFreehandTool.h"
#import "WDSelectionTool.h"

@class WDTool;

@interface WDToolManager : NSObject

@property (nonatomic, weak) WDTool *activeTool;
@property (nonatomic, strong, readonly) NSArray *tools;

@property (nonatomic, weak) WDSelectionTool *select;
@property (nonatomic, weak) WDFreehandTool	*freehand;
@property (nonatomic, weak) WDFreehandTool  *enclosed;
@property (nonatomic, weak) WDStencilTool   *plant;
@property (nonatomic, weak) WDShapeTool     *line;
@property (nonatomic, weak) WDStencilTool   *shrub;
@property (nonatomic, weak) WDStencilTool   *verticalHedge;
@property (nonatomic, weak) WDStencilTool   *horizontalHedge;
@property (nonatomic, weak) WDStencilTool   *deciduousTree;
@property (nonatomic, weak) WDStencilTool   *coniferousTree;
@property (nonatomic, weak) WDStencilTool   *tile;
@property (nonatomic, weak) WDStencilTool   *gazebo;
@property (nonatomic, weak) WDStencilTool   *shed;
@property (nonatomic, weak) WDStencilTool   *waterFeature;
@property (nonatomic, weak) WDStencilTool   *flowerPot;
@property (nonatomic, weak) WDStencilTool   *house;
@property (nonatomic, weak) WDStencilTool   *houseL1;
@property (nonatomic, weak) WDStencilTool   *houseL2;
@property (nonatomic, weak) WDStencilTool   *houseL3;
@property (nonatomic, weak) WDStencilTool   *houseL4;
@property (nonatomic, weak) WDStencilTool   *houseRectHor;
@property (nonatomic, weak) WDStencilTool   *houseRectVer;
@property (nonatomic, weak) WDScaleTool		*scale;

+ (WDToolManager *) sharedInstance;

@end

// notifications
extern NSString *WDActiveToolDidChange;
