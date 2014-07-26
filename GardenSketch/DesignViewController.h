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

@property (weak, nonatomic) IBOutlet UIView *plantsView;
@property (weak, nonatomic) IBOutlet UIView *structuresView;


@property (weak, nonatomic) IBOutlet UILabel *planNameLabel;
@property (weak, nonatomic) IBOutlet WDToolButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *gridButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *sizeButtons;
@property (weak, nonatomic) IBOutlet ColorPickerButton *colorPicker;

@property (weak, nonatomic) IBOutlet WDToolButton *freehandButton;
@property (weak, nonatomic) IBOutlet WDToolButton *straightLineButton;
@property (weak, nonatomic) IBOutlet WDToolButton *enclosedButton;

@property (weak, nonatomic) IBOutlet WDToolButton *plantButton;

@property (weak, nonatomic) IBOutlet WDToolButton *shrubButton;
@property (weak, nonatomic) IBOutlet WDToolButton *verticalHedgeButton;
@property (weak, nonatomic) IBOutlet WDToolButton *horizontalHedgeButton;

@property (weak, nonatomic) IBOutlet WDToolButton *deciduousTreeButton;
@property (weak, nonatomic) IBOutlet WDToolButton *coniferousTreeButton;

@property (weak, nonatomic) IBOutlet WDToolButton *tileButton;
@property (weak, nonatomic) IBOutlet WDToolButton *waterFeatureButton;
@property (weak, nonatomic) IBOutlet WDToolButton *gazeboButton;
@property (weak, nonatomic) IBOutlet WDToolButton *shedButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *cloneButton;
@property (weak, nonatomic) IBOutlet UIButton *redoButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;


- (IBAction)toolsTabChanged:(id)sender;


- (IBAction)gridTapped:(id)sender;

- (IBAction)changePlan:(id)sender;
- (IBAction)colorPickerTapped:(id)sender;
- (IBAction)sizeButtonTapped:(id)sender;

- (IBAction)deleteTapped:(id)sender;
- (IBAction)cloneTapped:(id)sender;
- (IBAction)redoTapped:(id)sender;
- (IBAction)undoTapped:(id)sender;


@end
