//
//  MoreViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-15.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "MoreViewController.h"
#import "Constants.h"
#import "AboutViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

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
	[self.feedbackButton.titleLabel setFont:GS_FONT_AVENIR_ACTION];
	[self.aboutButton.titleLabel setFont:GS_FONT_AVENIR_ACTION];
	[self.blogButton.titleLabel setFont:GS_FONT_AVENIR_ACTION];
	[self.shareButton.titleLabel setFont:GS_FONT_AVENIR_ACTION];
	[self.resetButton.titleLabel setFont:GS_FONT_AVENIR_ACTION];
	
	[self.feedbackButton setBackgroundImage:[UIImage imageNamed:@"select_background_colour"] forState:UIControlStateHighlighted];
	[self.aboutButton setBackgroundImage:[UIImage imageNamed:@"select_background_colour"] forState:UIControlStateHighlighted];
	[self.blogButton setBackgroundImage:[UIImage imageNamed:@"select_background_colour"] forState:UIControlStateHighlighted];
	[self.shareButton setBackgroundImage:[UIImage imageNamed:@"select_background_colour"] forState:UIControlStateHighlighted];
	[self.resetButton setBackgroundImage:[UIImage imageNamed:@"select_background_colour"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetTutorialTapped:(id)sender {
	NSArray *defaultKeys = @[GS_VISITED_PROPERTY_TAB, GS_VISITED_HOUSE_TAB, GS_VISITED_NORTH_TAB, GS_VISITED_PLANS_TAB, GS_VISITED_DESIGN_TAB, GS_VISITED_NOTES_TAB, GS_VISITED_MORE_TAB, GS_HAS_LAUNCHED_ONCE];
	for (NSString *tabKey in defaultKeys) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:tabKey];
    }
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)feedbackTapped:(id)sender {
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:@[@"support@gardensketchapp.com"]];
	
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
	NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    [controller setSubject:[NSString stringWithFormat:@"Feedback for Garden Sketch v%@ (build %@)", version, build]];
    [controller setMessageBody:[NSString stringWithFormat:@""] isHTML:YES];
    if([MFMailComposeViewController canSendMail]){
		[self presentViewController:controller animated:YES completion:nil];
	}
}

- (IBAction)aboutTapped:(id)sender {
	AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
	[self presentViewController:aboutViewController animated:YES completion:^{
		
	}];
}

- (IBAction)blogTapped:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://gardensketchapp.com/"]];
}

- (IBAction)shareTapped:(id)sender {
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:@[]];
    [controller setSubject:@"Garden Sketch"];
    [controller setMessageBody:@"Map your garden with Garden Sketch: http://gardensketchapp.com/app" isHTML:NO];
    if([MFMailComposeViewController canSendMail]){
		[self presentViewController:controller animated:YES completion:nil];
	}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[controller dismissViewControllerAnimated:YES completion:^{
		
	}];
}

@end
