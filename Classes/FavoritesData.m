//
//  FavoriteData.m
//  PROGETTO_LAP1
//
//  Created by Di Stefano Antonino - Gugliotta Alberto 02/02/2011.
//  Copyright 2010. All rights reserved.
//

#import "FavoritesData.h"
#import "Sms.h"
#import "Mail.h"
#import "Chiamata.h"
#import "SettingViewController.h"
#import "Info.h"
#import "SynthesizeSingleton.h"
#import "MapLocationViewController.h"

@interface FavoritesData (Private)

- (NSString *) docsDir;

@end

@implementation FavoritesData

NSString *const REFRESH_CRONOLOGIA = @"refreshCronologia";

SYNTHESIZE_SINGLETON_FOR_CLASS(FavoritesData);


#pragma mark CRONOLOGIA


- (void) loadCronologia{
	if(favoritesLoaded) return;
	NSString *dataFileName = @"cronologia.dat";
	_dataFilePath = [[[self docsDir] stringByAppendingPathComponent:dataFileName] retain];
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:_dataFilePath];
	if(success)	{
		NSMutableData *savedData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tmpFavArray;
		savedData = [NSData dataWithContentsOfFile:_dataFilePath];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:savedData];
		tmpFavArray = [decoder decodeObjectForKey:@"cronologia"];
		if(tmpFavArray) 
			_cronArray = [[NSMutableArray alloc] initWithArray:tmpFavArray];		
		else 
			_cronArray = [[NSMutableArray alloc] init];
		[decoder finishDecoding];
		[decoder release];
	}	
	else _cronArray = [[NSMutableArray alloc] init];
	favoritesLoaded = YES;
}


