//
//  AppDelegate.m
//  BulletPoint
//
//  Created by Chris Stott on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "TutorialViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
//@synthesize database = _database;
@synthesize model = _model;

AppDelegate* _instance = 0

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	_instance = self;

	self.model = [[Model alloc] init];
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	bool tutorialViewed = [defaults boolForKey:@"tutorial_viewed"];

	if (tutorialViewed) {
		self.window.rootViewController = [self setupMainViews];
	}
	else {
		self.window.rootViewController = [self setupTutorialView];
	}

    [self.window makeKeyAndVisible];	
	
    return YES;
}

- (void)leaveTutorial {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:YES forKey:@"tutorial_viewed"];
	[defaults synchronize];

	UIViewController* newController = [self setupMainViews];

	UIView* view1 = self.window.rootViewController.view;
	UIView* view2 = newController.view;


	[UIView transitionFromView:view1 toView:view2 duration:1.0 options:UIViewAnimationOptionTransitionCurlUp completion:^(BOOL finished) {
		self.window.rootViewController = newController;
	}];
}

- (UIViewController*)setupTutorialView {
	TutorialViewController* tutorialViewController = [[TutorialViewController alloc] init];
	return tutorialViewController;
}

- (UIViewController*)setupMainViews {
	MainViewController* mainViewController = [[MainViewController alloc] initWithNibName:nil bundle:nil];	
	UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:mainViewController];	
	[nc.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
	NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
											   [UIColor colorWithWhite:1.0f alpha:1.000],UITextAttributeTextColor, 
											   [UIColor clearColor], UITextAttributeTextShadowColor, 
											   [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, 
											   [UIFont fontWithName:@"Gill Sans" size:20.0], UITextAttributeFont,
											   nil];
	
	nc.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
	nc.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.333 blue:0.000 alpha:1.000];
	[nc.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
	
	self.navigationController = nc;
	return nc;
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

+ (AppDelegate*)instance {
	return _instance;
}

@end
