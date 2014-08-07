//
//  TooolCell.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-08-06.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerButton.h"
#import "WDToolButton.h"
#import "GSLabel.h"
#import "StencilManager.h"

@interface ToolCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *primaryView;
@property (weak, nonatomic) IBOutlet UIView *secondaryView;

@property (weak, nonatomic) IBOutlet WDToolButton *toolButton;
@property (weak, nonatomic) IBOutlet GSLabel *toolNameLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *sizeButtons;
@property (weak, nonatomic) IBOutlet ColorPickerButton *colorPicker;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;


- (IBAction)colorPickerTapped:(id)sender;
- (IBAction)sizeButtonTapped:(id)sender;
- (IBAction)repeatTapped:(id)sender;


- (void)initialize;
- (void)activateTool;
- (void)setSelectedSizeButton:(ShapeSize)shapeSize;

@end
