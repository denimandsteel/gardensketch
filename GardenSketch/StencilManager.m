//
//  SVGShapeManager.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-23.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "StencilManager.h"
#import "WDDocument.h"
#import "WDLayer.h"
#import "WDCompoundPath.h"
#import "WDInspectableProperties.h"

// notifications
NSString *WDStencilShapeChanged = @"WDStencilShapeChanged";

@implementation StencilManager

+ (StencilManager *)sharedInstance
{
	static dispatch_once_t pred;
	static StencilManager *sharedInstance = nil;
	dispatch_once(&pred, ^{
		sharedInstance = [[StencilManager alloc] init];
	});
	return sharedInstance;
}

- (id) init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
	
	self.shapeSize = [NSMutableDictionary dictionary];
	
	[self loadShapes];
	
	self.treeColor = (TreeColor)0;
	self.shrubColor = (ShrubColor)0;
	self.plantColor = (PlantColor)0;
	
	return self;
}

- (void)loadShapes
{
	self.shapes = [NSMutableDictionary dictionary];
	// TODO: move this into a plist
	NSArray *shapeNames = @[@"gazebo", @"Tile", @"Shed", @"Plant_Dark_Green", @"Plant_Gold", @"Plant_Green", @"Plant_Grey_Green", @"Plant_Indigo", @"Plant_Light_Green", @"Plant_Light_Pink", @"Hedge_Brown", @"Hedge_Green", @"Hedge_Maroon", @"Hedge_Viridian", @"Shrub_Brown", @"Shrub_Green", @"Shrub_Maroon", @"Shrub_Viridian", @"Deciduous_Tree_Burgundy", @"Deciduous_Tree_Dark_Green", @"Deciduous_Tree_Green", @"Deciduous_Tree_Mustard", @"Deciduous_Tree_Teal", @"Deciduous_Tree_Violet", @"House_No_Lines", @"Coniferous_Burgundy", @"Coniferous_DarkGreen", @"Coniferous_Green", @"Coniferous_Mustard", @"Coniferous_Teal", @"Coniferous_Violet", @"Water_Feature", @"Rectangular_House_Horizontal", @"Rectangular_House_Vertical", @"L_Shaped_House_1", @"L_Shaped_House_2", @"L_Shaped_House_3", @"L_Shaped_House_4", @"Flower_Pot"];
	for (NSString *shapeName in shapeNames) {
		[self loadShape:shapeName];
	}
}

- (void)loadShape:(NSString *)shapeName
{
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:shapeName ofType:@"stencil"];
	
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	WDGroup *group = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	self.shapes[shapeName] = group;

	return;
	
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
//	NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:[shapeName stringByAppendingPathExtension:@"svg"]];
//	
//	NSURL *url = [[NSBundle mainBundle] URLForResource:shapeName withExtension:@"svg"];
//	
//    WDDocument *document = [[WDDocument alloc] initWithFileURL:url];
//	
//	[document openWithCompletionHandler:^(BOOL success) {
//		NSLog(@"OPEN!");
//		NSMutableArray *pathArray = [NSMutableArray arrayWithArray:[((WDLayer *)document.drawing.layers[0]) elements]];
//		WDGroup *group = [[WDGroup alloc] init];
//		
//		[group setElements:pathArray];
//		CGPoint center = CGPointMake(CGRectGetMidX(group.bounds), CGRectGetMidY(group.bounds));
//
//		CGAffineTransform translate = CGAffineTransformMakeTranslation(-center.x, -center.y);
//		[group transform:translate];
//		
//		CGAffineTransform scale = CGAffineTransformMakeScale(.1, .1);
//		[group transform:scale];
//		
//		self.shapes[shapeName] = group;
//		
//		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//		NSString *documentsDirectoryPath = [paths objectAtIndex:0];
//		NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:[shapeName stringByAppendingPathExtension:@"stencil"]];
//		[NSKeyedArchiver archiveRootObject:group toFile:filePath];
//		
//		[document closeWithCompletionHandler:^(BOOL success) {
//			NSLog(@"CLOSE!");
//		}];
//    }];

}

- (void)setActiveShapeType:(ShapeType)activeShapeType
{
	_activeShapeType = activeShapeType;
	NSDictionary *userInfo = @{@"shapeType": @(activeShapeType)};
    [[NSNotificationCenter defaultCenter] postNotificationName:WDStencilShapeChanged object:self userInfo:userInfo];
}

