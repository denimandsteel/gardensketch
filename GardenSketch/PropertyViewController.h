//
//  PropertyViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-13.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidebarContentViewController.h"

@interface PropertyViewController : SidebarContentViewController

@property (weak, nonatomic) IBOutlet UIView *shapesView;
@property (weak, nonatomic) IBOutlet UIView *sizeView;


- (IBAction)shapeSelected:(id)sender;
- (IBAction)changeShapeTapped:(id)sender;


@end
