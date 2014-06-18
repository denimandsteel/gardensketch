//
//  SidebarViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-12.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "SidebarViewController.h"

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
	[self.view addGestureRecognizer:swipeLeft];
	
	UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
	swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:swipeRight];
}

- (void)swipedLeft:(UISwipeGestureRecognizer*)gestureRecognizer
{
	NSLog(@"swiped left!");
	[UIView animateWithDuration:.3 animations:^{
		CGRect frame = self.view.frame;
		frame.origin.x = -300;
		[self.view setFrame:frame];
	}];
}

- (void)swipedRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
	NSLog(@"swiped right!");
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
