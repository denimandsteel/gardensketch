//
//  MoreViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-15.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "SidebarContentViewController.h"
#import "GSLabel.h"
#import <MessageUI/MessageUI.h>

@interface MoreViewController : SidebarContentViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet GSLabel *versionLabel;

- (IBAction)feedbackTapped:(id)sender;
- (IBAction)aboutTapped:(id)sender;
- (IBAction)blogTapped:(id)sender;
- (IBAction)shareTapped:(id)sender;

@end
