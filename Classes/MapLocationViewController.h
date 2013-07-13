//
//  MapLocationViewController.h
//  Progetto LAP1
//
//  Created by Di Stefano Antonino - Gugliotta Alberto 02/02/2011.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "InfoViewController.h";
#import "MapViewAnnotation.h"


@interface MapLocationViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate> {
	IBOutlet UISearchBar *searchBarLocation;
	IBOutlet MKMapView *mapViewSearch;
	IBOutlet UIBarButtonItem *now;
	IBOutlet UIBarButtonItem *add;
	IBOutlet UIBarButtonItem *del;
	IBOutlet UIBarButtonItem *setting;
	IBOutlet UIBarButtonItem *startStop;
	IBOutlet UIImageView *green;
	IBOutlet UIActivityIndicatorView *load;
	InfoViewController *infoView;
	CLLocationManager *myManager;
	MapViewAnnotation *dest;
	NSTimer *timer;
	BOOL controlTap;
	BOOL isInvalidate;
	BOOL isDeleted;
	BOOL pinInserito;
	BOOL controllaOn;
	BOOL isNotify;
	BOOL isAlert;
	int type;
	float newLong;
	float newLat;
	float myLong;
	float myLat;
	float distanza;
	float range;
	UITextField *nomePref;
}

- (id)init;
- (CLLocationCoordinate2D)getLocationFromAddress:(NSString*)address;
- (IBAction)startUpdate;
- (IBAction)addAnnotation;
- (IBAction)deleteAnnotation;
- (void)controlla;
- (IBAction)textFieldDone:(id)sender;
- (IBAction)calcolaZoom;
- (IBAction)start;
- (IBAction)search;
- (void)showIstruzioniPage:(id)sender;
- (void)removeSetting:(id)sender;
- (void)addCustomAnnotation:(CLLocationDegrees)longitude latitude:(CLLocationDegrees)latitude title:(NSString *)title subTitle:(NSString *)subTitle;
- (void)impostaLocalNotification:(NSDate *)dataNotifica ConNome:(NSString *)nome;
- (void) visualizzaMessaggio:(NSString*)message titolo:(NSString*)titoloFinestra;
- (void)aggiornaDistanza:(MapViewAnnotation *)annotation;
- (void)inviaNotifiche;
- (void)creaNotifica;
- (void)inviaMail;
- (void)inviaSms;
- (IBAction) saveCrono;
- (void) caricaAnnotation:(MapViewAnnotation *)a;
- (IBAction)backInfo;
- (void) aggiornaDistanzaPin:(MapViewAnnotation *)annotation;

+ (MapLocationViewController *) sharedMapLocationViewController;

@end

