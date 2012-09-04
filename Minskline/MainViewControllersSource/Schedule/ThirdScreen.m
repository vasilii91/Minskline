//
//  ThirdScreen.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 02.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThirdScreen.h"

@implementation ThirdScreen

@synthesize tableViewStops, imageView, navBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.tableViewStops = nil;
    self.imageView = nil;
    self.navBar = nil;
    
    [stopsInRoute release];
    [stopsInRouteFull release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title= @"Остановки";
    UILabel *label = [PrettyViews labelToNavigationBarWithTitle:@"Остановки"];
    self.navigationItem.titleView = label;
    
    tableViewStops.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewStops.rowHeight = 60;
    tableViewStops.backgroundColor = [UIColor clearColor];
    
//    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)] autorelease];
//	UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 40)] autorelease];
//	headerLabel.text = NSLocalizedString(@"Выберите остановку", @"");
//	headerLabel.textColor = [UIColor orangeColor];
//	headerLabel.shadowColor = [UIColor blackColor];
//	headerLabel.shadowOffset = CGSizeMake(0, 1);
//	headerLabel.font = [UIFont boldSystemFontOfSize:26];
//	headerLabel.backgroundColor = [UIColor clearColor];
//	[containerView addSubview:headerLabel];
//    self.tableViewStops.tableHeaderView = containerView;
    
    [self reloadData];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Домой" style:UIBarButtonItemStyleBordered target:self action:@selector(goToHome:)];          
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton release];
}

-(void)goToHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// The number of sections is the same as the number of titles in the collation.
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// The number of stops in the section is the count of the array associated with the section in the sections array.
    
    return [stopsInRoute count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableViewStops dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier] autorelease];
		//
		// Create a background image view.
		//
		cell.backgroundView = [[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
	}
    
	UIImage *rowBackground = [UIImage imageNamed:@"stop_cell.png"];
    UIImage *selectionBackground = [UIImage imageNamed:@"stop_cell_selected.png"];
    
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
	
	//
	// Here I set an image based on the row. This is just to have something
	// colorful to show on each row.
	//

    cell.imageView.image = nil;
    
    UILabel *scrollingLabel = nil;
    int countOfScrollingLabel = 0;
    for (UIView *subview in [cell subviews]) {
        if ([subview isKindOfClass:[UILabel class]]) {
            countOfScrollingLabel++;
            scrollingLabel = (UILabel *)subview;
        }
    }
    if (countOfScrollingLabel == 0)
    {
        scrollingLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 8, 310, 40)];
        [scrollingLabel setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:scrollingLabel];
        [scrollingLabel release];
    }
    
    NSString *nameOfStop = [stopsInRoute objectAtIndex:indexPath.row];
    NSInteger fontSize = 0;
    if ([nameOfStop length] > 35) {
        fontSize = 10;
    }
    else if ([nameOfStop length] > 30) {
        fontSize = 11;
    }
    else if ([nameOfStop length] > 23) {
        fontSize = 13;
    }
    else {
        fontSize = 15;
    }
    
    if ([nameOfStop isEqualToString:@"Вост"])
        nameOfStop = @"Восток";
    scrollingLabel.text = nameOfStop;
    scrollingLabel.font = [UIFont systemFontOfSize:fontSize];
    scrollingLabel.textColor = TAB_BAR_TITLE_COLOR;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (UIView* subview in [tableView cellForRowAtIndexPath:indexPath].subviews) 
    {
        if ([subview isKindOfClass:[ScrollingLabel class]]) {
            [(ScrollingLabel *)subview startAnimate];
        }
    }
    [FullInfoAboutRoute sharedMySingleton]->currentStopFromThirdScreen = [stopsInRouteFull objectAtIndex:indexPath.row];
    [FullInfoAboutRoute sharedMySingleton]->isNeedUpdateFourthScreen = YES;
    
    FullInfoAboutRoute *fiar = [FullInfoAboutRoute sharedMySingleton];
    
    FourthScreen *fourthScreenViewController = [[FourthScreen alloc] init];
    fourthScreenViewController.typeOfTransport = fiar.typeOfTransport;
    fourthScreenViewController.numberOfTransport = fiar.numberOfTransport;
    fourthScreenViewController.currentStop = fiar->currentStopFromThirdScreen;
    fourthScreenViewController.currentRoute = fiar->currentRouteFromSecondScreen;
    
    [self.navigationController pushViewController:fourthScreenViewController animated:YES];
    [fourthScreenViewController release];
}

- (void)reloadData
{
    stopsInRoute = [[NSMutableArray alloc] init];
    
    AllRoutesAndStops *aRAS = [AllRoutesAndStops sharedMySingleton];
    FullInfoAboutRoute *fullInfoAboutRoute = [FullInfoAboutRoute sharedMySingleton];
    stopsInRouteFull = [[aRAS getAllStopsByRoute:fullInfoAboutRoute->currentRouteFromSecondScreen] retain];
    
    for (Stops *stop in stopsInRouteFull) {
        [stopsInRoute addObject:stop.StopName];
    }
    
    [tableViewStops reloadData];
}

@end
