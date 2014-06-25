//
//  SVGShapeManager.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-23.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "SVGShapeManager.h"
#import "WDDocument.h"
#import "WDLayer.h"
#import "WDCompoundPath.h"

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

- (id) init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
	
	[self loadShapes];
	
	return self;
}

- (void)loadShapes
{
	self.shapes = [NSMutableDictionary dictionary];
	NSArray *shapeNames = @[@"plant", @"gazebo", @"Tile", @"Shed"];
	for (NSString *shapeName in shapeNames) {
		[self loadShape:shapeName];
	}
}

- (void)loadShape:(NSString *)shapeName
{
	NSURL *url = [[NSBundle mainBundle] URLForResource:shapeName withExtension:@"svg"];
	
    WDDocument *document = [[WDDocument alloc] initWithFileURL:url];
	
	[document openWithCompletionHandler:^(BOOL success) {
		NSLog(@"%@ opened!", shapeName);
		NSMutableArray *pathArray = [NSMutableArray arrayWithArray:[((WDLayer *)document.drawing.layers[0]) elements]];
		WDGroup *group = [[WDGroup alloc] init];
		
		[group setElements:pathArray];
		CGPoint center = CGPointMake(CGRectGetMidX(group.bounds), CGRectGetMidY(group.bounds));

		CGAffineTransform translate = CGAffineTransformMakeTranslation(-center.x, -center.y);
		[group transform:translate];
		
		CGAffineTransform scale = CGAffineTransformMakeScale(.2, .2);
		[group transform:scale];

		self.shapes[shapeName] = group;
		[document closeWithCompletionHandler:^(BOOL success) {
			NSLog(@"%@ closed!", shapeName);
		}];
    }];
}

@end
