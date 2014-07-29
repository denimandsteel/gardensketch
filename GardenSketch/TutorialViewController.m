//
//  TutorialViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-28.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController {
	NSInteger currentIndex;
}

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
	
	currentIndex = 0;
	
	[self showPageAtIndex:currentIndex];
}

- (void)showPageAtIndex:(NSInteger)index
{
	UIView *view = [[[NSBundle mainBundle] loadNibNamed:[self.xibsToShow objectAtIndex:index] owner:self options:nil] lastObject];
	
	for (UIView *subview in self.containerView.subviews) {
		[subview removeFromSuperview];
	}
	
	[self.containerView addSubview:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueTapped:(id)sender {
	currentIndex++;
	
	if (currentIndex < self.xibsToShow.count) {
		[self showPageAtIndex:currentIndex];
	} else {
		[self.delegate letMeGo];
	}
}

@end
