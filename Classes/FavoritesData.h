//
//  FavoriteData.h
//  PROGETTO_LAP1
//
//  Created by Di Stefano Antonino - Gugliotta Alberto 02/02/2011.
//  Copyright 2010. All rights reserved.
//

#import "Favorite.h"
#import "MapViewAnnotation.h"

@interface FavoritesData : NSObject{

	NSMutableArray *_cronArray;
	NSString *_dataFilePath;
	BOOL favoritesLoaded;

}

extern NSString *const REFRESH_CRONOLOGIA;

- (void) addCronologia:(Favorite *) fav;
- (NSMutableArray *) getCronologia;
- (void) removeFavoriteById:(NSString *) favId;
- (void) saveCronologia;
- (void) loadCronologia;
- (Favorite *)caricaCronologia: (Favorite *)fav;
- (Favorite *) aggiornaValori: (MapViewAnnotation *)a name: (NSString *)n;
- (void) controllaNotifiche;
- (BOOL) controllaEsistenzaNome:(NSString *)nome;

+ (FavoritesData *) sharedFavoritesData;

@end
