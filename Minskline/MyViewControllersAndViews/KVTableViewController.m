//
//  FifthScreen.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 04.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KVTableViewController.h"

@implementation KVTableViewController
@synthesize tableViewResult, numberOfTransport, textOfCell, imageView, sBar;
@synthesize indicatorView, imageViewIndicator;
@synthesize doneInvisibleButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // Disregard parameters - nib name is an implementation detail
    return [self init];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)createListOfFavoriteStops
{
    [favoriveStops removeAllObjects];
    [favoriveStops addObjectsFromArray: [[[allRoutesAndStops getFavoriteStopsFromDatabase] retain] autorelease]];
    
    
    if (settings.isFavorite) {
        isFavorites = YES;
    }
    else {
        isFavorites = NO;
    }
    
    if (isFavorites) {
        for (Stops *stop in favoriveStops) {
            if (![currentListOfStops containsObject:stop.StopName]) {
                [currentListOfStops addObject:stop.StopName];
            }
        }
    }
}

- (void)createListsOfStops
{
    [listOfStops removeAllObjects];
    [listOfStops addObjectsFromArray:[allRoutesAndStops getAllStopsFromDatabase]];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    dispatch_async(queue, ^{

        if (settings.isFavorite) {
            isFavorites = YES;
        }
        else {
            isFavorites = NO;
        }

        // пока еще в listOfStops лежат все остановки, забираем их и ложим в globalListOfStops
        currentListOfStops = [[NSMutableArray alloc] init];
        globalListOfStops = [[NSMutableArray alloc] init];
        
        for (Stops *stop in listOfStops) {
            if (![globalListOfStops containsObject:stop.StopName]) {
                [globalListOfStops addObject:stop.StopName];
            }
        }
        
        if (!isFavorites) {
            for (Stops *stop in listOfStops) {
                if (![currentListOfStops containsObject:stop.StopName]) {
                    [currentListOfStops addObject:stop.StopName];
                }
            }
        }
    });
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [indicatorView setFrame:CGRectMake(110, 190, 100, 100)];
//    [indicatorView startAnimating];
//    
//    imageViewIndicator = [[UIImageView alloc] initWithImage:nil];
//    [imageViewIndicator setFrame:CGRectMake(0, 0, 320, 480)];
//    [imageViewIndicator addSubview:indicatorView];
//    
//    [self.tableViewResult setUserInteractionEnabled:NO];
//    [self.view addSubview:imageViewIndicator];
    
    settings = [SettingsOfMinsktrans sharedMySingleton];
    allRoutesAndStops = [AllRoutesAndStops sharedMySingleton];
    
    listOfStops = [[NSMutableArray alloc] init];
    favoriveStops = [[NSMutableArray alloc] init];
    copyCurrentListOfStops = [[NSMutableArray alloc] init];
    dictionaryListOfStopsByLetter = [[NSMutableDictionary alloc] init];
    
    russianLettersAndNumbers = [NSArray arrayWithObjects: @"А", @"Б", @"В", @"Г", @"Д", @"Е", @"Ж", @"З", @"И", @"К", @"Л", @"М", @"Н", @"О", @"П", @"Р", @"С", @"Т", @"У", @"Ф", @"Х", @"Ц", @"Ч", @"Ш", @"Щ", @"Э", @"Ю", @"Я", nil];
    for (NSString *letter in russianLettersAndNumbers) {
        NSArray *stops = [allRoutesAndStops getAllStopsByPatternOrByFirstLetter:YES patternOfFirstLetter:letter];
        [dictionaryListOfStopsByLetter setValue:stops forKey:letter];
    }

    [self createListsOfStops];
    [self createListOfFavoriteStops];
    
    sBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searching = NO;
    letUserSelectRow = YES;
    
    tableViewResult.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewResult.rowHeight = 60;
    tableViewResult.backgroundColor = [UIColor clearColor];
    
    [tableViewResult reloadData];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (settings.isNeedUpdate1 || 
        settings.isNeedUpdate2 ||
        settings.isNeedUpdate3 ||
        settings.isChangedFromOneToAnother1 || 
        settings.isChangedFromOneToAnother2 ||
        settings.isChangedFromOneToAnother3) {
        
        [self createListOfFavoriteStops];
        
        [tableViewResult reloadData];
    }
    if (isFavorites) {
        searching = NO;
        [self createListOfFavoriteStops];
        [tableViewResult reloadData];
    }
    sBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searching = NO;
    letUserSelectRow = YES;
    sBar.text = @"";
    [tableViewResult reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (id)init
{
    // Call the superclass's designated initializer
    return self = [super initWithNibName:nil bundle:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// The number of sections is the same as the number of titles in the collation.
    //    return [[collation sectionTitles] count];
    if (searching || isFavorites)
        return 1;
    else
        return [russianLettersAndNumbers count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// The number of stops in the section is the count of the array associated with the section in the sections array.
    //	NSArray *stopsInSection = [sectionsArray objectAtIndex:section];
    //	
    //    return [stopsInSection count];
    if (searching) {
        return [copyCurrentListOfStops count];
    }
    else if (isFavorites) {
        return [favoriveStops count];
    }
    else {
        NSString *letterOrNumber = [russianLettersAndNumbers objectAtIndex:section];
        return [[dictionaryListOfStopsByLetter valueForKey:letterOrNumber] count];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    KVTableViewCellKVTableViewController *cell = [tableViewResult dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[KVTableViewCellKVTableViewController alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier] autorelease];
	}
    cell.delegate = self;
    
//    BOOL isFavorite = [cell.stopFromCell.isSelected intValue] == 0 ? NO : YES;
    BOOL isFavorite = NO;
    
    NSString *tempCell = @"";
    if (searching) {
        tempCell = [copyCurrentListOfStops objectAtIndex:indexPath.row];
        cell.centerLabel.text = tempCell;
        for (Stops *stop in favoriveStops) {
            if ([stop.StopName isEqualToString:tempCell]) {
                isFavorite = YES;
                break;
            }
        }
    }
    else if (isFavorites) {
        tempCell = ((Stops *)[favoriveStops objectAtIndex:indexPath.row]).StopName;
        cell.centerLabel.text = tempCell;
        isFavorite = YES;
    }
    else {
        NSString *letterOrNumber = [russianLettersAndNumbers objectAtIndex:indexPath.section];
        NSMutableArray * stops = [dictionaryListOfStopsByLetter valueForKey:letterOrNumber];
        tempCell = [stops objectAtIndex:indexPath.row];
        cell.centerLabel.text = [stops objectAtIndex:indexPath.row];
        for (Stops *stop in favoriveStops) {
            if ([stop.StopName isEqualToString:tempCell]) {
                isFavorite = YES;
                break;
            }
        }
    }
    UIImage *imageFavorite = (isFavorite == YES) ? [UIImage imageNamed:IMAGE_FAVORITE_SELECTED] : [UIImage imageNamed:IMAGE_FAVORITE_NON_SELECTED];
    cell->isFavorite = isFavorite;
    cell.indexPath = indexPath;
    [cell.buttonFavorite setBackgroundImage:imageFavorite forState:UIControlStateNormal];
    
    cell.nameOfStop = tempCell;
    NSInteger fontSize = 0;
    if ([tempCell length] > 35) {
        fontSize = 10;
    }
    else if ([tempCell length] > 30) {
        fontSize = 11;
    }
    else if ([tempCell length] > 23) {
        fontSize = 13;
    }
    else {
        fontSize = 15;
    }
    cell.centerLabel.font = [UIFont systemFontOfSize:fontSize];
    
    return cell;
}

/*
 Section-related methods: Retrieve the section titles and section index titles from the collation.
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (isFavorites) {
        return @"Избранные";
    }
    else if (searching || [copyCurrentListOfStops count] < [currentListOfStops count]) {
        return @"Найденные остановки";
    }
    else {
        return [russianLettersAndNumbers objectAtIndex:section];
    }
}

- (NSArray *) sectionIndexTitlesForTableView: (UITableView *) tableView {
    return russianLettersAndNumbers;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self doneSearchingClicked];
    
    KVTableViewCellKVTableViewController *cell = (KVTableViewCellKVTableViewController *)[tableView cellForRowAtIndexPath:indexPath];
    textOfCell = [NSString stringWithFormat:@"%@", cell.centerLabel.text];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(5, 0, tableView.bounds.size.width - 10, 30)] autorelease];
    [headerView setBackgroundColor:[UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:0.8]];

    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)] autorelease];
    if (isFavorites) {
        label.text = @"Избранные";
    }
    else if (searching) {
        label.text = @"Найденные остановки";
    }
    else {
        label.text = [russianLettersAndNumbers objectAtIndex:section];
    }
    label.textColor = [UIColor colorWithRed:1.0 green:0.73 blue:0.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow) {
        searching = NO;
		return indexPath;
    }
	else
		return nil;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark -
#pragma mark Search Bar 

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	searching = NO;
	letUserSelectRow = NO;
	self.tableViewResult.scrollEnabled = NO;

    UIImage *image = [UIImage imageNamed:@"button_ok.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, 45, 35 );    
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doneSearchingClicked) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
	//Add the done button.
//    navBar.topItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	//Remove all objects first.
	[copyCurrentListOfStops removeAllObjects];
	
	if([searchText length] > 0) {
		
		searching = YES;
		letUserSelectRow = YES;
		self.tableViewResult.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		searching = NO;
		letUserSelectRow = NO;
		self.tableViewResult.scrollEnabled = NO;
	}
	
	[self.tableViewResult reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self searchTableView];
}

- (void) searchTableView {
	
	NSString *searchText = sBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	
	for (NSString *sTemp in globalListOfStops)
	{
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0)
			[copyCurrentListOfStops addObject:sTemp];
	}
	
	[searchArray release];
	searchArray = nil;
}

- (void) doneSearchingClicked {
	
	  [sBar resignFirstResponder];
	
	letUserSelectRow = YES;
//	searching = NO;
	self.tableViewResult.scrollEnabled = YES;
    
    self.navigationItem.rightBarButtonItem = nil;
}


#pragma mark - @protocol KVTableViewCellKVTableViewControllerDelegate <NSObject>

- (void)userClickedOnFavoriteButton:(id)sender
{
    KVTableViewCellKVTableViewController *cell = (KVTableViewCellKVTableViewController *)sender;
    
    NSString *nameOfStop = cell.nameOfStop;
    
    BOOL isFavoriteCell = cell->isFavorite;
    UIImage *imageFavoriteOn = [UIImage imageNamed:IMAGE_FAVORITE_SELECTED];
    UIImage *imageFavoriteOff = [UIImage imageNamed:IMAGE_FAVORITE_NON_SELECTED];
    UIImage *imageToCell = (isFavoriteCell == YES) ? imageFavoriteOff : imageFavoriteOn;
    [cell.buttonFavorite setBackgroundImage:imageToCell forState:UIControlStateNormal];
    
    isFavoriteCell = !isFavoriteCell;
    
    AllRoutesAndStops *aRAS = [AllRoutesAndStops sharedMySingleton];
    if (isFavoriteCell) {
        [aRAS addToFavoriteStop:nameOfStop];
    }
    else {
        [aRAS removeFromFavoriteStop:nameOfStop];
    }
    cell->isFavorite = isFavoriteCell;
    
    
    [self createListOfFavoriteStops];
    
    [tableViewResult reloadData];
    
    settings.isNeedUpdate1 = YES;
    settings.isNeedUpdate2 = YES;
    settings.isNeedUpdate3 = YES;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [copyCurrentListOfStops release];
    [currentListOfStops release];
    
    self.tableViewResult = nil;
    self.imageView = nil;
    self.sBar = nil;
//    self.textOfCell = nil;

    [super dealloc];
}


@end
