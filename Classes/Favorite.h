//
//  Favorite.h
//  PROGETTO_LAP1
//
//  Created by Di Stefano Antonino - Gugliotta Alberto 02/02/2011.
//  Copyright 2010. All rights reserved.
//

@interface Favorite : NSObject
{
	NSString *nome;
	NSString *destS;
	NSString *destM;
	NSString *destC;
	NSString *testoS;
	NSString *oggettoM;
	NSString *testoM;
	NSString *longit;
	NSString *latit;
	NSString *sliderValue;
	NSString *miAvvMiAll;
	NSString *onS;
	NSString *onM;
	NSString *onC;
}

@property (nonatomic, retain) NSString *nome;
@property (nonatomic, retain) NSString *destS;
@property (nonatomic, retain) NSString *destM;
@property (nonatomic, retain) NSString *destC;
@property (nonatomic, retain) NSString *testoS;
@property (nonatomic, retain) NSString *oggettoM;
@property (nonatomic, retain) NSString *testoM;
@property (nonatomic, retain) NSString *longit;
@property (nonatomic, retain) NSString *latit;
@property (nonatomic, retain) NSString *sliderValue;
@property (nonatomic, retain) NSString *miAvvMiAll;
@property (nonatomic, retain) NSString *onS;
@property (nonatomic, retain) NSString *onM;
@property (nonatomic, retain) NSString *onC;

-(id)init;

@end
