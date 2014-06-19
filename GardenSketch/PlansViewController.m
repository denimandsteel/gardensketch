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
#import "WDDocument.h"

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
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawingChanged:)
                                                 name:UIDocumentStateChangedNotification
                                               object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawingAdded:)
                                                 name:WDDrawingAdded
                                               object:nil];
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"WDThumbnailView" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
	[self.collectionView registerNib:[UINib nibWithNibName:@"NewPlanCell" bundle:nil] forCellWithReuseIdentifier:@"newCellID"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// CollectionView delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [[WDDrawingManager sharedInstance] numberOfDrawings] + 1; // add new
}

#pragma mark Collection View delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	if (indexPath.row < [collectionView numberOfItemsInSection:0] - 1) {
		WDThumbnailView *thumbnail = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
		NSArray         *drawings = [[WDDrawingManager sharedInstance] drawingNames];
		
		thumbnail.filename = drawings[indexPath.item];
		thumbnail.tag = indexPath.item;
		thumbnail.delegate = self;
		return thumbnail;
	} else {
		UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newCellID" forIndexPath:indexPath];
		return cell;
	}
    
    
//    if (self.isEditing) {
//        thumbnail.shouldShowSelectionIndicator = YES;
//        thumbnail.selected = [selectedDrawings_ containsObject:thumbnail.filename] ? YES : NO;
//    }
    
    
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select!");
	if (indexPath.row < [collectionView numberOfItemsInSection:0] - 1) {
		WDDocument *document = [[WDDrawingManager sharedInstance] openDocumentAtIndex:indexPath.row withCompletionHandler:nil];
		[self.sidebar.canvasController setDocument:document];
	} else {
		[self createNewDrawing:nil];
	}
	
}

#pragma mark - Thumbnail Editing

- (WDThumbnailView *) getThumbnail:(NSString *)filename
{
    NSString *barefile = [[filename stringByDeletingPathExtension] stringByAppendingPathExtension:@"inkpad"];
    NSIndexPath *indexPath = [[WDDrawingManager sharedInstance] indexPathForFilename:barefile];
    
	UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
	
	if ([cell isKindOfClass:[WDThumbnailView class]]) {
		return (WDThumbnailView *)cell;
	} else {
		return nil;
	}
}

#pragma mark - Drawing Notifications

- (void) drawingChanged:(NSNotification *)aNotification
{
    WDDocument *document = [aNotification object];
    
    [[self getThumbnail:document.filename] reload];
}

- (void) drawingAdded:(NSNotification *)aNotification
{
    NSUInteger count = [[WDDrawingManager sharedInstance] numberOfDrawings] - 1;
    NSArray *indexPaths = @[[NSIndexPath indexPathForItem:count inSection:0]];
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
}

#pragma mark -

- (void) createNewDrawing:(id)sender
{
    WDDocument *document = [[WDDrawingManager sharedInstance] createNewDrawingWithSize:CGSizeMake(1024, 1024)
                                                                              andUnits:@"Centimeters"];
	
    [self.sidebar.canvasController setDocument:document];
}

@end
