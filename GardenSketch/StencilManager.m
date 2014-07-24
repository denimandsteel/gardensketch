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
	
	[self loadShapes];
	
	self.treeColor = (TreeColor)0;
	self.shrubColor = (ShrubColor)0;
	self.plantColor = (PlantColor)0;
	
	return self;
}

- (void)loadShapes
{
	self.shapes = [NSMutableDictionary dictionary];
	NSArray *shapeNames = @[@"gazebo", @"Tile", @"Shed", @"Plant_Dark_Green", @"Plant_Gold", @"Plant_Green", @"Plant_Grey_Green", @"Plant_Indigo", @"Plant_Light_Green", @"Plant_Light_Pink", @"Hedge_Brown", @"Hedge_Green", @"Hedge_Maroon", @"Hedge_Viridian", @"Shrub_Brown", @"Shrub_Green", @"Shrub_Maroon", @"Shrub_Viridian", @"Deciduous_Tree_Burgundy", @"Deciduous_Tree_Dark_Green", @"Deciduous_Tree_Green", @"Deciduous_Tree_Mustard", @"Deciduous_Tree_Teal", @"Deciduous_Tree_Violet", @"House_No_Lines", @"Coniferous_Dark_Green"];
	for (NSString *shapeName in shapeNames) {
		[self loadShape:shapeName];
	}
	
	NSLog(@"all done!");
}

- (void)loadShape:(NSString *)shapeName
{
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
//	NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:[shapeName stringByAppendingPathExtension:@"stencil"]];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:shapeName ofType:@"stencil"];
	
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	WDGroup *group = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	self.shapes[shapeName] = group;
	
	return;
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

- (WDGroup *)shapeForType:(ShapeType)type
{
	NSString *filename = @"";
	CGFloat scale = 1.0;
	
	// 1. Pick the right shape
	switch (type) {
		case kPlantBig:
		case kPlantSmall:
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
				case kTreeDarkGreen:
				case kTreeGreen:
				case kMustard:
				case kTeal:
				case kViolet:
				default:
					filename = @"Coniferous_Dark_Green";
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
		default:
			break;
	}
	
	// 2. Scale it
	switch (type) {
		case kPlantSmall:
			scale = .5;
			break;
		case kSidewalk:
			scale = 1.1;
			break;
		case kGazebo:
			scale = 5;
			break;
		case kShed:
			scale = 3.0;
			break;
		case kHedge:
			scale = 1.4;
			break;
		case kTreeDeciduous:
		case kTreeConiferous:
			scale = 3;
			break;
		case kHouse:
			scale = 12;
			break;
		default:
			break;
	}
	
	WDGroup *result = [self.shapes[filename] copy];
	
	CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
	
	[result transform:transform];
	
	return result;
}

@end
