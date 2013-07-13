//
//  Mail.h
//  Progetto LAP1
//
//  Created by distegu on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Mail : UIViewController {
	
	IBOutlet UITextField *destMail;
	IBOutlet UITextField *oggettoMail;
	IBOutlet UITextView *testoMail;
	IBOutlet UISwitch *onMail;
	
}

@property (retain,nonatomic) IBOutlet UITextField *destMail;
@property (retain,nonatomic) IBOutlet UITextField *oggettoMail;
@property (retain,nonatomic) IBOutlet UITextView *testoMail;
@property (retain,nonatomic) IBOutlet UISwitch *onMail;


-(id) init;
- (void) settingDestMail:(NSString *)segContr;
- (NSString *) gettingDestMail;
- (void) settingOggettoMail:(NSString *)segContr;
- (NSString *) gettingOggettoMail;
- (void) settingTestoMail:(NSString *)segContr;
- (NSString *) gettingTestoMail;
- (void) settingOnMail:(BOOL)segContr;
- (BOOL) gettingOnMail;

+ (Mail *) sharedMail;

@end
