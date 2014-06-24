//
//  SVGShapeManager.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-23.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "SVGShapeManager.h"
#import "WDPath.h"

@implementation SVGShapeManager

+ (SVGShapeManager *)sharedInstance
{
	static dispatch_once_t pred;
	static SVGShapeManager *sharedInstance = nil;
	dispatch_once(&pred, ^{
		sharedInstance = [[SVGShapeManager alloc] init];
	});
	return sharedInstance;
}

- (WDPath *)pathFromSVGFile:(NSString *)filename
{

	return nil;
}

@end
