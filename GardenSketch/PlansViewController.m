//
//  PlansViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-16.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "PlansViewController.h"
#import "WDDrawingManager.h"
#import "WDThumbnailView.h"

@interface PlansViewController ()

@end

@implementation PlansViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	WDDrawingManager *drawingManager = [WDDrawingManager sharedInstance];
	NSLog(@"%d", drawingManager.drawingNames.count);
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"WDThumbnailView" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// CollectionView delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [[WDDrawingManager sharedInstance] numberOfDrawings];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    WDThumbnailView *thumbnail = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    NSArray         *drawings = [[WDDrawingManager sharedInstance] drawingNames];
    
    thumbnail.filename = drawings[indexPath.item];
    thumbnail.tag = indexPath.item;
    thumbnail.delegate = self;
    
//    if (self.isEditing) {
//        thumbnail.shouldShowSelectionIndicator = YES;
//        thumbnail.selected = [selectedDrawings_ containsObject:thumbnail.filename] ? YES : NO;
//    }
    
    return thumbnail;
}


@end
