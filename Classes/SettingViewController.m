//
//  SettingViewController.m
//  Progetto LAP1
//
//  Created by distegu on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "SynthesizeSingleton.h"
#import "Reachability.h"


@implementation SettingViewController

@synthesize slider, label, segControl, segNotify, impostaNotifica;

SYNTHESIZE_SINGLETON_FOR_CLASS(SettingViewController);

-(id) init{
	if(self = [super init]) {
		
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[self aggiornaBottone];
	[self eseguiControllo];
    [super viewDidLoad];
	
}

// Carica le View Sms, Mail e Chiamata per consentire di caricare i dati salvati quando viene selezionato un preferito (altrimenti la prima volta non vengono caricati)
- (void) caricaView{
	[self.view addSubview:[[Mail sharedMail] view]];
	[self.view addSubview:[[Chiamata sharedChiamata] view]];
	[self.view addSubview:[[Sms sharedSms] view]];
	 
	 [[[Chiamata sharedChiamata] view] removeFromSuperview];
	 [[[Mail sharedMail] view] removeFromSuperview];
	 [[[Sms sharedSms] view] removeFromSuperview];
}

//Apre le view per inserire le impostazioni sulle notifiche
-(IBAction)impostazioniNotifica{
	int type1 = segNotify.selectedSegmentIndex;
	NSString *name = [[UIDevice currentDevice] model];
	
	switch (type1) {
		case 0:
			[self showMail];
			break;
			
		case 1:
			if (![name isEqualToString:@"iPhone"]) {
				[self visualizzaMessaggio:NSLocalizedString(@"nonFunziona", @"") titolo:NSLocalizedString(@"attenzione", @"")];
			}
			else
				[self showChiamate];
			break;
			
		case 2:
			if (![name isEqualToString:@"iPhone"]) {
				[self visualizzaMessaggio:NSLocalizedString(@"nonFunziona", @"") titolo:NSLocalizedString(@"attenzione", @"")];
			}
			else
				[self showSms];
			break;
	}
}

#pragma mark ABPeoplePickerNavigationController


//Apre la Rubrica e nasconde tastiera
-(IBAction)showPeoplePickerController{
	[[[Sms sharedSms] destSms] resignFirstResponder];
	[[[Chiamata	sharedChiamata] destChiamate] resignFirstResponder];
	[[[Mail sharedMail] destMail] resignFirstResponder];
	
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], 
							   [NSNumber numberWithInt:kABPersonEmailProperty],
							   [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
	picker.displayedProperties = displayedItems;
	[self presentModalViewController:picker animated:YES];
    [picker release];	
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
	return YES;
}

//Aggiorna il destinatario scegliendolo dalla rubrica
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
	ABMultiValueRef phoneProperty = ABRecordCopyValue(person,property);
	NSString *phone = (NSString *)ABMultiValueCopyValueAtIndex(phoneProperty,identifier);
	int type1 = segNotify.selectedSegmentIndex;
	switch (type1) {
		case 0:{
			[[Mail sharedMail] settingDestMail:phone];
			[[Mail sharedMail] settingOnMail:TRUE];
			[[Sms sharedSms] settingOnSms:FALSE];
			[[Chiamata sharedChiamata] settingOnChiamate:FALSE];
		}
			break;
		case 1:{
			[[Chiamata sharedChiamata] settingDestChiamate:phone];
			[[Chiamata sharedChiamata] settingOnChiamate:TRUE];
			[[Sms sharedSms] settingOnSms:FALSE];
			[[Mail sharedMail] settingOnMail:FALSE];
		}
			break;
		case 2:{
			[[Sms sharedSms] settingDestSms:phone];
			[[Sms sharedSms] settingOnSms:TRUE];
			[[Mail sharedMail] settingOnMail:FALSE];
			[[Chiamata sharedChiamata] settingOnChiamate:FALSE];
		}
			break;
	}
	[phone release];
	[self dismissModalViewControllerAnimated:YES];
	return NO;
}


