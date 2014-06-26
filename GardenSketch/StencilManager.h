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
	kTree1,
    kTree2,
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

@interface StencilManager : NSObject

+ (StencilManager *)sharedInstance;

@property (nonatomic, strong) NSMutableDictionary *shapes;
@property (nonatomic, assign) PlantColor plantColor;

- (WDGroup *)shapeForType:(ShapeType)type;

@end
