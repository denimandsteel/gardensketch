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
#import "GSButton.h"
#import "WDDrawingController.h"

@interface ToolCell : UICollectionViewCell

@property (nonatomic, weak) WDDrawingController *drawingController;

@property (weak, nonatomic) IBOutlet UIView *primaryView;
@property (weak, nonatomic) IBOutlet UIView *secondaryView;

@property (weak, nonatomic) IBOutlet WDToolButton *toolButton;
@property (weak, nonatomic) IBOutlet GSLabel *toolNameLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *sizeButtons;
@property (weak, nonatomic) IBOutlet UIButton *smallButton;
@property (weak, nonatomic) IBOutlet UIButton *mediumButton;
@property (weak, nonatomic) IBOutlet UIButton *largeButton;

@property (weak, nonatomic) IBOutlet ColorPickerButton *colorPicker;
@property (weak, nonatomic) IBOutlet UIButton *rotateButton;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;

@property (weak, nonatomic) IBOutlet GSLabel *sizeLabel;
@property (weak, nonatomic) IBOutlet GSLabel *colorLabel;

- (IBAction)colorPickerTapped:(id)sender;
- (IBAction)sizeButtonTapped:(id)sender;
- (IBAction)repeatTapped:(id)sender;
- (IBAction)rotateTapped:(id)sender;

- (void)initialize;
- (void)activateTool;
- (void)setSelectedSizeButton:(ShapeSize)shapeSize;

@end
