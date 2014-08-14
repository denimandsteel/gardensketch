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
#import "HouseViewController.h"
#import "NorthViewController.h"
#import "PlansViewController.h"
#import "WDCanvasController.h"
#import "DesignViewController.h"
#import "StencilManager.h"
#import "MoreViewController.h"
#import "NotesViewController.h"
#import "Constants.h"
#import "WDDocument.h"

extern NSString* GSNotificationCanvasActivityStarted;
extern NSString* GSNotificationCanvasActivityStopped;

@interface MainViewController ()
	@property (strong, nonatomic) TutorialViewController *tutorial;
@end

@implementation MainViewController
{
	NSArray *tabKey;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	tabKey = @[GS_VISITED_PROPERTY_TAB, GS_VISITED_HOUSE_TAB, GS_VISITED_NORTH_TAB, GS_VISITED_PLANS_TAB, GS_VISITED_DESIGN_TAB, GS_VISITED_NOTES_TAB, GS_VISITED_MORE_TAB];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES
											withAnimation:UIStatusBarAnimationFade];
	
	[self addChildViewControllers];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:GS_HAS_LAUNCHED_ONCE])
    {
        // app already launched
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GS_HAS_LAUNCHED_ONCE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
		
		// -1 is the first app launch tutorial pages!
		[self showTutorialForTab:-1];
    }
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canvasActivityStarted:) name:GSNotificationCanvasActivityStarted object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canvasActivityStopped:) name:GSNotificationCanvasActivityStopped object:nil];
}

- (void)canvasActivityStarted:(NSNotification *)notification
{
	NSLog(@"disable all interactions!");
	[self.sidebar.view setUserInteractionEnabled:NO];
}

- (void)canvasActivityStopped:(NSNotification *)notification
{
	NSLog(@"enable all interactions!");
	[self.sidebar.view setUserInteractionEnabled:YES];
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
	return CGRectMake(0, 0, GS_SIDEBAR_WIDTH, 768);
}

#pragma mark - M13InfiniteTabBarControllerDelegate

- (NSArray *)infiniteTabBarControllerRequestingViewControllersToDisplay:(M13InfiniteTabBarController *)tabBarController
{
    //Load the view controllers from the storyboard and add them to the array.
    
    PropertyViewController *vc1 = [[PropertyViewController alloc] initWithNibName:@"PropertyViewController" bundle:nil];
	HouseViewController *vc2 = [[HouseViewController alloc] initWithNibName:@"HouseViewController" bundle:nil];
	NorthViewController *vc3 = [[NorthViewController alloc] initWithNibName:@"NorthViewController" bundle:nil];
	PlansViewController *vc4 = [[PlansViewController alloc] initWithNibName:@"PlansViewController" bundle:nil];
	DesignViewController *vc5 = [[DesignViewController alloc] initWithNibName:@"DesignViewController" bundle:nil];
	NotesViewController *vc6 = [[NotesViewController alloc] initWithNibName:@"NotesViewController" bundle:nil];
	MoreViewController *vc7 = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
	
	for (SidebarContentViewController *contentView in @[vc1, vc2, vc3, vc4, vc5, vc6, vc7]) {
		contentView.sidebar = self.sidebar;
	}
    
    //------- end test ----------------------
    
    //You probably want to set this on the UIViewController initalization, from within the UIViewController subclass. I'm just doing it here since each tab inherits from the same subclass.
    [vc1 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Property"
														   selectedIconMask:[UIImage imageNamed:@"property"]
														 unselectedIconMask:[UIImage imageNamed:@"property"]]];
    [vc2 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"House"
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
														   selectedIconMask:[UIImage imageNamed:@"notes"]
														 unselectedIconMask:[UIImage imageNamed:@"notes"]]];
    [vc7 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"More"
														   selectedIconMask:[UIImage imageNamed:@"more"]
														 unselectedIconMask:[UIImage imageNamed:@"more"]]];
    
    return @[vc1, vc2, vc3, vc4, vc5, vc6, vc7];
}

