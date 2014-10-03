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
	[super viewWillAppear:animated];
	
	[self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.inkpadButton setTitleColor:GS_COLOR_ACCENT_BLUE forState:UIControlStateNormal];
	[self.githubButton setTitleColor:GS_COLOR_ACCENT_BLUE forState:UIControlStateNormal];
	
	[self.doneButton.titleLabel setFont:GS_FONT_AVENIR_ACTION];
	
	[self updateVersionLabel];
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

- (void)updateVersionLabel
{
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
	NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
	NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
	NSString *label = [NSString stringWithFormat:@"%@ v%@ (build %@)",
					   name,version,build];
	
	[self.versionLabel setText:label];
}

@end
