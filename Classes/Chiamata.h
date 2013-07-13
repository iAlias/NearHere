//
//  Chiamata.h
//  Progetto LAP1
//
//  Created by distegu on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Chiamata : UIViewController {

	
	IBOutlet UITextField *destChiamate;
	IBOutlet UISwitch *onChiamate;
	
}

@property (retain,nonatomic) IBOutlet UITextField *destChiamate;
@property (retain,nonatomic) IBOutlet UISwitch *onChiamate;


- (void) settingOnChiamate:(BOOL)segContr;
- (BOOL) gettingOnChiamate;
- (void) settingDestChiamate:(NSString *)segContr;
- (NSString *) gettingDestChiamate;

+ (Chiamata *) sharedChiamata;

@end
