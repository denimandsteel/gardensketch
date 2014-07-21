//
//  NotesViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-16.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "SidebarContentViewController.h"
#import "NoteCellView.h"

@interface NotesViewController : SidebarContentViewController <UICollectionViewDataSource,
																UICollectionViewDelegate,
																NoteCellDelegate,
																UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *addNoteButton;

- (IBAction)addNoteTapped:(id)sender;


@end
