//
//  MapLocationViewController.m
//  Progetto LAP1
//
//  Created by Di Stefano Antonino - Gugliotta Alberto 02/02/2011.
//  Copyright 2010. All rights reserved.
//

#import "MapLocationViewController.h"
#import "SettingViewController.h"
#import "Info.h"
#import "Favorite.h"
#import "FavoritesData.h"
#import "SynthesizeSingleton.h"

@implementation MapLocationViewController

SYNTHESIZE_SINGLETON_FOR_CLASS(MapLocationViewController);


#define chiaveNome @"chiaveNomeDictionary"

#pragma mark NearHere

-(id) init{
	if(self = [super init]) {
	}
	return self;
}

//inizializza il CoreLocation
-(void)viewDidLoad{
	newLat = 0.000;
	newLong = 0.000;
	range = [[SettingViewController sharedSettingViewController]  gettingSlider];
	myManager = [[CLLocationManager alloc] init];
	myManager.delegate = self;
	myManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;	
	[myManager startUpdatingLocation];
	isAlert = FALSE;
	isDeleted = TRUE;
	pinInserito = FALSE;
	controllaOn = FALSE;
	[super viewDidLoad];
}

//confronta ogni 5 secondi la distanza attuale con quella di destinazione
-(void)controlla{
	if (controllaOn) {
		type = [[SettingViewController sharedSettingViewController]  gettingSegControl];
		range = [[SettingViewController sharedSettingViewController]  gettingSlider];
		switch (type) {
			case 0:
				if (distanza <= range) {
					[[UIApplication sharedApplication] cancelAllLocalNotifications];
					[self impostaLocalNotification:[NSDate date] ConNome:NSLocalizedString(@"controlla1", @"")];
					[timer invalidate];
					isInvalidate = TRUE;
					[myManager stopUpdatingLocation];
					startStop.title = @"Start";
					green.hidden = YES;
					controllaOn = FALSE;
				}
				else{
					timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(aggiorna) userInfo:nil repeats:NO];
					isInvalidate = FALSE;
				}
				break;
			case 1:
				if (distanza >= range) {
					[[UIApplication sharedApplication] cancelAllLocalNotifications];
					[self impostaLocalNotification:[NSDate date] ConNome:NSLocalizedString(@"controlla2", @"")];
					[timer invalidate];
					isInvalidate = TRUE;
					[myManager stopUpdatingLocation];
					startStop.title = @"Start";
					green.hidden = YES;
					controllaOn = FALSE;
				}
				else{
					timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(aggiorna) userInfo:nil repeats:NO];
					isInvalidate = FALSE;
				}
				break;
		}	
	}
}


//scarica le coordinate della posizione attuale
-(void)aggiorna{
	[self aggiornaDistanza:dest];
	MKCoordinateSpan span;
	span.latitudeDelta = 0.001;
	span.longitudeDelta = 0.001;
	CLLocationCoordinate2D Coordinates;
	Coordinates.latitude = newLat;
	Coordinates.longitude = newLong;
	MKCoordinateRegion Region;
	Region.span = span;
	Region.center = Coordinates;
	[self controlla];	
}

//aggiorna la distanza quando viene aggiunta un annotation
- (void)aggiornaDistanza:(MapViewAnnotation *)annotation{
	[myManager startUpdatingLocation];
	CLLocation *location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
	CLLocationDistance d = [mapViewSearch.userLocation.location distanceFromLocation:location];
	distanza = (float)d;	
	[location release];
}

//Scarica le coordinate della posizione attuale
-(IBAction)startUpdate {
	[myManager startUpdatingLocation];
	if (newLat == 0.000 && newLong == 0.000 )
		[self visualizzaMessaggio:NSLocalizedString(@"gpsoff", @"") titolo:@"attenzione"];
	else {
		mapViewSearch.showsUserLocation = TRUE;
		mapViewSearch.mapType = MKMapTypeHybrid;
		MKCoordinateSpan span;
		span.latitudeDelta = 0.003;
		span.longitudeDelta = 0.003;
		CLLocationCoordinate2D Coordinates;
		Coordinates.latitude = newLat;
		Coordinates.longitude = newLong;
		MKCoordinateRegion Region;
		Region.span = span;
		Region.center = Coordinates;
		[mapViewSearch setRegion:Region animated:TRUE];
		if ([startStop.title isEqualToString:@"Start"]) 
			[myManager stopUpdatingLocation];
	}
}

