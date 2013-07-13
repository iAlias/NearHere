//
//  Favorite.m
//  PROGETTO_LAP1
//
//  Created by Di Stefano Antonino - Gugliotta Alberto 02/02/2011.
//  Copyright 2010. All rights reserved.
//


#import "Favorite.h"


@implementation Favorite


@synthesize destS, destM, destC, testoS, oggettoM, testoM, nome, latit, longit, sliderValue, miAvvMiAll, onS, onM, onC;

-(id) init{
	if(self = [super init]) {
		
	}
	return self;
}

- (id) initWithCoder:(NSCoder *) encoder{
	nome = [[encoder decodeObjectForKey:@"nome"] retain];
	destS = [[encoder decodeObjectForKey:@"destS"] retain];
	destM = [[encoder decodeObjectForKey:@"destM"] retain];
	destC = [[encoder decodeObjectForKey:@"destC"] retain];
	testoS = [[encoder decodeObjectForKey:@"testoS"] retain];
	oggettoM = [[encoder decodeObjectForKey:@"oggettoM"] retain];
	testoM = [[encoder decodeObjectForKey:@"testoM"] retain];
	latit = [[encoder decodeObjectForKey:@"latit"] retain];
	longit = [[encoder decodeObjectForKey:@"longit"] retain];
	sliderValue = [[encoder decodeObjectForKey:@"sliderValue"] retain];
	miAvvMiAll = [[encoder decodeObjectForKey:@"miAvvMiAll"] retain];
	onS = [[encoder decodeObjectForKey:@"onS"] retain];
	onM = [[encoder decodeObjectForKey:@"onM"] retain];
	onC = [[encoder decodeObjectForKey:@"onC"] retain];

	
	return self;
}

- (void) encodeWithCoder:(NSCoder *) encoder{
	[encoder encodeObject:nome forKey:@"nome"];
	[encoder encodeObject:destS forKey:@"destS"];
	[encoder encodeObject:destM forKey:@"destM"];
	[encoder encodeObject:destC forKey:@"destC"];
	[encoder encodeObject:testoS forKey:@"testoS"];
	[encoder encodeObject:oggettoM forKey:@"oggettoM"];
	[encoder encodeObject:testoM forKey:@"testoM"];
	[encoder encodeObject:latit	forKey:@"latit"];
	[encoder encodeObject:longit forKey:@"longit"];
	[encoder encodeObject:sliderValue forKey:@"sliderValue"];
	[encoder encodeObject:miAvvMiAll forKey:@"miAvvMiAll"];
	[encoder encodeObject:onS forKey:@"onS"];
	[encoder encodeObject:onM forKey:@"onM"];
	[encoder encodeObject:onC forKey:@"onC"];	
}


- (void) dealloc{
	[super dealloc];
}

@end
