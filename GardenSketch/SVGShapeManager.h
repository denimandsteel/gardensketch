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

@interface SVGShapeManager : NSObject

+ (SVGShapeManager *)sharedInstance;

@property (nonatomic, strong) NSMutableDictionary *shapes;

@end
