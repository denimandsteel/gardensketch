//
//  StructureViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-16.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidebarContentViewController.h"
#import "WDToolButton.h"
#import "GSButton.h"

@interface HouseViewController : SidebarContentViewController

@property (weak, nonatomic) IBOutlet WDToolButton *houseButton;
@property (weak, nonatomic) IBOutlet WDToolButton *houseRectHorButton;
@property (weak, nonatomic) IBOutlet WDToolButton *houseRectVerButton;
@property (weak, nonatomic) IBOutlet WDToolButton *houseL1Button;
@property (weak, nonatomic) IBOutlet WDToolButton *houseL2Button;
@property (weak, nonatomic) IBOutlet WDToolButton *houseL3Button;
@property (weak, nonatomic) IBOutlet WDToolButton *houseL4Button;


@property (weak, nonatomic) IBOutlet WDToolButton *scaleButton;
@property (weak, nonatomic) IBOutlet WDToolButton *selectButton;

@property (weak, nonatomic) IBOutlet GSButton *deleteButton;

- (IBAction)deleteTapped:(id)sender;

@end
