//
//  ResultScreen2.m
//  Minsktrans
//
//  Created by Vasilii Kasnitski on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResultScreen2.h"

static NSInteger imageHeight = 60;
static NSInteger imageWidth = 45;

@implementation ResultScreen2

@synthesize tableViewResult, numberOfTransport, textOfCell, imageView, labelFrom, labelInterval;

- (void)dealloc
{
    //    [RWR release];
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
    
    UILabel *label = [PrettyViews labelToNavigationBarWithTitle:@"Результат"];
    self.navigationItem.title = @"Результат";
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Домой" style:UIBarButtonItemStyleBordered target:self action:@selector(goToHome:)];          
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton release];
    
    tableViewResult.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewResult.rowHeight = 80;
    tableViewResult.backgroundColor = [UIColor clearColor];
    
    [RWR.resultForView2 removeAllObjects];
    [tableViewResult reloadData];
    
    [self reloadData];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [RWR.resultForView2 removeAllObjects];
//    [tableViewResult reloadData];
//}

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// The number of sections is the same as the number of titles in the collation.
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// The number of stops in the section is the count of the array associated with the section in the sections array.
    
    if (RWR != nil && [RWR.resultForView2 count] > 0) {
        return [RWR.resultForView2 count];
    }
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isExistSomeResult;
    
    ResultForView *rfw = nil;
    if (RWR != nil && [RWR.resultForView2 count] > 0) {
        rfw = [RWR.resultForView2 objectAtIndex:indexPath.row];
        isExistSomeResult = YES;
    }
    else {
        isExistSomeResult = NO;
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    KVTableViewCellResultScreen *cell = [tableViewResult dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (isExistSomeResult == YES) 
    {
        if (cell == nil) {
            cell = [[[KVTableViewCellResultScreen alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier] autorelease];
            
        }
        
        NSString *transportNumber = rfw.transportNumber;
        NSInteger time = rfw.time;
        cell.topLabel.text = [NSString stringWithFormat:@"Через %i %@", time, [rfw rightTextByTime]];
        cell.bottomLabel.text = [NSString stringWithFormat:@"%@ маршрут", transportNumber];
        
        //
        // Here I set an image based on the row. This is just to have something
        // colorful to show on each row.
        //
        
        switch (rfw.typeOfTransport) {
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSMutableArray *allStops = [[AllRoutesAndStops sharedMySingleton] getStopsByName:[[FullInfoAboutRoute sharedMySingleton] currentStopToAllDirections]];
    ResultForView *rfw = [RWR.resultForView2 objectAtIndex:indexPath.row];
    NSInteger routeId = rfw.routeId;
    NSNumber *dayOfWeek = [NSNumber numberWithInt: [Schedule getCurrentDayOfWeek]];
    
    Stops *currentStop;
    Routes *currentRoute;
    for (Stops *stop in allStops) {
        Times *schedule = [[AllRoutesAndStops sharedMySingleton] getScheduleByRouteIdAndStopId:[NSNumber numberWithInt:routeId] andStopId:stop.StopId dayOfWeek:dayOfWeek];
        if (schedule != nil) {
            currentRoute = [[AllRoutesAndStops sharedMySingleton] getRouteById:[NSNumber numberWithInt:routeId]];
            currentStop = stop;
            break;
        }
    }
    
    FourthScreen *fourthScreenViewController = [[FourthScreen alloc] initWithNibName:@"FourthScreen" bundle:nil];
    fourthScreenViewController.typeOfTransport = rfw.typeOfTransport;
    fourthScreenViewController.numberOfTransport = rfw.transportNumber;
    fourthScreenViewController.currentStop = currentStop;
    fourthScreenViewController.currentRoute = currentRoute;
    
    [self.navigationController pushViewController:fourthScreenViewController animated:YES];
    [fourthScreenViewController release];
}

-(void)reloadData
{
    RWR = [RequestWithResult sharedMySingleton];
        
    FullInfoAboutRoute *fiar = [FullInfoAboutRoute sharedMySingleton];
    NSNumber *currentStopId = fiar->currentStopId;
    NSArray *currentRoutesOnStop = fiar->currentRoutesOnStop;
    
    AllRoutesAndStops *aRAS = [AllRoutesAndStops sharedMySingleton];
    
    NSMutableArray *currentRouteIds = [[NSMutableArray alloc] init];
    for (Route *route in currentRoutesOnStop) {
        [currentRouteIds addObject:route.routeId];
    }
    
    PleaseWaitAlertView *alertView = [[PleaseWaitAlertView alloc] initWithTitle:@"Поиск" message:@"Пожалуйста, подождите..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    dispatch_async(queue, ^{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
        // нужно создать сначала массив из айдишников остановок
        [aRAS findAllPossibleRoutesOnCurrentStop:currentStopId currentRoutes:currentRouteIds];
        [currentRouteIds release];

        // на случай, если остались объекты в массиве, удаляем их
        [RWR.resultForView2 removeAllObjects];
        if ([RWR.allPossibleRoutesOnCurrentStop count] > 0) {
            for (MRouteWithSchedule *mrws in RWR.allPossibleRoutesOnCurrentStop) {
                NSString *transportNumber = mrws->transportNumber;
                
                for (NSNumber *time in mrws.schedule) {
                    ResultForView *oneResultForView = [[ResultForView alloc] init];
                    oneResultForView.typeOfTransport = mrws->typeOfTransport;
                    oneResultForView.time = [time intValue];
                    oneResultForView.transportNumber = transportNumber;
                    oneResultForView.routeId = mrws->routeId;
                    
                    // добавляем в результат только если присутствуют все параметры
                    if ([oneResultForView isValidResult])
                        [RWR.resultForView2 addObject:oneResultForView];
                    [oneResultForView release];
                }
            }
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableViewResult reloadData];
            [alertView dismissWithClickedButtonIndex:-1 animated:YES];
            [alertView release];
            
            if ([RWR.resultForView2 count] == 0) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Ничего не найдено." message:@"К сожалению, в данное время на выбранной остановке транспорт не ходит" delegate:self cancelButtonTitle:@"Вернуться назад" otherButtonTitles:nil, nil];
                [av show];
                [av release];
            }
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            SortResultTypeEnum sortType = [[def valueForKey:SORT_TYPE] intValue];
            [RWR sortResultForView:sortType]; // сортируем массив с результатом
        });
        
        [pool drain];
        
    });
    
    // Do any additional setup after loading the view from its nib.
    
    // говорит, что тэйблвью обновлен, и если не изменится условие поиска, то обновлять не надо
    RWR.isNeedUpdateResultScreen = YES;
    
    SettingsOfMinsktrans *settings = [SettingsOfMinsktrans sharedMySingleton];
    NSInteger interval = [settings interval];
    NSString *from = [fiar currentStopToAllDirections];
    
    labelFrom.text = from;
    labelInterval.text = [NSString stringWithFormat:@"%i минут", interval];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)clickOnUpdate:(id)sender
{
    [self reloadData];
}

@end