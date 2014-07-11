//
//  SidebarContentViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-13.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidebarViewController.h"

@interface SidebarContentViewController : UIViewController

// TODO: see if all use cases of sidebar is to get the canvas controller. if yes, replace it
@property (nonatomic, weak) SidebarViewController *sidebar;

@end