- (void) addCronologia:(Favorite *) fav{
	if(!favoritesLoaded)
		[self loadCronologia];
	
	if ([self controllaEsistenzaNome:fav.nome]){
		UIAlertView *tmp = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"attenzione", @"") message:NSLocalizedString(@"saveFavorites3", @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[tmp show];
		[tmp release];
	}
	else{
		[_cronArray addObject:fav];
		[self saveCronologia];
		[[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_CRONOLOGIA object:nil];
		UIAlertView *tmp = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"attenzione", @"") message:NSLocalizedString(@"saveFavorites", @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[tmp show];
		[tmp release];
		
	}	
}

- (BOOL) controllaEsistenzaNome:(NSString *) nome{	
	for (int i=0; i<_cronArray.count; i++){
		Favorite *f =[_cronArray objectAtIndex:i];
		if ([f.nome isEqualToString:nome]) 
			return TRUE;
	}
	return FALSE;	
}

- (NSMutableArray *) getCronologia{
	if(!favoritesLoaded) 
		[self loadCronologia];
	return _cronArray;
}

- (void) removeFavoriteById:(NSString *) favId
{
	for(int i = 0; i < _cronArray.count; i++){
		Favorite *fav = (Favorite *)[_cronArray objectAtIndex:i];
		if([fav.nome isEqualToString:favId])
			[_cronArray removeObjectAtIndex:i];
	}
	[self saveCronologia];
	[[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_CRONOLOGIA object:nil];
}

- (void) saveCronologia{
	NSMutableData *savedData;
	NSKeyedArchiver *encoder;
	savedData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:savedData];
	[encoder encodeObject:_cronArray forKey:@"cronologia"];
	[encoder finishEncoding];
	[savedData writeToFile:_dataFilePath atomically:YES];
	[encoder release];
}

//aggiorna i valori attuali in un oggetto Favorite
- (Favorite *) aggiornaValori: (MapViewAnnotation *)a name:(NSString *)n {
	Favorite *fav = [[Favorite alloc] init];
	fav.nome = n;
	fav.destS = [[Sms sharedSms] gettingDestSms];
	fav.destM = [[Mail sharedMail] gettingDestMail];
	fav.destC = [[Chiamata sharedChiamata] gettingDestChiamate];
	fav.testoS = [[Sms sharedSms] gettingTestoSms];
	fav.oggettoM = [[Mail sharedMail] gettingOggettoMail];
	fav.testoM = [[Mail sharedMail] gettingTestoMail];
	
	NSString *se = [NSString stringWithFormat:@"%i", [[SettingViewController sharedSettingViewController] gettingSegControl]];
	fav.miAvvMiAll = [NSString stringWithString:se];
	
	NSString *sl = [NSString stringWithFormat:@"%f", [[SettingViewController sharedSettingViewController] gettingSlider]];
	fav.sliderValue = [NSString stringWithString:sl];
	
	NSString *la = [NSString stringWithFormat:@"%f", a.coordinate.latitude];
	fav.latit = [NSString stringWithString:la];
	
	NSString * lo = [NSString stringWithFormat:@"%f", a.coordinate.longitude];
	fav.longit = [NSString stringWithString:lo];
	
	if ([[Mail sharedMail] gettingOnMail])
		fav.onM = @"TRUE";
	else 
		fav.onM = @"FALSE";
	
	if ([[Sms sharedSms] gettingOnSms])
		fav.onS = @"TRUE";
	else 
		fav.onS = @"FALSE";
	
	if ([[Chiamata sharedChiamata] gettingOnChiamate])
		fav.onC = @"TRUE";
	else 
		fav.onC = @"FALSE";
	
	return fav;
}

//carica l'oggetto Favorite selezionato e imposta l'app
- (Favorite *) caricaCronologia: (Favorite *)fav{
	[[Sms sharedSms] settingDestSms:fav.destS];
	[[Mail sharedMail] settingDestMail:fav.destM];
	[[Chiamata sharedChiamata] settingDestChiamate:fav.destC];
	[[Sms sharedSms] settingTestoSms:fav.testoS];
	[[Mail sharedMail] settingOggettoMail:fav.oggettoM];
	[[Mail sharedMail] settingTestoMail:fav.testoM];	
	float sli = [fav.sliderValue floatValue];
	[[SettingViewController sharedSettingViewController] settingSlider:sli];
	int AvvAll = [fav.miAvvMiAll intValue];
	[[SettingViewController sharedSettingViewController] settingSegControl:AvvAll];
	double lon = [fav.longit doubleValue];
	double lat = [fav.latit doubleValue];
	MapViewAnnotation *a = [[[MapViewAnnotation alloc] initWithCoordinate:lon latitude:lat] autorelease];
	[[MapLocationViewController sharedMapLocationViewController] caricaAnnotation:a];
	if ([fav.onS isEqualToString:@"TRUE"]) 
		[[Sms sharedSms] settingOnSms:TRUE];
	else
		[[Sms sharedSms] settingOnSms:FALSE];
	if ([fav.onM isEqualToString:@"TRUE"]) 
		[[Mail sharedMail] settingOnMail:TRUE];
	else
		[[Mail sharedMail] settingOnMail:FALSE];
	if ([fav.onC isEqualToString:@"TRUE"]) 
		[[Chiamata sharedChiamata] settingOnChiamate:TRUE];
	else
		[[Chiamata sharedChiamata] settingOnChiamate:FALSE];
	
	[self controllaNotifiche];
		
	return fav;
}

- (void) controllaNotifiche{
	if ([[Sms sharedSms] gettingOnSms]) {
		[[Mail sharedMail] settingOnMail:FALSE];
		[[Chiamata sharedChiamata] settingOnChiamate:FALSE];
	}
	else if ([[Chiamata sharedChiamata] gettingOnChiamate]){
		[[Mail sharedMail] settingOnMail:FALSE];
		[[Sms sharedSms] settingOnSms:FALSE];
	}
	else if ([[Mail sharedMail] gettingOnMail]) {
		[[Sms sharedSms] settingOnSms:FALSE];
		[[Chiamata sharedChiamata] settingOnChiamate:FALSE];
	}
}


- (NSString *) docsDir{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}

@end
