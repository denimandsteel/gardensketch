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

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self addChildViewControllers];
}

- (void)addChildViewControllers
{
	SidebarViewController *sidebar = [[SidebarViewController alloc] initWithNibName:@"SidebarViewController" bundle:nil];
	
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
	SidebarContentViewController *vc2 = [[SidebarContentViewController alloc] initWithNibName:@"SidebarContentViewController" bundle:nil];
	SidebarContentViewController *vc3 = [[SidebarContentViewController alloc] initWithNibName:@"SidebarContentViewController" bundle:nil];
	SidebarContentViewController *vc4 = [[SidebarContentViewController alloc] initWithNibName:@"SidebarContentViewController" bundle:nil];
	SidebarContentViewController *vc5 = [[SidebarContentViewController alloc] initWithNibName:@"SidebarContentViewController" bundle:nil];
	SidebarContentViewController *vc6 = [[SidebarContentViewController alloc] initWithNibName:@"SidebarContentViewController" bundle:nil];
	SidebarContentViewController *vc7 = [[SidebarContentViewController alloc] initWithNibName:@"SidebarContentViewController" bundle:nil];
    
    
    //------- end test ----------------------
    
    //You probably want to set this on the UIViewController initalization, from within the UIViewController subclass. I'm just doing it here since each tab inherits from the same subclass.
    [vc1 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Property"
														   selectedIconMask:[UIImage imageNamed:@"tab1Solid.png"]
														 unselectedIconMask:[UIImage imageNamed:@"tab1Line.png"]]];
    [vc2 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Structures"
														   selectedIconMask:[UIImage imageNamed:@"tab2Solid.png"]
														 unselectedIconMask:[UIImage imageNamed:@"tab2Line.png"]]];
    [vc3 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"North"
														   selectedIconMask:[UIImage imageNamed:@"tab3Solid.png"]
														 unselectedIconMask:[UIImage imageNamed:@"tab3Line.png"]]];
    [vc4 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Plans"
														   selectedIconMask:[UIImage imageNamed:@"tab4Solid.png"]
														 unselectedIconMask:[UIImage imageNamed:@"tab4Line.png"]]];
    [vc5 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Design"
														   selectedIconMask:[UIImage imageNamed:@"tab5Solid.png"]
														 unselectedIconMask:[UIImage imageNamed:@"tab5Line.png"]]];
    [vc6 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Notes"
														   selectedIconMask:[UIImage imageNamed:@"tab6Solid.png"]
														 unselectedIconMask:[UIImage imageNamed:@"tab6Line.png"]]];
    [vc7 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"More"
														   selectedIconMask:[UIImage imageNamed:@"tab7Solid.png"]
														 unselectedIconMask:[UIImage imageNamed:@"tab7Line.png"]]];
    
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
