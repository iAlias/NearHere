//
//  Mail.m
//  Progetto LAP1
//
//  Created by distegu on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Mail.h"
#import "SynthesizeSingleton.h"

@implementation Mail

@synthesize destMail, testoMail, oggettoMail, onMail;

SYNTHESIZE_SINGLETON_FOR_CLASS(Mail);


-(id) init{
	if(self = [super init]) {
		
	}
	return self;
}


-(void) settingDestMail:(NSString *)segContr{
	destMail.text = segContr;
}

-(NSString *) gettingDestMail{
	return destMail.text;
}

-(void) settingOggettoMail:(NSString *)segContr{
	oggettoMail.text = segContr;
}

-(NSString *) gettingOggettoMail{
	return oggettoMail.text;
}

-(void) settingTestoMail:(NSString *)segContr{
	testoMail.text = segContr;
}

-(NSString *) gettingTestoMail{
	return testoMail.text;
}

-(void) settingOnMail:(BOOL)segContr{
	onMail.on = segContr;
}

-(BOOL) gettingOnMail{
	return onMail.on;
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
	[destMail release];
	[oggettoMail release];
	[testoMail release];
	[onMail release];
}

@end