//Calcola zoom che visualizza i due punti
-(IBAction)calcolaZoom{
	if(pinInserito){
		float tmp = distanza;
		
		if (distanza > 9000000) {
			tmp = 9000000;
		}
		float zoom = (0.003 * tmp) / 150;
		mapViewSearch.showsUserLocation = TRUE;
		mapViewSearch.mapType = MKMapTypeHybrid;
		MKCoordinateSpan span;
		span.latitudeDelta = zoom;
		span.longitudeDelta = zoom;
		CLLocationCoordinate2D Coordinates;
		Coordinates.latitude = newLat;
		Coordinates.longitude = newLong;
		MKCoordinateRegion Region;
		Region.span = span;
		Region.center = Coordinates;
		[mapViewSearch setRegion:Region animated:TRUE];
	}
	else
		[self visualizzaMessaggio:NSLocalizedString(@"calcolaZoom", @"") titolo:NSLocalizedString(@"attenzione", @"")];
		
}	


//rimuove tutte le annotation nella mappa
-(IBAction)deleteAnnotation{
	controllaOn = FALSE;
	[myManager stopUpdatingLocation];
	if ([startStop.title isEqualToString:@"Stop"]){
		startStop.title = @"Start";
		green.hidden = YES;
	}
	if(!isDeleted){
		[mapViewSearch removeAnnotations:mapViewSearch.annotations];
		if(!isInvalidate){
			[timer invalidate];
			isInvalidate = TRUE;
		}
		[self visualizzaMessaggio:NSLocalizedString(@"deleteAnnotation1", @"") titolo:NSLocalizedString(@"attenzione", @"")];
		isDeleted = TRUE;
	}
	else
		[self visualizzaMessaggio:NSLocalizedString(@"deleteAnnotation2", @"") titolo:NSLocalizedString(@"attenzione", @"")];
	pinInserito = FALSE;
	[load stopAnimating];
}

//aggiunge una annotation
-(IBAction)addAnnotation{
	if(!isInvalidate){
		[timer invalidate];
		isInvalidate = TRUE;
	}
	controllaOn = FALSE;
	[myManager stopUpdatingLocation];
	if ([startStop.title isEqualToString:@"Stop"]){
		startStop.title = @"Start";
		green.hidden = YES;
	}
	UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
	tgr.numberOfTapsRequired = 1;
	tgr.numberOfTouchesRequired = 1;
	mapViewSearch.showsUserLocation = TRUE;
	[mapViewSearch addGestureRecognizer:tgr];
	[tgr release];
	controlTap = TRUE;
}

//rileva le coordinate del punto toccato ed aggiunge l'annotation
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer{
	if(controlTap){
		[mapViewSearch removeAnnotations:mapViewSearch.annotations];
		if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
			return;	
		CGPoint touchPoint = [gestureRecognizer locationInView:mapViewSearch];
		CLLocationCoordinate2D touchMapCoordinate = [mapViewSearch convertPoint:touchPoint toCoordinateFromView:mapViewSearch];
		myLat = touchMapCoordinate.latitude;
		myLong = touchMapCoordinate.longitude;
		MapViewAnnotation *a = [[[MapViewAnnotation alloc] initWithCoordinate:myLong latitude:myLat] autorelease];
		[mapViewSearch addAnnotation:a];
		[a setAnnotationTitle:NSLocalizedString(@"handleGesture1", @"")];
		[mapViewSearch selectAnnotation:a animated:YES];
		dest = [[MapViewAnnotation alloc] initWithCoordinate:a.coordinate.longitude latitude:a.coordinate.latitude];
		[self aggiornaDistanzaPin:dest];
		type = [[SettingViewController sharedSettingViewController]gettingSegControl];
		range = [[SettingViewController sharedSettingViewController]gettingSlider];
		isNotify = TRUE;
		switch (type) {
			case 0:
				if (distanza <= range) {
					[self visualizzaMessaggio:NSLocalizedString(@"handle&Custom2", @"") titolo:NSLocalizedString(@"attenzione", @"")];		
					isNotify = FALSE;
				}
				else{
					[self creaNotifica];
				}
				break;
			case 1:
				if (distanza >= range) {
					[self visualizzaMessaggio:NSLocalizedString(@"handle&Custom3", @"") titolo:NSLocalizedString(@"attenzione", @"")];
					isNotify = FALSE;
				}
				else{
					[self creaNotifica];
				}
				break;
		}
		controlTap = FALSE;
		isDeleted = FALSE;
		pinInserito = TRUE;
	}
}