//Elimina la rubrica alla pressione del tasto Cancel
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;{
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark Apri e chiudi View


//Appare la view per impostare la mail
-(IBAction)showMail {		
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[self view]cache:YES];
	[[self view] addSubview:[[Mail sharedMail] view]];
	[UIView commitAnimations];
}


//Salva lo stato della mail e controlla se il destinatario è stato inserito
-(IBAction)removeMail:(id)sender {
	if ([[[Mail sharedMail] gettingDestMail] isEqualToString:@""]) 
		[self visualizzaMessaggio:NSLocalizedString(@"removeMail", @"") titolo:NSLocalizedString(@"attenzione", @"")];
	else{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[self view]cache:YES];
		[[[Mail sharedMail] view] removeFromSuperview];
		[UIView commitAnimations];		
		[self aggiornaBottone];		
	}
}

//Torna alla view delle impostazioni
-(IBAction)backMail{
	if ([[[Mail sharedMail] gettingDestMail] isEqualToString:@""])
		[[Mail sharedMail] setOnMail:FALSE];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[self view]cache:YES];
	[[[Mail sharedMail] view] removeFromSuperview];
	[UIView commitAnimations];		
	[self aggiornaBottone];	
}

//Appare la view per impostare la chiamata
-(IBAction)showChiamate{		
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[self view]cache:YES];
	[[self view] addSubview:[[Chiamata sharedChiamata] view]];
	[UIView commitAnimations];
}

//Salva il numero da chiamare e controlla che sia stato inserito
-(IBAction)removeChiamate:(id)sender {
	if ([[[Chiamata sharedChiamata] gettingDestChiamate] isEqualToString:@""])
		[self visualizzaMessaggio:NSLocalizedString(@"removeChiamate", @"") titolo:NSLocalizedString(@"attenzione", @"")];
	else{	
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[self view]cache:YES];
		[[[Chiamata sharedChiamata] view] removeFromSuperview];
		[UIView commitAnimations];		
		[self aggiornaBottone];		
	}
}

//Torna alla view della impostazioni
-(void)backChiamate{
	if ([[[Chiamata sharedChiamata]gettingDestChiamate] isEqualToString:@""])
		[[Chiamata sharedChiamata] settingOnChiamate:FALSE];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[self view]cache:YES];
	[[[Chiamata sharedChiamata] view] removeFromSuperview];
	[UIView commitAnimations];		
	[self aggiornaBottone];	
}

//Appare la view per impostare l'sms
-(IBAction)showSms {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[self view]cache:YES];
	[[self view] addSubview:[[Sms sharedSms] view]];
	[UIView commitAnimations];
}

//Salva lo stato dell'sms e controlla se il destinatario è stato inserito
-(IBAction)removeSms:(id)sender {
	if ([[[Sms sharedSms] gettingDestSms] isEqualToString:@""])
		[self visualizzaMessaggio:NSLocalizedString(@"removeSms", @"") titolo:NSLocalizedString(@"attenzione", @"")];
	else {	
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[self view]cache:YES];
		[[[Sms sharedSms] view] removeFromSuperview];
		[UIView commitAnimations];		
		[self aggiornaBottone];	
	}
}

//Torna alla view delle impostazioni
-(IBAction)backSms{
	if ([[[Sms sharedSms] gettingDestSms] isEqualToString:@""])
		[[Sms sharedSms] setOnSms:FALSE];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[self view]cache:YES];
	[[[Sms sharedSms] view] removeFromSuperview];
	[UIView commitAnimations];		
	[self aggiornaBottone];	
}

//Appare la view per impostare l'sms
-(IBAction)showInfo {
	[self caricaView];
	Info *tmp = [[Info alloc]init];
	info = tmp.view;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[self view]cache:YES];
	[[self view] addSubview:info];
	[UIView commitAnimations];
}

//Salva lo stato dell'sms e controlla se il destinatario è stato inserito
-(IBAction)removeInfo {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[self view]cache:YES];
	[info removeFromSuperview];
	[UIView commitAnimations];		
	[self aggiornaBottone];	
}

