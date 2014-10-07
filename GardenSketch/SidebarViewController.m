//
//  SidebarViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-12.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "SidebarViewController.h"
#import "NorthViewController.h"
#import "Constants.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController

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
	
	UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
	swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	swipeLeft.delegate = self;
	[self.view addGestureRecognizer:swipeLeft];
	
	UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
	swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
	swipeRight.delegate = self;
	[self.view addGestureRecognizer:swipeRight];
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver:self
						   selector:@selector(applicationDidEnterBackground:)
							   name:UIApplicationDidEnterBackgroundNotification
							 object:nil];
	[notificationCenter addObserver:self
						   selector:@selector(applicationWillEnterForeground:)
							   name:UIApplicationWillEnterForegroundNotification
							 object:nil];
	[notificationCenter addObserver:self
						   selector:@selector(applicationWillEnterForeground:)
							   name:UIApplicationDidBecomeActiveNotification
							 object:nil];
}

- (void)applicationDidEnterBackground:(NSNotificationCenter *)notification
{
	[[NSUserDefaults standardUserDefaults] setInteger:self.selectedIndex forKey:GS_LAST_ACTIVE_TAB_INDEX];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(NSNotificationCenter *)notification
{
	NSInteger tabIndex = 0;
	if ([[NSUserDefaults standardUserDefaults] integerForKey:GS_LAST_ACTIVE_TAB_INDEX]) {
		tabIndex = [[NSUserDefaults standardUserDefaults] integerForKey:GS_LAST_ACTIVE_TAB_INDEX];
		if (tabIndex != self.selectedIndex) {
			if (tabIndex == 4 || tabIndex == 5) {
				tabIndex = 3;
			}
			[self setSelectedIndex:tabIndex];
		}
	}
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint touchPoint = [touch locationInView:self.view];
	if ([self.selectedViewController isKindOfClass:[NorthViewController class]]) {
		return NO;
	}
	return !CGRectContainsPoint(self.infiniteTabBar.frame, touchPoint);
}

- (void)swipedLeft:(UISwipeGestureRecognizer*)gestureRecognizer
{
	[UIView animateWithDuration:.3 animations:^{
		CGRect frame = self.view.frame;
		frame.origin.x = -(GS_SIDEBAR_WIDTH - 20); // leave 20px visible.
		[self.view setFrame:frame];
	}];
}

- (void)swipedRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
	[UIView animateWithDuration:.3 animations:^{
		CGRect frame = self.view.frame;
		frame.origin.x = 0;
		[self.view setFrame:frame];
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
