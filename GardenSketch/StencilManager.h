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
    kPlant,
	kHedge,
    kShrub,
	kTreeDeciduous,
    kTreeConiferous,
    kDriveway,
	kSidewalk,
	kShed,
	kWaterFeature,
	kGazebo
} ShapeType;

typedef enum {
    kRedOutline = 0,
	kDarkGreyOutline,
    kLightGreyOutline
} OutlineColor;

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

@property (nonatomic, strong) NSMutableDictionary *shapeSize;
@property (nonatomic, strong) NSMutableDictionary *shapeColor;

- (WDGroup *)shapeForType:(ShapeType)type;
- (void)setSizeForActiveShape:(ShapeSize)size;

extern NSString *WDStencilShapeChanged;

@end
