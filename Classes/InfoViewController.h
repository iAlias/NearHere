//
//  InfoViewController.h
//  Progetto LAP1
//
//  Created by Di Stefano Antonino - Gugliotta Alberto 02/02/2011.
//  Copyright 2010. All rights reserved.
//
#import "MapViewAnnotation.h"

@interface InfoViewController : UIViewController <MKReverseGeocoderDelegate> {
	CLLocationDistance distance;
	MKReverseGeocoder *reverseGeocoder;
	IBOutlet UILabel *dist;
	IBOutlet UILabel *gecoder;
}

- (id) init;
- (void)setting:(CLLocation *)userLocation annotation:(MapViewAnnotation *)annotation;
- (CLLocationDistance)getDistance;

@end
