//
//  MapViewAnnotation.h
//  Progetto LAP1
//
//  Created by Di Stefano Antonino - Gugliotta Alberto 02/02/2011.
//  Copyright 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MapViewAnnotation : NSObject <MKAnnotation>  {
	CLLocationCoordinate2D coordinate;
	NSString *annotationTitle;
	NSString *annotationSubTitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *annotationTitle;
@property (nonatomic, retain) NSString *annotationSubTitle;

- (id)initWithCoordinate:(CLLocationDegrees)longitude latitude:(CLLocationDegrees)latitude;

@end
