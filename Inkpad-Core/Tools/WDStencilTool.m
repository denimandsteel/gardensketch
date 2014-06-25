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

- (NSString *) iconName
{
	switch (self.type) {
		case kPlantBig:
			return @"Plant_Grey_Green.png";
		case kPlantSmall:
			return @"Plant_Grey_Green.png";
			break;
		case kGazebo:
			return @"Gazebo.png";
			break;
		default:
			return @"";
			break;
	}
    return nil;
}

- (BOOL) createsObject
{
    return YES;
}

- (BOOL) isDefaultForKind
{
    return YES;
}

- (void) activated
{
}

- (void) beginWithEvent:(WDEvent *)theEvent inCanvas:(WDCanvas *)canvas
{
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
        
		WDElement *element = [self shapeForType:self.type];
		
		CGAffineTransform transform = CGAffineTransformMakeTranslation(center.x, center.y);
		
		[element transform:transform];
        
        [canvas.drawing addObject:element];
	}
    
    pathStarted_ = NO;
    tempPath_ = nil;
}

- (WDGroup *)shapeForType:(ShapeType)type
{
	NSString *filename = @"";
	CGFloat scale = 1.0;
	
	switch (type) {
		case kPlantBig:
			filename = @"plant";
			break;
		case kPlantSmall:
			filename = @"plant";
			scale = .5;
			break;
		case kGazebo:
			filename = @"gazebo";
			break;
		default:
			break;
	}
	
	WDGroup *result = [[SVGShapeManager sharedInstance].shapes[filename] copy];
	
	CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
	
	[result transform:transform];
	
	return result;
}

@end
