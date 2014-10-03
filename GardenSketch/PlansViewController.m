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
#import "WDCanvasController.h"
#import "Constants.h"
#import "WDToolManager.h"
#import "NSURL+Equivalence.h"
#import "Mixpanel.h"

@interface PlansViewController ()

@end

@implementation PlansViewController {
	NSIndexPath *selectedIndexPath;
}

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
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawingsDeleted:)
                                                 name:WDDrawingsDeleted
                                               object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"WDThumbnailView" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
	[self.collectionView registerNib:[UINib nibWithNibName:@"NewPlanCell" bundle:nil] forCellWithReuseIdentifier:@"newCellID"];
	
	self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(canvasTapped:)];
	[self.sidebar.canvasController.view addGestureRecognizer:self.tapRecognizer];
	
	selectedIndexPath = nil;
}

- (void)canvasTapped:(UIGestureRecognizer *)gestureRecognizer
{
	// Switch to design tab
	[self.sidebar setSelectedIndex:4];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	WDToolManager *toolManager = [WDToolManager sharedInstance];
	[toolManager setActiveTool:toolManager.select];
	
	NSInteger numberOfPlans = [[WDDrawingManager sharedInstance] numberOfDrawings];
	
	if (numberOfPlans > 0) {
		if (!self.sidebar.canvasController.document ||
			[self.sidebar.canvasController.document.filename isEqualToString:GS_BASE_PLAN_FILE_NAME]) {
			NSIndexPath *mostRecent = [NSIndexPath indexPathForRow:numberOfPlans-1 inSection:0];
			[self.collectionView selectItemAtIndexPath:mostRecent animated:YES scrollPosition:UICollectionViewScrollPositionBottom];
			[self collectionView:self.collectionView didSelectItemAtIndexPath:mostRecent];
		}
	} else {
		[self.sidebar.canvasController setDocument:nil];
	}
	
	[self.tapRecognizer setEnabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[self.tapRecognizer setEnabled:NO];
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

#pragma mark Collection View delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	WDThumbnailView *thumbnail = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
	NSArray         *plans = [[WDDrawingManager sharedInstance] drawingNames];
	
	thumbnail.filename = plans[indexPath.item];
	thumbnail.tag = indexPath.item;
	thumbnail.delegate = self;
	
	[thumbnail.actionView.layer setCornerRadius:5.0];
	[thumbnail.actionView.layer setMasksToBounds:YES];
	
	return thumbnail;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Did select called!");
	
	selectedIndexPath = indexPath;

	WDDocument *document = [[WDDrawingManager sharedInstance] openDocumentAtIndex:indexPath.row withCompletionHandler:nil];
	if ([self.sidebar.canvasController.document.fileURL isEquivalent:document.fileURL]) {
		// TODO: switch to design tab if already selected
		NSLog(@"Should switch to design tab");
	} else {
		[self.sidebar.canvasController setDocument:document];
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
    NSUInteger index = [[WDDrawingManager sharedInstance] numberOfDrawings] - 1;
    NSArray *indexPaths = @[[NSIndexPath indexPathForItem:index inSection:0]];
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
	
	// scroll to the very bottom, so that the newly added plan is visible
	NSInteger item = [self collectionView:self.collectionView numberOfItemsInSection:0] - 1;
	NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
	[self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
	
	[self.collectionView selectItemAtIndexPath:lastIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionBottom];
	
	[(WDThumbnailView *)[self.collectionView cellForItemAtIndexPath:lastIndexPath] showActions];
	
	[[Mixpanel sharedInstance] track:@"Plan_Added"];
	
	if (index == 0) {
		// Switch to deisgn tab, when the first plan is added
		[self.sidebar setSelectedIndex:4];
	}
}

- (void) drawingsDeleted:(NSNotification *)aNotification
{
    NSArray *indexPaths = aNotification.object;
    [self.collectionView deleteItemsAtIndexPaths:indexPaths];
	
	NSInteger count = [self.collectionView numberOfItemsInSection:0];
	
	if (count > 0) {
		[self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:count-1 inSection:0]];
	} else {
		// no plans left.
		[self.sidebar.canvasController setDocument:nil];
		selectedIndexPath = nil;
	}
}

#pragma mark -

- (void)createNewDrawing
{
	WDDrawingManager *drawingManager = [WDDrawingManager sharedInstance];
	
    WDDocument *document = [drawingManager createNewDrawingWithSize:[drawingManager basePlanSize]
                                                                              andUnits:@"Centimeters"];
	
    [self.sidebar.canvasController setDocument:document];
}

#pragma mark - keyboard

- (void) keyboardWillShow:(NSNotification *)aNotification
{
    NSValue     *endFrame = [aNotification userInfo][UIKeyboardFrameEndUserInfoKey];
    CGRect      frame = [endFrame CGRectValue];
    float       delta = 0;
    
    CGRect thumbFrame = editingThumbnail_.frame;
    thumbFrame.size.height += 20; // add a little extra margin between the thumb and the keyboard
    frame = [self.collectionView convertRect:frame fromView:nil];
    
    if (CGRectIntersectsRect(thumbFrame, frame)) {
        delta = CGRectGetMaxY(thumbFrame) - CGRectGetMinY(frame);
        
        CGPoint offset = self.collectionView.contentOffset;
        offset.y += delta;
        [self.collectionView setContentOffset:offset animated:YES];
    }
}

- (void) didEnterBackground:(NSNotification *)aNotification
{
    if (!editingThumbnail_) {
        return;
    }
    
    [editingThumbnail_ stopEditing];
}

#pragma mark - Thumbnail Editing

- (BOOL) thumbnailShouldBeginEditing:(WDThumbnailView *)thumb
{
    if (self.isEditing) {
        return NO;
    }
    
    // can't start editing if we're already editing another thumbnail
    return (editingThumbnail_ ? NO : YES);
}

- (void) blockingViewTapped:(id)sender
{
    [editingThumbnail_ stopEditing];
}

- (void) thumbnailDidBeginEditing:(WDThumbnailView *)thumbView
{
    editingThumbnail_ = thumbView;
}

- (void) thumbnailDidEndEditing:(WDThumbnailView *)thumbView
{
    editingThumbnail_ = nil;
}

- (void) duplicateTapped:(WDThumbnailView *)thumbView
{
	[self.sidebar.canvasController duplicateDrawing:self];
}

- (void) shareTapped:(WDThumbnailView *)thumbView
{
	[self.sidebar.canvasController exportAsPNG:self];
}

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

- (IBAction)addButtonTapped:(id)sender {
	[self createNewDrawing];
}

- (void)willGetSelected
{
	if (selectedIndexPath) {
		[self collectionView:self.collectionView didSelectItemAtIndexPath:selectedIndexPath];
	}
}

@end
