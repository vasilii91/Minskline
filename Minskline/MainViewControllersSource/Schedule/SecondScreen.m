//
//  SecondScreen.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 02.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondScreen.h"

#define USE_CUSTOM_DRAWING 1

static NSInteger imageHeight = 100;
static NSInteger imageWidth = 77;

@interface SecondScreen (Private) 
-(void)setImageToCell:(KVTableViewCellSecondScreen *)cell typeOfTransport:(TypeOfTransportEnum)type;
-(TypeOfTransportEnum)getTypeOfTransportByString:(NSString *)stringFromFavorite;
@end

@implementation SecondScreen

@synthesize tableViewRoutes, imageView, navBar;

- (void)dealloc
{
    self.tableViewRoutes = nil;
    self.imageView = nil;
    self.navBar = nil;
    
    [differentRoutes release];
    [differentRoutesFull release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadData:NO];
    
    self.navigationItem.title= @"Маршруты";
    UILabel *label = [PrettyViews labelToNavigationBarWithTitle:@"Маршруты"];
    self.navigationItem.titleView = label;
    
    tableViewRoutes.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewRoutes.backgroundColor = [UIColor clearColor];
    
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 10)] autorelease];
    UIView *containerView2 = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)] autorelease];
	UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 40)] autorelease];
    
//	headerLabel.text = NSLocalizedString(@"Выберите маршрут", @"");
	headerLabel.textColor = [UIColor orangeColor];
	headerLabel.shadowColor = [UIColor blackColor];
	headerLabel.shadowOffset = CGSizeMake(0, 1);
	headerLabel.font = [UIFont boldSystemFontOfSize:26];
	headerLabel.backgroundColor = [UIColor clearColor];
    self.tableViewRoutes.tableHeaderView = containerView;
    self.tableViewRoutes.tableFooterView = containerView2;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Домой" style:UIBarButtonItemStyleBordered target:self action:@selector(goToHome:)];          
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton release];
}