//Delegate Protocol
- (BOOL)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController shouldSelectViewContoller:(UIViewController *)viewController
{
	NSInteger tabIndex = [self.sidebar.viewControllers indexOfObject:viewController];
	
	// Do not allow jumping to design or notes tabs if no plan, or the base plan is loaded.
	if (tabIndex == 4 || tabIndex == 5) {
		if (!self.sidebar.canvasController.document ||
			[self.sidebar.canvasController.document.filename isEqualToString:GS_BASE_PLAN_FILE_NAME]) {
			return NO;
		}
	}
	// TODO: limit access to tabs based on the progress:
	//			e.g. notes and design tabs are not allowed unless at least one plan exists and is selected.
    if ([viewController.title isEqualToString:@"Search"]) { //Prevent selection of first view controller
        return NO;
    } else {
        return YES;
    }
}

- (void)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	// TODO: if first visit show tutorial for this section
	NSInteger tabIndex = [self.sidebar selectedIndex];
	
	if (![self hasVisitedTab:tabIndex]) {
		[self showTutorialForTab:tabIndex];
	}
	
	[self setVisited:YES forTab:tabIndex];
}

- (BOOL)hasVisitedTab:(NSInteger)tabIndex
{
	BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:tabKey[tabIndex]];
	return result;
}

- (void)setVisited:(BOOL)visited forTab:(NSInteger)tabIndex
{
	[[NSUserDefaults standardUserDefaults] setBool:visited forKey:tabKey[tabIndex]];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)showTutorialForTab:(NSInteger)tabIndex {
    if (self.tutorial == nil) {
        NSMutableArray *pages = [self tutorialPageNamesForTab:tabIndex];
		if (!pages || pages.count == 0) {
			return;
		}
		self.tutorial = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
		[self.tutorial setDelegate:self];
		[self.tutorial setPagesToShow:pages];
        [self addChildViewController:self.tutorial];
        [self.view addSubview:self.tutorial.view];
		// center horizontally and move up to hide.
		CGRect frame = self.tutorial.view.frame;
		frame.origin.x = (1024 - self.tutorial.view.frame.size.width) / 2;
		frame.origin.y = -frame.size.height;
		[self.tutorial.view setFrame:frame];
        [UIView animateWithDuration:.5 animations:^{
            CGRect frame = self.tutorial.view.frame;
			frame.origin.y = 0;
			[self.tutorial.view setFrame:frame];
        } completion:^(BOOL finished) {
            [self.tutorial didMoveToParentViewController:self];
        }];
    } else {
		[self.tutorial.pagesToShow addObjectsFromArray:[self tutorialPageNamesForTab:tabIndex]];
	}
}

- (NSMutableArray *)tutorialPageNamesForTab:(NSInteger)tabIndex
{
	switch (tabIndex) {
		case -1:
			return [NSMutableArray arrayWithArray:@[@"AppStart1"]];
			break;
		case 0:
			return nil;
			break;
		case 1:
			return [NSMutableArray arrayWithArray:@[@"House1", @"House2", @"House3"]];
			break;
		case 2:
			return nil;
			break;
		case 3:
			return [NSMutableArray arrayWithArray:@[@"Plans1"]];
			break;
		case 4:
			return [NSMutableArray arrayWithArray:@[@"Design1", @"Design2", @"Design3", @"Design4"]];
			break;
		case 6:
			return [NSMutableArray arrayWithArray:@[@"More1"]];
			break;
		default:
			return [NSMutableArray array];
			break;
	}
}

- (void)hideTutorial
{
	[UIView animateWithDuration:.5 animations:^{
		CGRect frame = self.tutorial.view.frame;
		frame.origin.y = -frame.size.height;
		[self.tutorial.view setFrame:frame];
	} completion:^(BOOL finished) {
		[self.tutorial.view removeFromSuperview];
		[self.tutorial removeFromParentViewController];
		self.tutorial = nil;
	}];
}

- (void)letMeGo
{
	[self hideTutorial];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
