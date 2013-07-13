//
//  MapViewAnnotation.m
//  Progetto LAP1
//
//  Created by Di Stefano Antonino - Gugliotta Alberto 02/02/2011.
//  Copyright 2010. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize coordinate, annotationTitle, annotationSubTitle;

- (id)initWithCoordinate:(CLLocationDegrees)longitude latitude:(CLLocationDegrees)latitude {
	coordinate.longitude = longitude;
	coordinate.latitude = latitude;
    return [super init];
}
		 
- (NSString *)title {
	 return annotationTitle;
 }
 
- (NSString *)subtitle {
	 return annotationSubTitle;
 }

- (void)dealloc {
	[super dealloc];
}

@end
