//
//  NotesViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-16.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "NotesViewController.h"
#import "NoteCellView.h"
#import "WDDrawing.h"
#import "Constants.h"
#import "WDDocument.h"

@interface NotesViewController ()

@end

@implementation NotesViewController

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
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"NoteCellView" bundle:nil] forCellWithReuseIdentifier:@"NoteCellIdentifier"];
}

- (void)viewDidAppear:(BOOL)animated
{
	[self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// CollectionView delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.sidebar.canvasController.drawing.notes.count;
}

#pragma mark Collection View delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	NoteCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoteCellIdentifier" forIndexPath:indexPath];
	[cell.bodyLabel setText:self.sidebar.canvasController.drawing.notes[indexPath.row]];
	cell.delegate = self;
	return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Did select!");

	NoteCellView *noteCell = (NoteCellView *)[collectionView cellForItemAtIndexPath:indexPath];
	
	[noteCell switchToEditMode];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	// TODO: call invalidateLayout after a note has been edited, to receive a call here:
	// TODO: Use
	
	NSString *text = self.sidebar.canvasController.drawing.notes[indexPath.row];
	
	NSDictionary *attributes = @{NSFontAttributeName:GS_FONT_AVENIR_BODY};
	// NSString class method: boundingRectWithSize:options:attributes:context is
	// available only on ios7.0 sdk.
	CGRect rect = [text boundingRectWithSize:CGSizeMake(210.0, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
	
	// TODO add some margins for the top and the bottom of the note body text.
	rect.size.height = MAX(rect.size.height, NOTE_CELL_MIN_HEIGHT);
	rect.size.width = 280;
	return rect.size;
}

- (IBAction)addNoteTapped:(id)sender {
	NSDateFormatter *formatter;
	NSString        *dateString;
	
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
	
	dateString = [formatter stringFromDate:[NSDate date]];
	NSString *anotherNote = dateString;
	[self.sidebar.canvasController.drawing.notes addObject:anotherNote];
	[self.sidebar.canvasController.document updateChangeCount:UIDocumentChangeDone];
	
	NSUInteger count = self.sidebar.canvasController.drawing.notes.count - 1;
    NSArray *indexPaths = @[[NSIndexPath indexPathForItem:count inSection:0]];
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
	
	// scroll to the very bottom, so that the add button is visible
	NSInteger item = [self collectionView:self.collectionView numberOfItemsInSection:0] - 1;
	NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
	[self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}

- (void)removeNoteForCell:(id)sender
{
	NoteCellView *noteCellView = (NoteCellView *)sender;
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:noteCellView];
	NSInteger index = indexPath.row;
	
	[self.sidebar.canvasController.drawing.notes removeObjectAtIndex:index];
	[self.sidebar.canvasController.document updateChangeCount:UIDocumentChangeDone];
	
	[self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}


@end