#pragma mark Get/Set
-(UIView *)gettingView{
	return self.view;
}

-(int) gettingSegControl{
	return segControl.selectedSegmentIndex;
}

-(void) settingSegControl:(int)segContr{
	segControl.selectedSegmentIndex = segContr;
}

-(float) gettingSlider{
	return [slider value];
}

-(void) settingSlider:(float)segContr{
	slider.value = segContr;
	label.text = [NSString stringWithFormat:@"%0.f",[slider value]];
}

-(UILabel *) gettingLabel{
	return label;
}

-(void) settingLabel:(UILabel *)segContr{
	label.text = segContr.text ;
}

-(UIButton *) gettingImpostaNotifica{
	return impostaNotifica;
}

-(void) settingImpostaNotifica:(UIButton *)segContr{
	impostaNotifica = segContr;
}


-(void) settingSegNotify:(int)segContr{
	segNotify.selectedSegmentIndex = segContr;
}

-(int) gettingSegNotify{
	return segNotify.selectedSegmentIndex;
}


#pragma mark Vari


-(IBAction)disattivaNotificaSms{
	if ([[Sms sharedSms] gettingOnSms]) {
		[[Mail sharedMail] settingOnMail:FALSE];
		[[Chiamata sharedChiamata] settingOnChiamate:FALSE];
	}
}

-(IBAction)disattivaNotificaChiamata{
	if ([[Chiamata sharedChiamata] gettingOnChiamate]){
		[[Mail sharedMail] settingOnMail:FALSE];
		[[Sms sharedSms] settingOnSms:FALSE];
	}
}

-(IBAction)disattivaNotificaMail{
	if ([[Mail sharedMail] gettingOnMail]) {
		[[Sms sharedSms] settingOnSms:FALSE];
		[[Chiamata sharedChiamata] settingOnChiamate:FALSE];
	}
}



//Aggiorna il bottone quando viene cambiato UISegmented control (Mail - Chiamate - Sms) 
-(IBAction)aggiornaBottone{
	int type1 = segNotify.selectedSegmentIndex;
	switch (type1) {
		case 0:
			impostaNotifica.titleLabel.text = NSLocalizedString(@"aggiornaBottone1", @"");
			break;
		case 1:
			impostaNotifica.titleLabel.text = NSLocalizedString(@"aggiornaBottone2", @"");
			break;
		case 2:
			impostaNotifica.titleLabel.text = NSLocalizedString(@"aggiornaBottone3", @"");
			break;
	}
}

//aggiorna il valore della label range quando si sposta lo slider
-(void)sliderAction{
	label.text = [NSString stringWithFormat:@"%0.f",[slider value]];
}

//imposta una UIAlert
- (void) visualizzaMessaggio:(NSString*)message titolo:(NSString*)titoloFinestra{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titoloFinestra message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	if (alertView) { 
		[alertView release]; 
	}
}

//controlla se il dispositivo è connesso alla rete
-(void)eseguiControllo {
	BOOL isConnesso = FALSE;
	internetReach = [[Reachability reachabilityForInternetConnection] retain];
	isConnesso = [self check:internetReach connesso:isConnesso];
	
	wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	isConnesso = [self check:wifiReach connesso:isConnesso];
}

-(BOOL)check:(Reachability*) curReach connesso:(BOOL)c {
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
	
	switch (netStatus){
        case NotReachable:{
			if (c) {
				UIAlertView *tmp = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"attenzione", @"") message:NSLocalizedString(@"nonConnesso", @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[tmp show];
				[tmp release];
			}else c = TRUE;
			
			break;
		}
		case ReachableViaWWAN:{
            break;
		}
        case ReachableViaWiFi:{
			break;
		}
	}
	return c;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated{
	self.view.frame = [[UIScreen mainScreen] applicationFrame];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[slider release];
	[label release];
	[impostaButton release];
	[segControl release];
	[info release];
	[segNotify release];
	[impostaNotifica release];
	[wifiReach release];
	[internetReach release];
    [super dealloc];
}

@end
