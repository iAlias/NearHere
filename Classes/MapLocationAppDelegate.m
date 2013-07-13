//
//  MapLocationAppDelegate.m
//  Progetto LAP1
//
//  Created by Di Stefano Antonino - Gugliotta Alberto 02/02/2011.
//  Copyright 2010. All rights reserved.
//

#import "MapLocationAppDelegate.h"
#import "MapLocationViewController.h"
#import "SettingViewController.h"

@implementation MapLocationAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setBackgroundColor:[UIColor blackColor]];
	mapView = [[MapLocationViewController alloc] init];
	setView = [[SettingViewController alloc] init];
	application.idleTimerDisabled = YES;
	[mapView.view addSubview:setView.view];
	[window addSubview:mapView.view];
    [window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {

	/*
	NSMutableArray *arraySalvataggio=[NSArray arrayWithObjects:MapLocationViewController.slider,MapLocationViewController.segControl, MapLocationViewController.destChiamate, MapLocationViewController.destSms, MapLocationViewController.destMail, MapLocationViewController.oggettoMail, MapLocationViewController.testoMail.text, MapLocationViewController.testoSms.text, MapLocationViewController.onSms.on, MapLocationViewController.onMail.on, MapLocationViewController.onChiamate.on, MapLocationViewController.dest.coordinate.latitude, MapLocationViewController.dest.coordinate.longitude, nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:arraySalvataggio forKey:@""];
	[defaults synchronize];
	 */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
	[navController release];
	[mapView release];
	[setView release];
    [window release];
    [super dealloc];
}

@end