//inserisce una annotation dalla searchbar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	if(!isInvalidate){
		[timer invalidate];
		isInvalidate = TRUE;
	}
	controllaOn = FALSE;
	[myManager stopUpdatingLocation];
	if ([startStop.title isEqualToString:@"Stop"]){
		startStop.title = @"Start";
		green.hidden = YES;
	}
	[searchBar resignFirstResponder];
	searchBarLocation.hidden = YES;
	[mapViewSearch removeAnnotations:mapViewSearch.annotations];	
	CLLocationCoordinate2D location = [self getLocationFromAddress: searchBar.text];
	[self addCustomAnnotation:location.longitude latitude:location.latitude title: searchBar.text subTitle: NSLocalizedString(@"handleGesture1", @"")];	
}


//aggiunge una annotation
- (void)addCustomAnnotation:(CLLocationDegrees)longitude latitude:(CLLocationDegrees)latitude title:(NSString *)title subTitle:(NSString *)subTitle {	
	if (!(latitude == 0.000 && longitude == 0.000)){
		MapViewAnnotation *annotation = [[[MapViewAnnotation alloc] initWithCoordinate:longitude latitude:latitude] autorelease];
		[mapViewSearch addAnnotation:annotation];
		[annotation setAnnotationTitle:title];
		[annotation setAnnotationSubTitle:subTitle];
		dest = [[MapViewAnnotation alloc] initWithCoordinate:annotation.coordinate.longitude latitude:annotation.coordinate.latitude];
		[self aggiornaDistanzaPin:dest];
		[mapViewSearch selectAnnotation:annotation animated:YES];
		type = [[SettingViewController sharedSettingViewController]  gettingSegControl];
		range = [[SettingViewController sharedSettingViewController]  gettingSlider];
		isNotify = TRUE;
		switch (type) {
			case 0:
				if (distanza < range) {
					[self visualizzaMessaggio:NSLocalizedString(@"handle&Custom2", @"") titolo:NSLocalizedString(@"attenzione", @"")];
					isNotify = FALSE;
				}
				else{
					[self creaNotifica];
				}
				break;
			case 1:
				if (distanza >= range) {
					[self visualizzaMessaggio:NSLocalizedString(@"handle&Custom3", @"") titolo:NSLocalizedString(@"attenzione", @"")];
					isNotify = FALSE;
				}
				else{
					[self creaNotifica];
				}
				break;
		}			
		
		isDeleted = FALSE;
		pinInserito = TRUE;		
	}
}

//scarica le coordinate per aggiornare la distanza
- (void) aggiornaDistanzaPin:(MapViewAnnotation *)annotation{
	[myManager startUpdatingLocation];
	CLLocation *location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
	CLLocationDistance d = [mapViewSearch.userLocation.location distanceFromLocation:location];
	distanza = (float)d;
	[myManager stopUpdatingLocation];
	[location release];
}

//nasconde la tastiera
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	NSLog(@"searchBarCancelButtonClicked");
	searchBarLocation.hidden = YES;
    [searchBar resignFirstResponder];
}

