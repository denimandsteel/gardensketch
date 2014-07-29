//
//  MoreViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-15.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "SidebarContentViewController.h"
#import "GSLabel.h"

@interface MoreViewController : SidebarContentViewController

@property (weak, nonatomic) IBOutlet GSLabel *versionLabel;

- (IBAction)resetTutorialTapped:(id)sender;

@end
