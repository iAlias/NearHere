//
//  Chiamata.m
//  Progetto LAP1
//
//  Created by distegu on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Chiamata.h"
#import "SynthesizeSingleton.h"

@implementation Chiamata

@synthesize destChiamate, onChiamate;

SYNTHESIZE_SINGLETON_FOR_CLASS(Chiamata);


-(void) settingDestChiamate:(NSString *)segContr{
	destChiamate.text = segContr;
}

-(NSString *) gettingDestChiamate{
	return destChiamate.text;
}


-(void) settingOnChiamate:(BOOL)segContr{
	onChiamate.on = segContr;
}

-(BOOL) gettingOnChiamate{
	return onChiamate.on;
}

//Nasconde la tastiera
-(IBAction)textFieldDone:(id)sender{
	[sender resignFirstResponder];
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
	[destChiamate release];
	[onChiamate release];
	
}

@end
