//
//  AppDelegate.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-12.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "AppDelegate.h"
#import "WDFontManager.h"
#import "WDInspectableProperties.h"
#import "WDColor.h"
#import "WDGradient.h"
#import "StencilManager.h"
#import "WDDrawingManager.h"
#import "Mixpanel.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	// Load the fonts at startup. Dispatch this call at the end of the main queue;
	// It will then dispatch the real work on another queue after the app launches.
	// Also load the svg shapes upfront
	dispatch_async(dispatch_get_main_queue(), ^{
		[WDFontManager sharedInstance];
		[StencilManager sharedInstance];
	});
	
	[self clearTempDirectory];
	
	[self setupDefaults];
	
	[WDDrawingManager sharedInstance];

	[ABNotifier startNotifierWithAPIKey:@"5ed97c39a5243755d2e6ea78dbcfe662"
						environmentName:ABNotifierAutomaticEnvironment
								 useSSL:YES // only if your account supports it
							   delegate:self];
	
	NSString *mixpanelToken = @"e7f32564b28cc136583e7f27d5d6fba6";
	[Mixpanel sharedInstanceWithToken:mixpanelToken];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self applicationDidFinishLaunching:application];
	
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// Inkpad setup:

- (void) clearTempDirectory
{
    NSFileManager   *fm = [NSFileManager defaultManager];
    NSURL           *tmpURL = [NSURL fileURLWithPath:NSTemporaryDirectory()];
    NSArray         *files = [fm contentsOfDirectoryAtURL:tmpURL includingPropertiesForKeys:[NSArray array] options:0 error:NULL];
    
    for (NSURL *url in files) {
        [fm removeItemAtURL:url error:nil];
    }
}

- (void) setupDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Defaults.plist"];
    [defaults registerDefaults:[NSDictionary dictionaryWithContentsOfFile:defaultPath]];
    
    // Install valid defaults for various colors/gradients if necessary. These can't be encoded in the Defaults.plist.
    if (![defaults objectForKey:WDStrokeColorProperty]) {
        NSData *value = [NSKeyedArchiver archivedDataWithRootObject:[WDColor blackColor]];
        [defaults setObject:value forKey:WDStrokeColorProperty];
    }
    
    if (![defaults objectForKey:WDFillProperty]) {
        NSData *value = [NSKeyedArchiver archivedDataWithRootObject:[WDColor whiteColor]];
        [defaults setObject:value forKey:WDFillProperty];
    }
    
    if (![defaults objectForKey:WDFillColorProperty]) {
        NSData *value = [NSKeyedArchiver archivedDataWithRootObject:[WDColor whiteColor]];
        [defaults setObject:value forKey:WDFillColorProperty];
    }
    
    if (![defaults objectForKey:WDFillGradientProperty]) {
        NSData *value = [NSKeyedArchiver archivedDataWithRootObject:[WDGradient defaultGradient]];
        [defaults setObject:value forKey:WDFillGradientProperty];
    }
    
    if (![defaults objectForKey:WDStrokeDashPatternProperty]) {
        NSArray *dashes = @[];
        [defaults setObject:dashes forKey:WDStrokeDashPatternProperty];
    }
    
    if (![defaults objectForKey:WDShadowColorProperty]) {
        NSData *value = [NSKeyedArchiver archivedDataWithRootObject:[WDColor colorWithRed:0 green:0 blue:0 alpha:0.333f]];
        [defaults setObject:value forKey:WDShadowColorProperty];
    }
}


@end
