//
//  Sms.m
//  Progetto LAP1
//
//  Created by distegu on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sms.h"
#import "SynthesizeSingleton.h"

@implementation Sms

@synthesize destSms, testoSms, onSms;

SYNTHESIZE_SINGLETON_FOR_CLASS(Sms);

-(void) settingTestoSms:(NSString *)segContr{
	testoSms.text = segContr;
}

-(NSString *) gettingTestoSms{
	return testoSms.text;
}

-(void) settingDestSms:(NSString *)segContr{
	destSms.text = segContr;
}

-(NSString *) gettingDestSms{
	return destSms.text;
}


-(void) settingOnSms:(BOOL)segContr{
	onSms.on = segContr;
}

-(BOOL) gettingOnSms{
	return onSms.on;
}

//Nasconde la tastiera
-(IBAction)textFieldDone:(id)sender{
	[sender resignFirstResponder];
}


//Chiude la tastiera nelle view delle notifiche
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	if ([text isEqualToString: @"\n" ] ) {
		[textView resignFirstResponder ];
		return NO;
	}
	return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[destSms release];
	[onSms release];
	[testoSms release];
	
}

@end
