//
//  NoteCellView.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-16.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSLabel.h"
#import "GSTextView.h"

@interface NoteCellView : UICollectionViewCell

@property (weak, nonatomic) IBOutlet GSLabel *bodyLabel;
@property (weak, nonatomic) IBOutlet GSTextView *bodyTextView;

- (void) switchToEditMode;
- (void) switchToViewMode;


@end
