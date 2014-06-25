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

@interface DesignViewController : SidebarContentViewController

@property (weak, nonatomic) IBOutlet UILabel *planNameLabel;
@property (weak, nonatomic) IBOutlet WDToolButton *selectButton;
@property (weak, nonatomic) IBOutlet WDToolButton *freehandButton;
@property (weak, nonatomic) IBOutlet WDToolButton *enclosedButton;

@property (weak, nonatomic) IBOutlet WDToolButton *bigPlantButton;
@property (weak, nonatomic) IBOutlet WDToolButton *smallPlantButton;

@property (weak, nonatomic) IBOutlet WDToolButton *tileButton;
@property (weak, nonatomic) IBOutlet WDToolButton *gazeboButton;
@property (weak, nonatomic) IBOutlet WDToolButton *shedButton;

@property (weak, nonatomic) IBOutlet ColorPickerButton *outlineColorPicker;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *cloneButton;
@property (weak, nonatomic) IBOutlet UIButton *redoButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;


- (IBAction)changePlan:(id)sender;
- (IBAction)colorPickerTapped:(id)sender;

- (IBAction)deleteTapped:(id)sender;
- (IBAction)cloneTapped:(id)sender;
- (IBAction)redoTapped:(id)sender;
- (IBAction)undoTapped:(id)sender;


@end
