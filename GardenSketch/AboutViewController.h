//
//  AboutViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-08-14.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSButton.h"
#import "GSLabel.h"

@interface AboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *inkpadButton;
@property (weak, nonatomic) IBOutlet UIButton *githubButton;
@property (weak, nonatomic) IBOutlet GSButton *doneButton;
@property (weak, nonatomic) IBOutlet GSLabel *versionLabel;

- (IBAction)inkpadTapped:(id)sender;
- (IBAction)githubTapped:(id)sender;
- (IBAction)doneTapped:(id)sender;

@end
