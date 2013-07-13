//
//  SettingViewController.h
//  Progetto LAP1
//
//  Created by distegu on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Sms.h"
#import "Mail.h"
#import "Chiamata.h"
#import "Info.h"

@class Reachability;

@interface SettingViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, UINavigationControllerDelegate>{
	
	IBOutlet UISlider *slider;
	IBOutlet UILabel *label;
	IBOutlet UISegmentedControl *segControl;
	IBOutlet UISegmentedControl *segNotify;
	IBOutlet UIButton *impostaNotifica;
	IBOutlet UIButton *impostaButton;
	NSMutableArray *_favArray;
	NSString *_dataFilePath;
	BOOL favoritesLoaded;
	UIView *info;
	Reachability *internetReach;
    Reachability *wifiReach;
}


@property (retain,nonatomic) IBOutlet UISegmentedControl *segControl;
@property (retain,nonatomic) IBOutlet UISlider *slider;
@property (retain,nonatomic) IBOutlet UILabel *label;
@property (retain,nonatomic) IBOutlet UIButton *impostaNotifica;
@property (retain,nonatomic) IBOutlet UISegmentedControl *segNotify;

- (id)init;
- (IBAction)sliderAction;
- (IBAction)aggiornaBottone;
- (IBAction)impostazioniNotifica;
- (IBAction)showSms;
- (IBAction)removeSms:(id)sender;
- (IBAction)backSms;
- (IBAction)showMail;
- (IBAction)removeMail:(id)sender;
- (IBAction)backMail;
- (IBAction)showChiamate;
- (IBAction)removeChiamate:(id)sender;
- (IBAction)backChiamate;
- (IBAction)showInfo;
- (IBAction)removeInfo;
- (IBAction)disattivaNotificaSms;
- (IBAction)disattivaNotificaChiamata;
- (IBAction)disattivaNotificaMail;
- (IBAction)showPeoplePickerController;
- (void) visualizzaMessaggio:(NSString*)message titolo:(NSString*)titoloFinestra;
- (UIView *)gettingView;
- (int) gettingSegControl;
- (void) settingSegControl:(int)segContr;
- (float) gettingSlider;
- (void) settingSlider:(float)segContr;
- (UILabel *) gettingLabel;
- (void) settingLabel:(UILabel *)segContr;
- (UIButton *) gettingImpostaNotifica;
- (void) settingImpostaNotifica:(UIButton *)segContr;
- (void) settingSegNotify:(int)segContr;
- (int) gettingSegNotify;
- (void)eseguiControllo;
- (BOOL)check:(Reachability*) curReach connesso:(BOOL)c;

+ (SettingViewController *) sharedSettingViewController;

@end
