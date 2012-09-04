//
//  DirectionsScreen.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 11.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DirectionsScreen.h"

#define USE_CUSTOM_DRAWING 1

#define imageHeight 100
#define imageWidth 77

@interface DirectionsScreen (Private) 

@end

@implementation DirectionsScreen

@synthesize tableViewRoutes, imageView, navBar;

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
    self.tableViewRoutes = nil;
    self.imageView = nil;
    self.navBar = nil;
    
    [possibleRoutes release];
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
    // Do any additional setup after loading the view from its nib.
    
    [self reloadData:NO];
    
    UILabel *label = [PrettyViews labelToNavigationBarWithTitle:@"Направления"];
    self.navigationItem.title = @"Направления";
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
    //	[containerView addSubview:headerLabel];
    self.tableViewRoutes.tableHeaderView = containerView;
    self.tableViewRoutes.tableFooterView = containerView2;
    
    //    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    //    [tableViewRoutes selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
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
    return 174.0f;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// The number of sections is the same as the number of titles in the collation.
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// The number of stops in the section is the count of the array associated with the section in the sections array.
    
    return countOfItemsInTable;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    KVTableViewCellRoutes *cell = [tableViewRoutes dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Create the cell
        cell = [[[KVTableViewCellRoutes cell] retain] autorelease];
        //
        // Create a background image view.
        //
        cell.backgroundView = [[[UIImageView alloc] init] autorelease];
        cell.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
	}
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImage *rowBackground = [UIImage imageNamed:@"directions_cell.png"];
    UIImage *selectionBackground = [UIImage imageNamed:@"directions_cell.png"];
    
    ((UIImageView *)cell.backgroundView).image = rowBackground;
    ((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
    
    NSMutableArray *routesOnStop = [[possibleRoutes allValues] objectAtIndex:indexPath.row];
    
    NSMutableSet *allUniqueEndStops = [[NSMutableSet alloc] init];

    NSMutableString *allRoutes = [NSMutableString new];
    NSMutableString *allNumbers = [NSMutableString new];
    
    NSMutableSet *allUniqueBusNumbers = [NSMutableSet new];
    NSMutableSet *allUniqueMetroNumbers = [NSMutableSet new];
    NSMutableSet *allUniqueTrolleybusNumbers = [NSMutableSet new];
    NSMutableSet *allUniqueTramwayNumbers = [NSMutableSet new];
    
    for (Route *route in routesOnStop) {
        [allUniqueEndStops addObject:route.nameOfEndStop];
        NSString *routeNumber = route.routeNumber;
        
        switch (route.typeOfTransport) {
            case BUS:
                [allUniqueBusNumbers addObject:routeNumber];
                break;
            case TROLLEYBUS:
                [allUniqueTrolleybusNumbers addObject:routeNumber];
                break;
            case TRAMWAY:
                [allUniqueTramwayNumbers addObject:routeNumber];
                break;
            case METRO:
                [allUniqueMetroNumbers addObject:routeNumber];
                break;
            default:
                break;
        }
    }
    
    NSComparisonResult (^sortBlock)(id, id) = ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) { 
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return [obj1 compare:obj2];
    };
    
    NSArray *allBuses = [[allUniqueBusNumbers allObjects] sortedArrayUsingComparator:sortBlock];
    NSArray *allTrolleybuses = [[allUniqueTrolleybusNumbers allObjects] sortedArrayUsingComparator:sortBlock];
    NSArray *allTramways = [[allUniqueTramwayNumbers allObjects] sortedArrayUsingComparator:sortBlock];
    NSArray *allMetros = [[allUniqueMetroNumbers allObjects] sortedArrayUsingComparator:sortBlock];
    
    for (NSString *nameOfEndStop in allUniqueEndStops) {
        [allRoutes appendFormat:@"%@; ", nameOfEndStop];
    }
    
    if ([allBuses count] > 0)
        [allNumbers appendString:@"Автобусы: "];
    for (NSString *numberOfRoute in allBuses) {
        [allNumbers appendFormat:@"%@; ", numberOfRoute];
    }
    
    if ([allTrolleybuses count] > 0)
        [allNumbers appendString:@"\nТроллейбусы: "];
    for (NSString *numberOfRoute in allTrolleybuses) {
        [allNumbers appendFormat:@"%@; ", numberOfRoute];
    }
    
    if ([allTramways count] > 0)
        [allNumbers appendString:@"\nТрамваи: "];
    for (NSString *numberOfRoute in allTramways) {
        [allNumbers appendFormat:@"%@; ", numberOfRoute];
    }
    
    if ([allMetros count] > 0)
        [allNumbers appendString:@"\nМетро: "];
    for (NSString *numberOfRoute in allMetros) {
        [allNumbers appendFormat:@"%@; ", numberOfRoute];
    }
    
    [allUniqueEndStops release];
    
    cell.labelRoutes.text = allRoutes;
    cell.labelNumbers.text = allNumbers;
    [allRoutes release];
    [allNumbers release];
    [allUniqueBusNumbers release];
    [allUniqueTrolleybusNumbers release];
    [allUniqueTramwayNumbers release];
    [allUniqueMetroNumbers release];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (UIView* subview in [tableView cellForRowAtIndexPath:indexPath].subviews) 
    {
        if ([subview isKindOfClass:[ScrollingLabel class]]) {
            [(ScrollingLabel *)subview startAnimate];
        }
    }
    [FullInfoAboutRoute sharedMySingleton]->isNeedUpdateThirdScreen = YES;
    [FullInfoAboutRoute sharedMySingleton]->currentRoutesOnStop = [[possibleRoutes allValues] objectAtIndex:indexPath.row];
    [FullInfoAboutRoute sharedMySingleton]->currentStopId = [[possibleRoutes allKeys] objectAtIndex:indexPath.row];
    
    ResultScreen2 *result2ViewController = [[ResultScreen2 alloc] init];
    [self.navigationController pushViewController:result2ViewController animated:YES];
    [result2ViewController release];
}


- (void)reloadData:(BOOL)isDeleteCell
{
    AllRoutesAndStops *aRAS = [AllRoutesAndStops sharedMySingleton];

    PleaseWaitAlertView *alertView = [[PleaseWaitAlertView alloc] initWithTitle:@"Поиск" message:@"Пожалуйста, подождите..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
        
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    dispatch_async(queue, ^{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        possibleRoutes = [[aRAS findAllPossibleRoutesByRouteName] retain];
        countOfItemsInTable = [[possibleRoutes allKeys] count];
        
        if (!isDeleteCell) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableViewRoutes reloadData];
                [alertView dismissWithClickedButtonIndex:-1 animated:YES];
                [alertView release];
            });
        }
        
        [pool drain];
    });
    
}
@end