//cambia il titolo all'UIButton start/stop e fà partire il programma richiamando il metodo controlla
-(IBAction)start{
	if(!pinInserito)
		[self visualizzaMessaggio:NSLocalizedString(@"start", @"") titolo:NSLocalizedString(@"attenzione", @"")];
	else{
		if([startStop.title isEqualToString:@"Start"]){
			controllaOn = TRUE;
			[myManager startUpdatingLocation];
			[self controlla];
			startStop.title = @"Stop";
			green.hidden = NO;
		}
		else{
			controllaOn = FALSE;
			[myManager stopUpdatingLocation];
			startStop.title = @"Start";
			green.hidden = YES;
		}
		[self startUpdate];
	}
}

//visualizza la searchbar
-(IBAction)search{
	searchBarLocation.delegate = self;
	searchBarLocation.hidden = NO;
	[searchBarLocation becomeFirstResponder];
}

//visualizza la schermata di setting
-(void)showIstruzioniPage:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	[self.view addSubview:[[SettingViewController sharedSettingViewController] gettingView]];
	[UIView commitAnimations];
}

//rimuove la schermata di setting
- (void)removeSetting:(id)sender{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self view] cache:YES];
	[[[SettingViewController sharedSettingViewController] view] removeFromSuperview];
	[UIView commitAnimations];
	if (!isAlert) {
		[self visualizzaMessaggio:NSLocalizedString(@"removeIstruzioniPage", @"") titolo:NSLocalizedString(@"suggerimento", @"")];
		isAlert = TRUE;
	}
}

#pragma mark Notifiche


//Crea la notifica dopo aver aggiunto la destinazione
-(void)creaNotifica{
	range = [[SettingViewController sharedSettingViewController]  gettingSlider];	
	NSString *tmpString = NSLocalizedString(@"creaNotifica1", @"");
	if([[SettingViewController sharedSettingViewController]  gettingSegControl] == 0)
		tmpString = [tmpString stringByAppendingString:NSLocalizedString(@"creaNotifica2", @"")];
	else 
		tmpString = [tmpString stringByAppendingString:NSLocalizedString(@"creaNotifica3", @"")];
	NSString *tmp;
	tmp = [NSString stringWithFormat:@"%0.f",range];
	tmpString = [tmpString stringByAppendingString:tmp];
	tmpString = [tmpString stringByAppendingString: NSLocalizedString(@"creaNotifica4", @"")];
	if([[Mail sharedMail] gettingOnMail])
		tmpString = [tmpString stringByAppendingString: @" e Mail" ];
	if([[Chiamata sharedChiamata] gettingOnChiamate])
		tmpString = [tmpString stringByAppendingString: NSLocalizedString(@"creaNotifica6", @"")];
	if([[Sms sharedSms]  gettingOnSms])
		tmpString = [tmpString stringByAppendingString: NSLocalizedString(@"creaNotifica7", @"") ];
	tmpString = [tmpString stringByAppendingString: NSLocalizedString(@"creaNotifica5", @"") ];
	[self visualizzaMessaggio:tmpString titolo:NSLocalizedString(@"attenzione", @"")];
}
		
//Invia tutte le notifiche impostate
-(void) inviaNotifiche{
	if (isNotify){
		if([[Sms sharedSms] gettingOnSms]){
			[self inviaSms];
		}
		if([[Mail sharedMail] gettingOnMail]){
			[self inviaMail];
		}
		if([[Chiamata sharedChiamata]  gettingOnChiamate]){
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"tel:// %@", [[Chiamata sharedChiamata] gettingDestChiamate]]]];
		}
	}
}

//Invia la mail preimpostata
- (void) inviaMail{
	MFMailComposeViewController *email = [[MFMailComposeViewController alloc] init];
	email.mailComposeDelegate = self;
	if([MFMailComposeViewController canSendMail]){
		[email setToRecipients:[NSArray arrayWithObjects:[[Mail sharedMail]  gettingDestMail], nil]];
		[email setSubject:[[Mail sharedMail] gettingOggettoMail]];
		[email setMessageBody:[[Mail sharedMail]  gettingTestoMail] isHTML:NO];
		[self presentModalViewController:email animated:YES];
	}
	[email release];
}

//Invia l'sms impostato
-(void) inviaSms{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
	picker.recipients = [NSArray arrayWithObject:[[Sms sharedSms]  gettingDestSms]]; 
	picker.body = [[Sms sharedSms]  gettingTestoSms];
	[self presentModalViewController:picker animated:YES];
	[picker release];	
}

