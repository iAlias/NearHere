//
//  Info.m
//  Progetto LAP1
//
//  Created by distegu on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Info.h"
#import "FavoritesData.h"

@implementation Info

@synthesize tabella, cronologia;


- (void)viewDidLoad{
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_refreshCrono) name:REFRESH_CRONOLOGIA object:nil];  
	[self aggiornaTabella];
}

-(void) aggiornaTabella{
	NSMutableArray *tmp = [[FavoritesData sharedFavoritesData] getCronologia];
	cronologia = [[NSMutableArray alloc] initWithArray:tmp];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_refreshCrono) name:REFRESH_CRONOLOGIA object:nil];
}


- (void) _refreshCrono{
	[self.tabella reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Setta il numero di righe della tabella .
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cronologia count];
}


// Setta il contenuto delle varie celle
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	static NSString *cellIndentifier = @"Cell";
	
	UITableViewCell *cell = [tabella dequeueReusableCellWithIdentifier:cellIndentifier]; 
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIndentifier] autorelease];
		//setta lo stile con cui vengono selezionate le righe
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	//inseriamo nella cella l'elemento della lista corrispondente
	Favorite *fav = (Favorite *)[cronologia objectAtIndex:indexPath.row];
	cell.textLabel.text = fav.nome;
	return cell;
}

 // Override to support row selection in the table view.
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{ 
	[[self view] removeFromSuperview];
 	Favorite *fav = (Favorite *)[cronologia objectAtIndex:indexPath.row];
	[[FavoritesData sharedFavoritesData] caricaCronologia:fav];
 }

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { 
	//controlla se l'azione compiuta è un'eliminazione
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		Favorite *fav = (Favorite *)[[[FavoritesData sharedFavoritesData] getCronologia] objectAtIndex:indexPath.row];
		if(fav){
			[tabella beginUpdates];
			[self.tabella deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[[FavoritesData sharedFavoritesData] removeFavoriteById:fav.nome];
			[self aggiornaTabella];
			[tabella endUpdates];
		}
	}
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

// CellHeight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
	[[FavoritesData sharedFavoritesData] saveCronologia];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (void) dealloc{	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[tabella release];
	[cronologia release];
	[super dealloc];
}

@end
