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
	kHouse,
	kHouseRectHor,
	kHouseRectVer,
	kHouseL1,
    kHouseL2,
    kHouseL3,
    kHouseL4,
    kPlant,
	kHedge,
    kShrub,
	kTreeDeciduous,
    kTreeConiferous,
    kDriveway,
	kSidewalk,
	kShed,
	kWaterFeature,
	kGazebo,
	kLine,
	kArea,
	kFlowerPot
} ShapeType;

typedef enum {
    kRedOutline = 0,
	kDarkGreyOutline,
    kLightGreyOutline
} OutlineColor;

typedef enum {
    kAreaWater = 0,
	kAreaSand,
    kAreaGreen,
	kAreaWarmGrey,
	kAreaCoolGrey
} AreaColor;

typedef enum {
    kGold = 0,
	kLightGreen,
    kGreen,
    kDarkGreen,
	kGreyGreen,
	kIndigo,
    kLightPink
} PlantColor;

typedef enum {
    kShrubGreen = 0,
    kViridian,
	kMaroon,
	kBrown
} ShrubColor;

typedef enum {
    kMustard = 0,
	kTreeGreen,
    kTreeDarkGreen,
	kTeal,
    kViolet,
	kBurgundy
} TreeColor;

typedef enum {
	kSmall = 0,
	kMedium,
	kBig
} ShapeSize;


@interface StencilManager : NSObject

+ (StencilManager *)sharedInstance;

@property (nonatomic, strong) NSMutableDictionary *shapes;

@property (nonatomic, assign) ShapeType activeShapeType;

@property (nonatomic, assign) PlantColor plantColor;
@property (nonatomic, assign) ShrubColor shrubColor;
@property (nonatomic, assign) TreeColor treeColor;
@property (nonatomic, assign) OutlineColor outlineColor;
@property (nonatomic, assign) AreaColor areaColor;

@property (nonatomic, strong) NSMutableDictionary *shapeSize;

- (WDGroup *)shapeForType:(ShapeType)type;
- (void)setSizeForActiveShape:(ShapeSize)size;
- (ShapeSize)sizeForActiveShape;

extern NSString *WDStencilShapeChanged;

@end