- (WDGroup *)shapeForType:(ShapeType)type
{
	NSString *filename = @"";
	CGFloat scale = 1.0;
	
	// 1. Pick the right shape
	switch (type) {
		case kPlant:
			switch (self.plantColor) {
				case kDarkGreen:
					filename = @"Plant_Dark_Green";
					break;
				case kGold:
					filename = @"Plant_Gold";
					break;
				case kGreen:
					filename = @"Plant_Green";
					break;
				case kGreyGreen:
					filename = @"Plant_Grey_Green";
					break;
				case kIndigo:
					filename = @"Plant_Indigo";
					break;
				case kLightGreen:
					filename = @"Plant_Light_Green";
					break;
				case kLightPink:
					filename = @"Plant_Light_Pink";
					break;
				default:
					break;
			}
			break;
		case kShrub:
			switch (self.shrubColor) {
				case kBrown:
					filename = @"Shrub_Brown";
					break;
				case kShrubGreen:
					filename = @"Shrub_Green";
					break;
				case kMaroon:
					filename = @"Shrub_Maroon";
					break;
				case kViridian:
					filename = @"Shrub_Viridian";
					break;
				default:
					break;
			}
			break;
		case kHedge:
			switch (self.shrubColor) {
				case kBrown:
					filename = @"Hedge_Brown";
					break;
				case kShrubGreen:
					filename = @"Hedge_Green";
					break;
				case kMaroon:
					filename = @"Hedge_Maroon";
					break;
				case kViridian:
					filename = @"Hedge_Viridian";
					break;
				default:
					break;
			}
			break;
		case kTreeConiferous:
			switch (self.treeColor) {
				case kBurgundy:
					filename = @"Coniferous_Burgundy";
					break;
				case kTreeDarkGreen:
					filename = @"Coniferous_DarkGreen";
					break;
				case kTreeGreen:
					filename = @"Coniferous_Green";
					break;
				case kMustard:
					filename = @"Coniferous_Mustard";
					break;
				case kTeal:
					filename = @"Coniferous_Teal";
					break;
				case kViolet:
					filename = @"Coniferous_Violet";
					break;
				default:
					filename = @"Coniferous_DarkGreen";
					break;
			}
			break;
		case kTreeDeciduous:
			switch (self.treeColor) {
				case kBurgundy:
					filename = @"Deciduous_Tree_Burgundy";
					break;
				case kTreeDarkGreen:
					filename = @"Deciduous_Tree_Dark_Green";
					break;
				case kTreeGreen:
					filename = @"Deciduous_Tree_Green";
					break;
				case kMustard:
					filename = @"Deciduous_Tree_Mustard";
					break;
				case kTeal:
					filename = @"Deciduous_Tree_Teal";
					break;
				case kViolet:
					filename = @"Deciduous_Tree_Violet";
					break;
				default:
					break;
			}
			break;
		case kSidewalk:
			filename = @"Tile";
			break;
		case kGazebo:
			filename = @"gazebo";
			break;
		case kShed:
			filename = @"Shed";
			break;
		case kHouse:
			filename = @"House_No_Lines";
			break;
		case kHouseL1:
			filename = @"L_Shaped_House_1";
			break;
		case kHouseL2:
			filename = @"L_Shaped_House_2";
			break;
		case kHouseL3:
			filename = @"L_Shaped_House_3";
			break;
		case kHouseL4:
			filename = @"L_Shaped_House_4";
			break;
		case kHouseRectHor:
			filename = @"Rectangular_House_Horizontal";
			break;
		case kHouseRectVer:
			filename = @"Rectangular_House_Vertical";
			break;
		case kWaterFeature:
			filename = @"Water_Feature";
			break;
		case kFlowerPot:
			filename = @"Flower_Pot";
			break;
		default:
			break;
	}
	
	// 2. Initial scale
	switch (type) {
		case kSidewalk:
			scale = 1.1;
			break;
		case kGazebo:
			scale = 5;
			break;
		case kShed:
			scale = 3.0;
			break;
		case kWaterFeature:
			scale = 2.5;
			break;
		case kHedge:
			scale = 1.4;
			break;
		case kTreeDeciduous:
		case kTreeConiferous:
			scale = 3;
			break;
		case kHouse:
		case kHouseL1:
		case kHouseL2:
		case kHouseL3:
		case kHouseL4:
		case kHouseRectHor:
		case kHouseRectVer:
			scale = 12;
			break;
		default:
			break;
	}
	
	// 3. Secondary scaling based on the shape size
	switch (type) {
		case kPlant:
		{
			switch (self.sizeForActiveShape) {
				case kSmall:
					scale *= 0.33;
					break;
				case kMedium:
					scale *= 1.0;
					break;
				case kBig:
					scale *= 1.67;
					break;
				default:
					break;
			}
			break;
		}
		case kFlowerPot:
		{
			switch (self.sizeForActiveShape) {
				case kSmall:
					scale *= 0.4;
					break;
				case kMedium:
					scale *= 1.2;
					break;
				case kBig:
					scale *= 2;
					break;
				default:
					break;
			}
			break;
		}

		case kShrub:
		{
			switch (self.sizeForActiveShape) {
				case kSmall:
					scale *= .67;
					break;
				case kMedium:
					scale *= 1.3;
					break;
				case kBig:
					scale *= 2;
					break;
				default:
					break;
			}
			break;
		}
		case kTreeConiferous:
		case kTreeDeciduous:
		{
			switch (self.sizeForActiveShape) {
				case kSmall:
					scale *= .6;
					break;
				case kMedium:
					scale *= 1.2;
					break;
				case kBig:
					scale *= 2;
					break;
				default:
					break;
			}
			break;
		}
		default:
		{
			switch (self.sizeForActiveShape) {
				case kSmall:
					scale *= 1;
					break;
				case kMedium:
					scale *= 1.5;
					break;
				case kBig:
					scale *= 2;
					break;
				default:
					break;
			}
			break;
		}
	}
	
	WDGroup *result = [self.shapes[filename] copy];
	
	CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
	
	[result transform:transform];
	
	return result;
}

- (void)setSizeForActiveShape:(ShapeSize)size
{
	self.shapeSize[@(self.activeShapeType)] = @(size);
}

- (ShapeSize)sizeForActiveShape
{
	return (ShapeSize)[self.shapeSize[@(self.activeShapeType)] integerValue];
}

@end
