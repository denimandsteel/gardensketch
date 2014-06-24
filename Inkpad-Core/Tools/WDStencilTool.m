//
//  WDFreehandTool.m
//  Inkpad
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2011-2013 Steve Sprang
//

#import "WDBezierNode.h"
#import "WDCanvas.h"
#import "WDColor.h"
#import "WDCurveFit.h"
#import "WDDrawingController.h"
#import "WDStencilTool.h"
#import "WDInspectableProperties.h"
#import "WDPath.h"
#import "WDPropertyManager.h"
#import "WDUtilities.h"
#import "SVGShapeManager.h"

#define kMaxError 10.0f

NSString *WDDefaultStencilTool = @"WDDefaultStencilTool";

@implementation WDStencilTool

@synthesize closeShape = closeShape_;

- (NSString *) iconName
{
    return @"structure";
}

- (BOOL) createsObject
{
    return YES;
}

- (BOOL) isDefaultForKind
{
    NSNumber *defaultFreehand = [[NSUserDefaults standardUserDefaults] valueForKey:WDDefaultStencilTool];
    return (closeShape_ == [defaultFreehand intValue]) ? YES : NO;
}

- (void) activated
{
    [[NSUserDefaults standardUserDefaults] setValue:@(closeShape_) forKey:WDDefaultStencilTool];
}

- (void) beginWithEvent:(WDEvent *)theEvent inCanvas:(WDCanvas *)canvas
{
	if (closeShape_) {
		[canvas.drawingController setValue:[WDColor randomColor] forProperty:WDFillProperty];
	} else {
		[canvas.drawingController setValue:[NSNull null] forProperty:WDFillProperty];
	}
    
	[canvas.drawingController selectNone:nil];
    
    pathStarted_ = YES;
    
    // TODO: change this to show the sillouhette of the stencil to be drawn!
	tempPath_ = [[WDPath alloc] init];
	canvas.shapeUnderConstruction = tempPath_;
    
    [self moveWithEvent:theEvent inCanvas:canvas];
}

- (void) moveWithEvent:(WDEvent *)theEvent inCanvas:(WDCanvas *)canvas
{
    [tempPath_.nodes addObject:[WDBezierNode bezierNodeWithAnchorPoint:theEvent.location]];
    [canvas invalidateSelectionView];
}

- (void) endWithEvent:(WDEvent *)theEvent inCanvas:(WDCanvas *)canvas
{
    if (pathStarted_) {
        CGPoint center = theEvent.location;
		
		CGRect rect = WDRectWithPointsConstrained(CGPointMake(center.x-20, center.y-20), CGPointMake(center.x+20, center.y+20), NO);
        WDPath *smoothPath = [WDPath pathWithOvalInRect:rect];
		
		WDGroup *group = [[SVGShapeManager sharedInstance].testGroup copy];
		
		CGAffineTransform transform = CGAffineTransformMakeTranslation(center.x, center.y);
		
		[group transform:transform];
        
        if (smoothPath) {
            smoothPath.fill = [canvas.drawingController.propertyManager activeFillStyle];
            smoothPath.strokeStyle = [canvas.drawingController.propertyManager activeStrokeStyle];
            smoothPath.opacity = [[canvas.drawingController.propertyManager defaultValueForProperty:WDOpacityProperty] floatValue];
            smoothPath.shadow = [canvas.drawingController.propertyManager activeShadow];
            
            [canvas.drawing addObject:group];
//            [canvas.drawingController selectObject:group];
        }
	}
    
    pathStarted_ = NO;
    tempPath_ = nil;
}

@end
