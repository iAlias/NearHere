//
//  InfoViewController.m
//  Progetto LAP1
//
//  Created by Di Stefano Antonino - Gugliotta Alberto 02/02/2011.
//  Copyright 2010. All rights reserved.
//

#import "InfoViewController.h"

@implementation InfoViewController

#pragma mark -
#pragma mark Initialization

-(CLLocationDistance)getDistance{
	return distance;
}

-(id) init{
	return self;
}

- (void)setting:(CLLocation *)userLocation annotation:(MapViewAnnotation *)annotation {
	CLLocation *location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
	distance = [userLocation distanceFromLocation:location];
	reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:annotation.coordinate];
	reverseGeocoder.delegate = self;
	[reverseGeocoder start];
	[location release];
}

#pragma mark -
#pragma mark View life cycle

- (void)viewDidLoad {
	gecoder.text = @"";
	dist.text = [NSString stringWithFormat:@"%.0f m", distance];
	[super viewDidLoad];
}

#pragma mark -
#pragma mark MKReverseGeocoderDelegate methods

// Questo metodo viene chiamato quando il reverse geocoding termina con successo
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	NSDictionary *addressData = placemark.addressDictionary;
	CGFloat y = 150;
	for (NSString *key in [addressData allKeys]) {
		if ([key compare:@"FormattedAddressLines"] != NSOrderedSame) {
			UILabel *newRow1 = [[UILabel alloc] initWithFrame:CGRectMake(5, y, 310, 24)];
			newRow1.backgroundColor = [UIColor clearColor];
			newRow1.textColor = [UIColor whiteColor];
			newRow1.text = [NSString stringWithFormat:@"%@: %@", key, [addressData objectForKey:key]];
			[[self view] addSubview:newRow1];
			y += 24;
		}
	}
}

// Questo metodo viene chiamato quando il reverse geocoding fallisce
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	gecoder.text = @"Errore di connessione, riprovare.";
}
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[reverseGeocoder release], reverseGeocoder = nil;
	[gecoder release];
	[dist release];
    [super dealloc];
}

@end
