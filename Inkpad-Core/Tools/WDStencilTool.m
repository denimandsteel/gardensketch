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
#import "WDToolManager.h"

#define kMaxError 10.0f

NSString *WDDefaultStencilTool = @"WDDefaultStencilTool";

@implementation WDStencilTool

- (id)init
{
	self = [super init];
	if (self) {
		self.repeatCount = 1;
		self.randomRotation = NO;
		self.initialRotation = 0.0;
	}
	return self;
}

- (NSString *) iconName
{
	switch (self.type) {
		case kPlant:
			return @"Plant_Grey_Green.png";
			break;
		case kShrub:
			return @"Shrub_Brown.png";
			break;
		case kHedge:
			if (self.initialRotation > 0.0)		return @"Hedge_brown_horizontal.png";
			else								return @"Hedge_brown.png";
			break;
		case kTreeConiferous:
			return @"Coniferous_Dark_Green.png";
			break;
		case kTreeDeciduous:
			return @"Tree_Green.png";
			break;
		case kSidewalk:
			return @"Tile.png";
			break;
		case kGazebo:
			return @"Gazebo.png";
			break;
		case kShed:
			return @"Shed.png";
			break;
		case kHouse:
			return @"House_No_Lines.png";
			break;
		case kHouseL1:
			return @"L_Shaped_House_1.png";
			break;
		case kHouseL2:
			return @"L_Shaped_House_2.png";
			break;
		case kHouseL3:
			return @"L_Shaped_House_3.png";
			break;
		case kHouseL4:
			return @"L_Shaped_House_4.png";
			break;
		case kHouseRectVer:
			return @"Rectangular_House_Vertical.png";
			break;
		case kHouseRectHor:
			return @"Rectangular_House_Horizontal.png";
			break;
		case kWaterFeature:
			return @"Water_Feature.png";
			break;
		case kFlowerPot:
			return @"Flower_Pot.png";
			break;
		default:
			return @"";
			break;
	}
    return nil;
}

- (NSString *) toolName
{
	switch (self.type) {
		case kPlant:
			return @"Plant";
			break;
		case kShrub:
			return @"Shrub";
			break;
		case kHedge:
			return @"Hedge";
			break;
		case kTreeConiferous:
			return @"Needly Tree";
			break;
		case kTreeDeciduous:
			return @"Leafy Tree";
			break;
		case kSidewalk:
			return @"Tile";
			break;
		case kGazebo:
			return @"Gazebo";
			break;
		case kShed:
			return @"Shed";
			break;
		case kHouse:
			return @"House";
			break;
		case kHouseL1:
			return @"House";
			break;
		case kHouseL2:
			return @"House";
			break;
		case kHouseL3:
			return @"House";
			break;
		case kHouseL4:
			return @"House";
			break;
		case kHouseRectVer:
			return @"House";
			break;
		case kHouseRectHor:
			return @"House";
			break;
		case kWaterFeature:
			return @"Water Feature";
			break;
		case kFlowerPot:
			return @"Flower Pot";
			break;
		default:
			return @"Stencil";
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
	[[StencilManager sharedInstance] setActiveShapeType:self.type];
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
    [canvas invalidateSelectionView];
}

- (void) endWithEvent:(WDEvent *)theEvent inCanvas:(WDCanvas *)canvas
{
    if (pathStarted_) {
		WDElement *result = nil;
        CGPoint center = theEvent.location;
        
		if (self.repeatCount > 1) {
			NSMutableArray *elements = [NSMutableArray arrayWithCapacity:self.repeatCount];
			for (NSInteger i = 0; i < self.repeatCount; i++) {
				elements[i] = [self singleShapeAtPoint:center];
			}
			WDGroup *group = [[WDGroup alloc] init];
			[group setElements:elements];
			result = group;
		} else {
			result = [self singleShapeAtPoint:center];
		}
		
        [canvas.drawing addObject:result];
		if (self.type == kHouse ||
			self.type == kHouseL1 ||
			self.type == kHouseL2 ||
			self.type == kHouseL3 ||
			self.type == kHouseL4 ||
			self.type == kHouseRectHor ||
			self.type == kHouseRectVer) {
			[canvas.drawingController selectObject:result];
		}
	}
    
    pathStarted_ = NO;
    tempPath_ = nil;
	
	if (!self.staysOn) {
		// FIXME: change this to toolManager.selectionTool
		[[WDToolManager sharedInstance] setActiveTool:[WDToolManager sharedInstance].tools.firstObject];
	}
	
}

- (WDElement *)singleShapeAtPoint:(CGPoint)center
{
	WDElement *element = [[StencilManager sharedInstance] shapeForType:self.type];
	
	if (self.randomRotation) {
		float randomAngle = ((float)rand() / RAND_MAX) * M_PI;
		CGAffineTransform rotate = CGAffineTransformMakeRotation(randomAngle);
		[element transform:rotate];
	}
	
	if (self.initialRotation > 0.0) {
		CGAffineTransform rotate = CGAffineTransformMakeRotation(self.initialRotation);
		[element transform:rotate];
	}
	
	CGAffineTransform transform = CGAffineTransformMakeTranslation(center.x, center.y);
	
	[element transform:transform];
	
	return element;
}

- (void)setStaysOnFromNumber:(NSNumber *)staysOnNumber
{
	// no repeat for house shapes
	if (self.type == kHouse ||
		self.type == kHouseL1 ||
		self.type == kHouseL2 ||
		self.type == kHouseL3 ||
		self.type == kHouseL4 ||
		self.type == kHouseRectHor ||
		self.type == kHouseRectVer) {
		self.staysOn = NO;
	} else {
		self.staysOn = [staysOnNumber boolValue];
	}
}


@end
