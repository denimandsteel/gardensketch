//
//  DesignViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-18.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "SidebarContentViewController.h"
#import "WDToolButton.h"
#import "ColorPickerButton.h"

@interface DesignViewController : SidebarContentViewController <ColorPickerButtonDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerBackgroundView;

@property (weak, nonatomic) IBOutlet UICollectionView *toolsCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *planNameLabel;
@property (weak, nonatomic) IBOutlet WDToolButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *gridButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *cloneButton;
@property (weak, nonatomic) IBOutlet UIButton *redoButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;

- (IBAction)gridTapped:(id)sender;

- (IBAction)deleteTapped:(id)sender;
- (IBAction)cloneTapped:(id)sender;
- (IBAction)redoTapped:(id)sender;
- (IBAction)undoTapped:(id)sender;


@end
