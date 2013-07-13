//
//  Info.h
//  Progetto LAP1
//
//  Created by distegu on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Info : UIViewController {
	IBOutlet UITableView *tabella;
	NSMutableArray * cronologia;
	
}

@property (nonatomic, retain) UITableView *tabella;
@property (nonatomic, retain) NSMutableArray *cronologia;

- (void) aggiornaTabella;

@end
