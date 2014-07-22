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
#import "GSNote.h"

NSString *LETTERS = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";

@interface NotesViewController ()

@end

@implementation NotesViewController {
	NSIndexPath *activeIndexPath;
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
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"NoteCellView" bundle:nil] forCellWithReuseIdentifier:@"NoteCellIdentifier"];
	
	[self registerForKeyboardNotifications];
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
	GSNote *note = ((GSNote *)self.sidebar.canvasController.drawing.notes[indexPath.row]);
	
	NoteCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoteCellIdentifier" forIndexPath:indexPath];
	[cell.bodyLabel setText:note.bodyText];
	[cell.bodyTextView setText:note.bodyText];
	NSString *letter = [LETTERS substringWithRange:NSMakeRange(note.letterIndex, 1)];
	[cell.letterLabel setText:letter];
	cell.delegate = self;
	[cell.bodyTextView setDelegate:cell];
	return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Did select!");

//	NoteCellView *noteCell = (NoteCellView *)[collectionView cellForItemAtIndexPath:indexPath];
//	
//	[noteCell switchToEditMode];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	// TODO: call invalidateLayout after a note has been edited, to receive a call here:
	
	NSString *text = ((GSNote *)self.sidebar.canvasController.drawing.notes[indexPath.row]).bodyText;
	
	NSDictionary *attributes = @{NSFontAttributeName:GS_FONT_AVENIR_BODY};
	// NSString class method: boundingRectWithSize:options:attributes:context is
	// available only on ios7.0 sdk.
	CGRect rect = [text boundingRectWithSize:CGSizeMake(210.0, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
	
	// TODO add some margins for the top and the bottom of the note body text.
	rect.size.height = MAX(rect.size.height, NOTE_CELL_MIN_HEIGHT) + 20;
	rect.size.width = 280;
	return rect.size;
}

- (IBAction)addNoteTapped:(id)sender {
	NSDateFormatter *formatter;
	NSString        *dateString;
	
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
	
	dateString = [formatter stringFromDate:[NSDate date]];
	
	GSNote *anotherNote = [self createNoteWithText:dateString];
	
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

- (GSNote *)createNoteWithText:(NSString *)text
{
	GSNote * result = [[GSNote alloc] init];
	[result setBodyText:text];
	[result setPosition:CGPointMake(0, 0)];
	
	NSInteger smallestIndexAvailable = 0;
	
	NSMutableArray *occupiedIndexArray = [NSMutableArray array];
	for (GSNote *note in self.sidebar.canvasController.drawing.notes) {
		[occupiedIndexArray addObject:@(note.letterIndex)];
	}
	
	NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
	[occupiedIndexArray sortUsingDescriptors:[NSArray arrayWithObject:lowestToHighest]];
	
	for (NSNumber *taken in occupiedIndexArray) {
		if (taken.intValue == smallestIndexAvailable) {
			smallestIndexAvailable++;
		} else {
			break;
		}
	}
	
	result.letterIndex = smallestIndexAvailable;
	
	NSLog(@"smallest index: %lu", smallestIndexAvailable);
	
	return result;
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

- (void)updateNoteForCell:(id)sender
{
	NoteCellView *noteCellView = (NoteCellView *)sender;
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:noteCellView];
	NSInteger index = indexPath.row;
	
	NSString *updatedNoteBody = noteCellView.bodyLabel.text;
	
	[self.sidebar.canvasController.drawing.notes[index] setBodyText:updatedNoteBody];
	[self.sidebar.canvasController.document updateChangeCount:UIDocumentChangeDone];
	
	// to take care of possible height changes on the cell:
	[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
	
	activeIndexPath = nil;
}

- (void)willSwitchToEditMode:(id)sender
{
	NoteCellView *noteCellView = (NoteCellView *)sender;
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:noteCellView];
	
	activeIndexPath = indexPath;
	
	[self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
	for (NoteCellView *noteCell in self.collectionView.visibleCells) {
		if (noteCell != sender) {
			[noteCell switchToViewMode];
		}
	}
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
	
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    
	CGRect rawKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	CGRect properlyRotatedCoords = [self.view.window convertRect:rawKeyboardRect toView:self.view.window.rootViewController.view];
	CGSize kbSize = properlyRotatedCoords.size;
	
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.collectionView.contentInset = contentInsets;
    self.collectionView.scrollIndicatorInsets = contentInsets;
	
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.collectionView.frame;
    aRect.size.height -= kbSize.height;
    [self.collectionView scrollToItemAtIndexPath:activeIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.collectionView.contentInset = contentInsets;
    self.collectionView.scrollIndicatorInsets = contentInsets;
}


@end
