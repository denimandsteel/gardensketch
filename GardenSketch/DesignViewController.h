//
//  DesignViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-18.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "SidebarContentViewController.h"
#import "WDToolButton.h"

@interface DesignViewController : SidebarContentViewController

@property (weak, nonatomic) IBOutlet UILabel *planNameLabel;
@property (weak, nonatomic) IBOutlet WDToolButton *freehandButton;
@property (weak, nonatomic) IBOutlet WDToolButton *enclosedButton;


- (IBAction)changePlan:(id)sender;

@end
