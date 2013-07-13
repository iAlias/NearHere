//
//  Sms.h
//  Progetto LAP1
//
//  Created by distegu on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Sms : UIViewController {

	IBOutlet UITextField *destSms;
	IBOutlet UITextView *testoSms;
	IBOutlet UISwitch *onSms;
	
}

@property (nonatomic,retain) IBOutlet UITextField *destSms;
@property (retain,nonatomic) IBOutlet UITextView *testoSms;
@property (retain,nonatomic) IBOutlet UISwitch *onSms;

- (void) settingDestSms:(NSString *)segContr;
- (NSString *) gettingDestSms;
- (void) settingTestoSms:(NSString *)segContr;
- (NSString *) gettingTestoSms;
- (void) settingOnSms:(BOOL)segContr;
- (BOOL) gettingOnSms;

+ (Sms *) sharedSms;

@end
