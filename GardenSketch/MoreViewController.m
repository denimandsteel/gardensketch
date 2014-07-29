//
//  MoreViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-15.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "MoreViewController.h"
#import "Constants.h"

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
	
	[self updateVersionLabel];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetTutorialTapped:(id)sender {
	NSArray *tabKeys = @[GS_VISITED_PROPERTY_TAB, GS_VISITED_HOUSE_TAB, GS_VISITED_NORTH_TAB, GS_VISITED_PLANS_TAB, GS_VISITED_DESIGN_TAB, GS_VISITED_NOTES_TAB, GS_VISITED_MORE_TAB];
	for (NSString *tabKey in tabKeys) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:tabKey];
    }
	[[NSUserDefaults standardUserDefaults] synchronize];
}
@end