-(void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{

}

//Avverte l'utente se la mail non viene inviata
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
	[self dismissModalViewControllerAnimated:YES];	
	if (result == MFMailComposeResultFailed){
		[self visualizzaMessaggio:NSLocalizedString(@"mailComposeController1", @"") titolo:NSLocalizedString(@"mailComposeController2", @"")];
	}
}

//visualizza un UIAlert per inserire il nome della destinazione da salvare
- (IBAction) saveCrono{
	if (!pinInserito)
		[self visualizzaMessaggio:NSLocalizedString(@"saveFavorites1", @"") titolo:NSLocalizedString(@"attenzione", @"")];
	else {
		UIAlertView *pref = [[UIAlertView alloc] initWithTitle:@"Salva in preferiti" message:@"                                     " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		nomePref = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
		nomePref.keyboardType = UIKeyboardTypeAlphabet;
		nomePref.delegate = self;
		nomePref.placeholder = @"Es: Casa";
		nomePref.keyboardAppearance = UIKeyboardAppearanceAlert;
		nomePref.autocorrectionType = UITextAutocorrectionTypeNo;
		[nomePref setBackgroundColor:[UIColor whiteColor]];
		[nomePref becomeFirstResponder];
		[pref addSubview:nomePref];
		[pref show];
		[pref release];		
	}
}

//salva l'oggetto nella cronologia 
- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex{
	if (buttonIndex != [alertView cancelButtonIndex]) {			
		if ([nomePref.text isEqualToString:@""])
			[self visualizzaMessaggio:NSLocalizedString(@"saveFavorites2", @"") titolo:NSLocalizedString(@"attenzione", @"")];
		else{
			Favorite *tmp = [[Favorite alloc] init];
			tmp = [[FavoritesData sharedFavoritesData] aggiornaValori:dest name:nomePref.text];
			[[FavoritesData sharedFavoritesData] addCronologia:tmp];	
		}
	}
	Info *tmp = [[Info alloc] init];
	[tmp aggiornaTabella];
	[tmp release];
}

#pragma mark MKMapViewDelegate methods


//Inquadra nella mappa la posizione attuale dopo aver aggiunto una annotation
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	for (MKAnnotationView *annotationView in views) {
		if (annotationView.annotation == mapView.userLocation) {
			MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
			MKCoordinateRegion region = MKCoordinateRegionMake(mapView.userLocation.coordinate, span);
			[mapView setRegion:region animated:YES];
		}
	}
}

//crea l'annotation
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if (annotation == mapView.userLocation) {
		return nil;
	}
	MKPinAnnotationView *pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"] autorelease];
	pinView.pinColor = MKPinAnnotationColorRed;
	pinView.canShowCallout = YES;
	pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	pinView.animatesDrop = YES;
	return pinView;
}

//Crea un view controller contenente le informazioni di destinazione
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	infoView = [[InfoViewController alloc] init];
	[infoView setting:mapView.userLocation.location annotation:view.annotation];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[self view]cache:YES];
	[[self view] addSubview:infoView.view];
	[UIView commitAnimations];
}

//rimuove la schermata delle info
-(IBAction)backInfo{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[self view]cache:YES];
	[infoView.view removeFromSuperview];
	[UIView commitAnimations];
}

//inizia l'animazione della rotellina mentre carica la mappa
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
	[load startAnimating];
}

//ferma l'animazione quando la mappa è caricata
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
	[load stopAnimating];
}

#pragma mark CLLocationManagerDelegate

//avverte in caso di errore nella localizzazione
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
}

//salva le coordinate attuali
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	newLat = newLocation.coordinate.latitude;
	newLong = newLocation.coordinate.longitude;
	NSLog(@"Longitude: %0.f",newLong);
	NSLog(@"Latitude: %0.f",newLat);
}


#pragma mark Get Location From Address

