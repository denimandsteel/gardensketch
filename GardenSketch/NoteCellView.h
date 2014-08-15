//
//  NoteCellView.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-16.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSLabel.h"
#import "GSLabelHead.h"
#import "GSTextView.h"

@protocol NoteCellDelegate <NSObject>

- (void)removeNoteForCell:(id)sender;
- (void)updateNoteForCell:(id)sender;
- (void)willSwitchToEditMode:(id)sender;

@end

@interface NoteCellView : UICollectionViewCell <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet GSLabel *bodyLabel;
@property (weak, nonatomic) IBOutlet GSTextView *bodyTextView;
@property (weak, nonatomic) IBOutlet GSLabelHead *letterLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@property (nonatomic, assign) id<NoteCellDelegate> delegate;

- (void) switchToEditMode;
- (void) switchToViewMode;

- (IBAction)deleteTapped:(id)sender;

@end
