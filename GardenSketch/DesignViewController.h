//
//  DesignViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-18.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "SidebarContentViewController.h"

@interface DesignViewController : SidebarContentViewController

@property (weak, nonatomic) IBOutlet UILabel *planNameLabel;

- (IBAction)changePlan:(id)sender;

@end
