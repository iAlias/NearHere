//
//  MapLocationAppDelegate.h
//  Progetto LAP1
//
//  Created by Di Stefano Antonino - Gugliotta Alberto 02/02/2011.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapLocationViewController, SettingViewController;

@interface MapLocationAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navController;
	MapLocationViewController *mapView;
	SettingViewController *setView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@end

