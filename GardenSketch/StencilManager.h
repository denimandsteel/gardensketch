//
//  SVGShapeManager.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-23.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDPath.h"
#import "WDGroup.h"

typedef enum {
    kPlantBig,
	kPlantSmall,
	kHedge,
    kShrub,
	kTreeDeciduous,
    kTreeConiferous,
    kDriveway,
	kSidewalk,
	kShed,
	kGazebo
} ShapeType;

typedef enum {
    kDarkGreen = 0,
	kGold,
	kGreen,
    kGreyGreen,
	kIndigo,
    kLightGreen,
    kLightPink
} PlantColor;

typedef enum {
    kBrown = 0,
	kShrubGreen,
    kMaroon,
	kViridian
} ShrubColor;

typedef enum {
    kBurgundy = 0,
	kTreeDarkGreen,
	kTreeGreen,
    kMustard,
	kTeal,
    kViolet
} TreeColor;

@interface StencilManager : NSObject

+ (StencilManager *)sharedInstance;

@property (nonatomic, strong) NSMutableDictionary *shapes;
@property (nonatomic, assign) PlantColor plantColor;
@property (nonatomic, assign) ShrubColor shrubColor;
@property (nonatomic, assign) TreeColor treeColor;

- (WDGroup *)shapeForType:(ShapeType)type;

@end
