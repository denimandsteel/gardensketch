//
//  WDScaleTool.m
//  Inkpad
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2011-2013 Steve Sprang
//

#import "WDScaleTool.h"
#import "WDUtilities.h"

#define INVERTED_CONSTRAIN YES

@implementation WDScaleTool

- (NSString *) iconName
{
    return @"scale-icon.png";
}

- (CGAffineTransform) computeTransform:(CGPoint)pt pivot:(CGPoint)pivot constrain:(WDToolFlags)flags
{

	float scale = ABS( WDDistance(pt, pivot) / WDDistance(self.initialEvent.location, pivot) );
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(pivot.x, pivot.y);
    transform = CGAffineTransformScale(transform, scale, scale);
    transform = CGAffineTransformTranslate(transform, -pivot.x, -pivot.y);
    
    return transform;
}

@end
