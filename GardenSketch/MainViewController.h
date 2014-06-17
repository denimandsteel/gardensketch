//
//  ViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-12.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13InfiniteTabBarController.h"
#import "SidebarViewController.h"

@interface MainViewController : UIViewController <M13InfiniteTabBarControllerDelegate>

@property (nonatomic, weak) SidebarViewController *sidebar;

@end
