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
#import "WDFreehandTool.h"
#import "WDInspectableProperties.h"
#import "WDPath.h"
#import "WDPropertyManager.h"
#import "WDUtilities.h"
#import "Constants.h"
#import "StencilManager.h"
#import "WDToolManager.h"

#define kMaxError 10.0f

NSString *WDDefaultFreehandTool = @"WDDefaultFreehandTool";

@implementation WDFreehandTool

@synthesize closeShape = closeShape_;

- (NSString *) iconName
{
    return closeShape_ ? @"enclosed.png" : @"freehand.png";
}

- (NSString *) toolName
{
    return closeShape_ ? @"Area" : @"Freehand Line";
}

- (BOOL) createsObject
{
    return YES;
}

- (BOOL) isDefaultForKind
{
    NSNumber *defaultFreehand = [[NSUserDefaults standardUserDefaults] valueForKey:WDDefaultFreehandTool];
    return (closeShape_ == [defaultFreehand intValue]) ? YES : NO;
}

- (void) activated
{
	if (closeShape_) {
		[[StencilManager sharedInstance] setActiveShapeType:kArea];
	} else {
		[[StencilManager sharedInstance] setActiveShapeType:kLine];
	}
	
    [[NSUserDefaults standardUserDefaults] setValue:@(closeShape_) forKey:WDDefaultFreehandTool];
}

- (void) beginWithEvent:(WDEvent *)theEvent inCanvas:(WDCanvas *)canvas
{
	[canvas.drawingController selectNone:nil];
    
    pathStarted_ = YES;
    
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
    if (pathStarted_ && [tempPath_.nodes count] > 1) {
        float maxError = (kMaxError / canvas.viewScale);
        
        canvas.shapeUnderConstruction = nil;
        
        NSMutableArray *points = [NSMutableArray array];
        for (WDBezierNode *node in tempPath_.nodes) {
            [points addObject:[NSValue valueWithCGPoint:node.anchorPoint]];
        }
        
        if (closeShape_ && tempPath_.nodes.count > 2) {
            // we're drawing free form closed shapes... let's relax the error
            maxError *= 5;
            
            // add the first point at the end to make sure we close
            CGPoint first = [points[0] CGPointValue];
            CGPoint last = [[points lastObject] CGPointValue];
                
            if (WDDistance(first, last) >= (maxError*2)) {
                [points addObject:points[0]];
            }
        }
        
        WDPath *smoothPath = [WDCurveFit smoothPathForPoints:points error:maxError attemptToClose:YES];
        
        if (smoothPath) {
			if (closeShape_) {
				smoothPath.fill = [WDColor colorWithUIColor:GS_COLOR_AREA_WATER];
				[canvas.drawingController setValue:@NO forProperty:WDStrokeVisibleProperty];
				smoothPath.fill = [canvas.drawingController.propertyManager activeFillStyle];
			} else {
				smoothPath.fill = [WDColor colorWithWhite:1.0 alpha:0.0];
				[canvas.drawingController setValue:@YES forProperty:WDStrokeVisibleProperty];
			}
			
			
			smoothPath.strokeStyle = [canvas.drawingController.propertyManager activeStrokeStyle];
            smoothPath.opacity = [[canvas.drawingController.propertyManager defaultValueForProperty:WDOpacityProperty] floatValue];
            smoothPath.shadow = [canvas.drawingController.propertyManager activeShadow];
            
            [canvas.drawing addObject:smoothPath];
//          [canvas.drawingController selectObject:smoothPath];
        }
    }
    
    pathStarted_ = NO;
    tempPath_ = nil;
	
	if (!self.staysOn) {
		// FIXME: change this to toolManager.selectionTool
		[[WDToolManager sharedInstance] setActiveTool:[WDToolManager sharedInstance].tools.firstObject];
	}
}

- (void)setStaysOnFromNumber:(NSNumber *)staysOnNumber
{
	self.staysOn = [staysOnNumber boolValue];
}

@end
