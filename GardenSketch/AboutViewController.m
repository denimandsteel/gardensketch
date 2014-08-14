//
//  AboutViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-08-14.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "AboutViewController.h"
#import "Constants.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.doneButton setTitleColor:GS_COLOR_ACCENT_BLUE forState:UIControlStateNormal];
	[self.inkpadButton setTitleColor:GS_COLOR_ACCENT_BLUE forState:UIControlStateNormal];
	[self.githubButton setTitleColor:GS_COLOR_ACCENT_BLUE forState:UIControlStateNormal];
	
	[self.doneButton.titleLabel setFont:GS_FONT_AVENIR_ACTION];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)inkpadTapped:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/sprang/Inkpad"]];
}

- (IBAction)githubTapped:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/denimandsteel/gardensketch"]];
}

- (IBAction)doneTapped:(id)sender {
	[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