//splitta la stringa della searchbar e restituisce le coordinate
- (CLLocationCoordinate2D)getLocationFromAddress:(NSString*)address {
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", [address stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSString *locationString = [[[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]] autorelease];
	NSArray *listItems = [locationString componentsSeparatedByString:@","];
    double latitude	= 0.0;
    double longitude = 0.0;
    if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
	}
	else
		[self visualizzaMessaggio:NSLocalizedString(@"getLocationFromAddress", @"") titolo:NSLocalizedString(@"attenzione", @"")];
	CLLocationCoordinate2D location;
	location.latitude = latitude;
	location.longitude = longitude;
	return location;
}


#pragma mark Local Notification

//imposta la notifica che verrà visualizzata in background
- (void)impostaLocalNotification:(NSDate *)dataNotifica ConNome:(NSString *)nome{	
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (version >= 4.0){
		UILocalNotification *notifica = [[UILocalNotification alloc] init];
		notifica.fireDate = [dataNotifica dateByAddingTimeInterval:(1)];
		notifica.applicationIconBadgeNumber = 0;
		notifica.timeZone = [NSTimeZone defaultTimeZone];
		notifica.alertBody = nome;
		notifica.alertAction = @"OK";
		notifica.soundName = UILocalNotificationDefaultSoundName;
		NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:nome,chiaveNome, nil];
		notifica.userInfo = infoDict;
		[[UIApplication sharedApplication] scheduleLocalNotification:notifica];
		if (notifica){
			[notifica release];
		[self inviaNotifiche];
		}		
	}
}

//invia una UIAlert dopo la local notification  
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif {
	[self visualizzaMessaggio:[notif.userInfo objectForKey:chiaveNome] titolo:NSLocalizedString(@"fine", @"")];
}

//inserisce il Pin sulla mappa quando viene caricata una destinazioe di preferiti
- (void)caricaAnnotation:(MapViewAnnotation *)a{
		[mapViewSearch removeAnnotations:mapViewSearch.annotations];
		[mapViewSearch addAnnotation:a];
		[a setAnnotationTitle:NSLocalizedString(@"handleGesture1", @"")];
		[mapViewSearch selectAnnotation:a animated:YES];
		dest = [[MapViewAnnotation alloc] initWithCoordinate:a.coordinate.longitude latitude:a.coordinate.latitude];
		[self aggiornaDistanzaPin:dest];
		type = [[SettingViewController sharedSettingViewController]gettingSegControl];
		range = [[SettingViewController sharedSettingViewController]gettingSlider];
		isNotify = TRUE;
		switch (type) {
			case 0:
				if (distanza <= range) {
					[self visualizzaMessaggio:NSLocalizedString(@"handle&Custom2", @"") titolo:NSLocalizedString(@"attenzione", @"")];		
					isNotify = FALSE;
				}
				else{
					[self creaNotifica];
				}
				break;
			case 1:
				if (distanza >= range) {
					[self visualizzaMessaggio:NSLocalizedString(@"handle&Custom3", @"") titolo:NSLocalizedString(@"attenzione", @"")];
					isNotify = FALSE;
				}
				else{
					[self creaNotifica];
				}
				break;
		}
	controlTap = FALSE;
	isDeleted = FALSE;
	pinInserito = TRUE;
}

#pragma mark Metodi Vari

//Nasconde la tastiera
-(IBAction)textFieldDone:(id)sender{	
	[sender resignFirstResponder];
}


//imposta una UIAlert
- (void) visualizzaMessaggio:(NSString*)message titolo:(NSString*)titoloFinestra{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titoloFinestra message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	if (alertView) { 
		[alertView release]; 
	}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



//nasconde il navigation controller alla chiusura di InfoViewController
- (void)viewWillAppear:(BOOL)animated{	
	super.navigationController.navigationBarHidden = YES;
	self.view.frame = [[UIScreen mainScreen] applicationFrame];
}


- (void)dealloc {
	[myManager release];
	[searchBarLocation release];
	[mapViewSearch release];
	[dest release];
	[add release];
	[del release];
	[now release];
	[startStop release];
	[setting release];	
	[infoView release];
	[timer release];
	[nomePref release];
	[green release];
	[load release];
    [super dealloc];
}

@end
