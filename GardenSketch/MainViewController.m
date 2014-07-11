//
//  ViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-12.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "MainViewController.h"
#import "SidebarViewController.h"
#import "SidebarContentViewController.h"
#import "PropertyViewController.h"
#import "StructureViewController.h"
#import "NorthViewController.h"
#import "PlansViewController.h"
#import "WDCanvasController.h"
#import "DesignViewController.h"
#import "StencilManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES
											withAnimation:UIStatusBarAnimationFade];
	
	[self addChildViewControllers];
	
	BOOL firstLaunch = YES;
	
	if (!firstLaunch) {
		[self.sidebar setSelectedIndex:3];
	}
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

- (void)addChildViewControllers
{
	// Canvas
	WDCanvasController *canvas = [[WDCanvasController alloc] init];
	
	[self addChildViewController:canvas];
	[self.view addSubview:canvas.view];
	[canvas didMoveToParentViewController:self];
	
	// Sidebar
	SidebarViewController *sidebar = [[SidebarViewController alloc] initWithNibName:@"SidebarViewController" bundle:nil];
	
	self.sidebar = sidebar;
	
	sidebar.canvasController = canvas;
	
	sidebar.delegate = self;
	sidebar.enableInfiniteScrolling = NO;
	
	[self addChildViewController:sidebar];
	sidebar.view.frame = [self frameForSidebar];
	[self.view addSubview:sidebar.view];
	[sidebar didMoveToParentViewController:self];
}

- (CGRect)frameForSidebar
{
	return CGRectMake(0, 0, 320, 768);
}

#pragma mark - M13InfiniteTabBarControllerDelegate

- (NSArray *)infiniteTabBarControllerRequestingViewControllersToDisplay:(M13InfiniteTabBarController *)tabBarController
{
    //Load the view controllers from the storyboard and add them to the array.
    
    PropertyViewController *vc1 = [[PropertyViewController alloc] initWithNibName:@"PropertyViewController" bundle:nil];
	StructureViewController *vc2 = [[StructureViewController alloc] initWithNibName:@"StructureViewController" bundle:nil];
	NorthViewController *vc3 = [[NorthViewController alloc] initWithNibName:@"NorthViewController" bundle:nil];
	PlansViewController *vc4 = [[PlansViewController alloc] initWithNibName:@"PlansViewController" bundle:nil];
	DesignViewController *vc5 = [[DesignViewController alloc] initWithNibName:@"DesignViewController" bundle:nil];
	SidebarContentViewController *vc6 = [[SidebarContentViewController alloc] initWithNibName:@"SidebarContentViewController" bundle:nil];
	SidebarContentViewController *vc7 = [[SidebarContentViewController alloc] initWithNibName:@"SidebarContentViewController" bundle:nil];
	
	for (SidebarContentViewController *contentView in @[vc1, vc2, vc3, vc4, vc5, vc6, vc7]) {
		contentView.sidebar = self.sidebar;
	}
    
    //------- end test ----------------------
    
    //You probably want to set this on the UIViewController initalization, from within the UIViewController subclass. I'm just doing it here since each tab inherits from the same subclass.
    [vc1 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Property"
														   selectedIconMask:[UIImage imageNamed:@"property"]
														 unselectedIconMask:[UIImage imageNamed:@"property"]]];
    [vc2 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Structures"
														   selectedIconMask:[UIImage imageNamed:@"structure"]
														 unselectedIconMask:[UIImage imageNamed:@"structure"]]];
    [vc3 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"North"
														   selectedIconMask:[UIImage imageNamed:@"north"]
														 unselectedIconMask:[UIImage imageNamed:@"north"]]];
    [vc4 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Plans"
														   selectedIconMask:[UIImage imageNamed:@"plans"]
														 unselectedIconMask:[UIImage imageNamed:@"plans"]]];
    [vc5 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Design"
														   selectedIconMask:[UIImage imageNamed:@"design"]
														 unselectedIconMask:[UIImage imageNamed:@"design"]]];
    [vc6 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Notes"
														   selectedIconMask:[UIImage imageNamed:@"notes.png"]
														 unselectedIconMask:[UIImage imageNamed:@"notes.png"]]];
    [vc7 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"More"
														   selectedIconMask:[UIImage imageNamed:@"more.png"]
														 unselectedIconMask:[UIImage imageNamed:@"more.png"]]];
    
    return @[vc1, vc2, vc3, vc4, vc5, vc6, vc7];
}

//Delegate Protocol
- (BOOL)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController shouldSelectViewContoller:(UIViewController *)viewController
{
    if ([viewController.title isEqualToString:@"Search"]) { //Prevent selection of first view controller
        return NO;
    } else {
        return YES;
    }
}

- (void)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //Do nothing
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
