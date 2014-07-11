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

@interface StructureViewController : SidebarContentViewController

@property (weak, nonatomic) IBOutlet WDToolButton *houseButton;
@property (weak, nonatomic) IBOutlet WDToolButton *scaleButton;
@property (weak, nonatomic) IBOutlet WDToolButton *selectButton;

@property (weak, nonatomic) IBOutlet GSButton *deleteButton;

- (IBAction)deleteTapped:(id)sender;

@end