-(void)goToHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return countOfItemsInTable;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    KVTableViewCellSecondScreen *cell = [tableViewRoutes dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Create the cell
        cell = [[[KVTableViewCellSecondScreen alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier] autorelease];
//        [cell.buttonFavorite addTarget:self action:@selector(buttonClickOnIsFavorite:) forControlEvents:UIControlEventTouchUpInside];
	}
    cell.delegate = self;
    
    Routes *route = ((Routes *)[differentRoutesFull objectAtIndex:indexPath.row]);
    NSNumber *numberIsFavorite = route.isSelected;
    BOOL isFavorite = (numberIsFavorite == nil || [numberIsFavorite intValue] == 0) ? NO : YES;
    
    UIImage *imageFavorite = (isFavorite == YES) ? [UIImage imageNamed:IMAGE_FAVORITE_SELECTED] : [UIImage imageNamed:IMAGE_FAVORITE_NON_SELECTED];
    
    cell->isFavorite = isFavorite;
    [cell.buttonFavorite setBackgroundImage:imageFavorite forState:UIControlStateNormal];
	 
    NSString *transportNumber = 
        ((Routes *)[differentRoutesFull objectAtIndex:indexPath.row]).TransportNumber;
    
	cell.bottomLabel.text = [NSString stringWithFormat:@"%@ маршрут", transportNumber];
    cell.routeToCell = ((Routes *)[differentRoutesFull objectAtIndex:indexPath.row]);
    cell.indexPath = indexPath;
	
	//
	// Here I set an image based on the row. This is just to have something
	// colorful to show on each row.
	//
    TypeOfTransportEnum typeOfTransport = [FullInfoAboutRoute sharedMySingleton].typeOfTransport;
    switch (typeOfTransport) {
        case BUS:
        case TROLLEYBUS:
        case TRAMWAY:
        case METRO:
            [self setImageToCell:cell typeOfTransport:typeOfTransport];
            break;
        case FAVORITIES: 
        {
            TypeOfTransportEnum typeOfTransportLocal = 
            [((Routes *)[differentRoutesFull objectAtIndex:indexPath.row]).TypeOfTransport intValue];
            [self setImageToCell:cell typeOfTransport:typeOfTransportLocal];
            break;
        }
        default:
            break;
    }
    
    Routes *currentRoute = (Routes *)[differentRoutesFull objectAtIndex:indexPath.row];
    
    NSString *startName = currentRoute.StartName;
    NSString *endName = currentRoute.EndName;
    
    if ([transportNumber isEqualToString:@"M1"] || [transportNumber isEqualToString:@"M2"]) {
        AllRoutesAndStops *aRAS = [AllRoutesAndStops sharedMySingleton];
        NSMutableArray *stopsInRouteFull = [[aRAS getAllStopsByRoute:currentRoute] retain];
        startName = ((Stops *)[stopsInRouteFull objectAtIndex:0]).StopName;
        endName = ((Stops *)[stopsInRouteFull lastObject]).StopName;
        [stopsInRouteFull release];
    }
    
    cell.topLabel.text = startName;
    cell.overBottomLabel.text = endName;
    
    NSInteger fontSize = 0;
    if ([endName length] > 35) {
        fontSize = 11;
    }
    else if ([endName length] > 26) {
        fontSize = 12;
    }
    else if ([endName length] > 20) {
        fontSize = 15;
    }
    else {
        fontSize = 18;
    }
    
    cell.overBottomLabel.font = [UIFont systemFontOfSize:fontSize];
    
    if(indexPath.row == 0) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

-(void)setImageToCell:(KVTableViewCellSecondScreen *)cell typeOfTransport:(TypeOfTransportEnum)type
{
    switch (type) {
        case BUS:
            cell.imageView.image = [[UIImage imageNamed:@"autobus_route.png"] imageScaledToSize:CGSizeMake(imageWidth, imageHeight)];
            break;
        case TROLLEYBUS:
            cell.imageView.image = [[UIImage imageNamed:@"trolleybus_route.png"] imageScaledToSize:CGSizeMake(imageWidth, imageHeight)];
            break;
        case TRAMWAY:
            cell.imageView.image = [[UIImage imageNamed:@"tramway_route.png"] imageScaledToSize:CGSizeMake(imageWidth, imageHeight)];
            break;
        case METRO:
            cell.imageView.image = [[UIImage imageNamed:@"metro_route.png"] imageScaledToSize:CGSizeMake(imageWidth, imageHeight)];
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (UIView* subview in [tableView cellForRowAtIndexPath:indexPath].subviews) 
    {
        if ([subview isKindOfClass:[ScrollingLabel class]]) {
            [(ScrollingLabel *)subview startAnimate];
        }
    }
    [FullInfoAboutRoute sharedMySingleton]->isNeedUpdateThirdScreen = YES;
    [FullInfoAboutRoute sharedMySingleton]->currentRouteFromSecondScreen = [differentRoutesFull objectAtIndex:indexPath.row];
    
    ThirdScreen *thirdScreenViewController = [[ThirdScreen alloc] init];
    [self.navigationController pushViewController:thirdScreenViewController animated:YES];
    [thirdScreenViewController release];
    
    NSString *transportNumber = 
    ((Routes *)[differentRoutesFull objectAtIndex:indexPath.row]).TransportNumber;
    
    [FullInfoAboutRoute sharedMySingleton].numberOfTransport = transportNumber;
}

-(void)buttonClickOnIsFavorite:(id)sender
{
    KVTableViewCellSecondScreen *cell = (KVTableViewCellSecondScreen *)[sender superview];
    
    Routes *routeFromCell = cell.routeToCell;
    
    BOOL isFavoriteCell = cell->isFavorite;
    UIImage *imageFavoriteOn = [UIImage imageNamed:IMAGE_FAVORITE_SELECTED];
    UIImage *imageFavoriteOff = [UIImage imageNamed:IMAGE_FAVORITE_NON_SELECTED];
    UIImage *imageToCell = (isFavoriteCell == YES) ? imageFavoriteOff : imageFavoriteOn;
    [cell.buttonFavorite setBackgroundImage:imageToCell forState:UIControlStateNormal];
    isFavoriteCell = !isFavoriteCell;
    routeFromCell.isSelected = [NSNumber numberWithInt:isFavoriteCell];
    
    AllRoutesAndStops *aRAS = [AllRoutesAndStops sharedMySingleton];
    [aRAS setIsFavorite:routeFromCell];
//    routeFromCell.isSelected = [NSNumber numberWithInt: cell->isFavorite];
    cell->isFavorite = isFavoriteCell;
    
    TypeOfTransportEnum typeOfTransport = [FullInfoAboutRoute sharedMySingleton].typeOfTransport;
    if (typeOfTransport == FAVORITIES) {
        countOfItemsInTable--;
        NSIndexPath *indexPath = cell.indexPath;
        [tableViewRoutes beginUpdates];
        [tableViewRoutes deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [tableViewRoutes endUpdates];
        [self reloadData:NO];
    }
}

- (void)reloadData:(BOOL)isDeleteCell
{
    differentRoutes = [[NSMutableArray alloc] init];
    
    AllRoutesAndStops *aRAS = [AllRoutesAndStops sharedMySingleton];
    FullInfoAboutRoute *fullInfoAboutRoute = [FullInfoAboutRoute sharedMySingleton];
    TypeOfTransportEnum typeOfTransport = fullInfoAboutRoute.typeOfTransport;
    if (typeOfTransport == FAVORITIES) {
        NSString *numberOfTransport = fullInfoAboutRoute.numberOfTransport;
        typeOfTransport = [self getTypeOfTransportByString:numberOfTransport];
        differentRoutesFull = [[aRAS getAllFavoritiesRoutes: typeOfTransport] retain];
    }
    else {
        differentRoutesFull = [[aRAS getAllRoutesByTypeAndNumberOfTransport:typeOfTransport andNumber:fullInfoAboutRoute.numberOfTransport] retain];
    }
    
    for (Routes *route in differentRoutesFull) {
        [differentRoutes addObject:route.RouteName];
    }
    countOfItemsInTable = [differentRoutesFull count];
    
    [UIView beginAnimations:@"when deleting" context:nil];
    [UIView setAnimationDuration:15.0];
    [UIView setAnimationDelay:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    if (!isDeleteCell) {
        [tableViewRoutes reloadData];
    }
}

-(TypeOfTransportEnum)getTypeOfTransportByString:(NSString *)stringFromFavorite
{
    if ([stringFromFavorite isEqualToString:@"Автобусы"]) {
        return BUS;
    }
    else if ([stringFromFavorite isEqualToString:@"Троллейбусы"]) {
        return TROLLEYBUS;
    }
    else if ([stringFromFavorite isEqualToString:@"Трамваи"]) {
        return TRAMWAY;
    }
    else if ([stringFromFavorite isEqualToString:@"Метро"]) {
        return METRO;
    }
    return FAVORITIES;
}


#pragma mark - @protocol KVTableViewCellSecondScreenDelegate <NSObject>

- (void)userClickedOnFavoriteButton:(id)sender
{
    KVTableViewCellSecondScreen *cell = (KVTableViewCellSecondScreen *)sender;
    
    Routes *routeFromCell = cell.routeToCell;
    
    BOOL isFavoriteCell = cell->isFavorite;
    UIImage *imageFavoriteOn = [UIImage imageNamed:IMAGE_FAVORITE_SELECTED];
    UIImage *imageFavoriteOff = [UIImage imageNamed:IMAGE_FAVORITE_NON_SELECTED];
    UIImage *imageToCell = (isFavoriteCell == YES) ? imageFavoriteOff : imageFavoriteOn;
    [cell.buttonFavorite setBackgroundImage:imageToCell forState:UIControlStateNormal];
    isFavoriteCell = !isFavoriteCell;
    routeFromCell.isSelected = [NSNumber numberWithInt:isFavoriteCell];
    
    AllRoutesAndStops *aRAS = [AllRoutesAndStops sharedMySingleton];
    [aRAS setIsFavorite:routeFromCell];
    //    routeFromCell.isSelected = [NSNumber numberWithInt: cell->isFavorite];
    cell->isFavorite = isFavoriteCell;
    
    TypeOfTransportEnum typeOfTransport = [FullInfoAboutRoute sharedMySingleton].typeOfTransport;
    if (typeOfTransport == FAVORITIES) {
        countOfItemsInTable--;
        NSIndexPath *indexPath = cell.indexPath;
        [tableViewRoutes beginUpdates];
        [tableViewRoutes deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [tableViewRoutes endUpdates];
        [self reloadData:NO];
    }
}

@end
