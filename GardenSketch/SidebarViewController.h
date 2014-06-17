//
//  SidebarViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-12.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13InfiniteTabBarController.h"
#import "WDCanvasController.h"

@interface SidebarViewController : M13InfiniteTabBarController

@property (nonatomic, weak) WDCanvasController *canvasController;

@end
