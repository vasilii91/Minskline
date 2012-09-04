//
//  SecondScreen.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 04.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultScreen.h"

static NSInteger imageHeight = 60;
static NSInteger imageWidth = 45;

@implementation ResultScreen

@synthesize tableViewResult, numberOfTransport, textOfCell, imageView, labelTo, labelFrom, labelInterval;

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
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Домой" style:UIBarButtonItemStyleBordered target:self action:@selector(goToHome:)];          
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton release];
    
    UILabel *label = [PrettyViews labelToNavigationBarWithTitle:@"Результат"];
    self.navigationItem.title= @"Результат";
    self.navigationItem.titleView = label;
    
    tableViewResult.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewResult.rowHeight = 80;
    tableViewResult.backgroundColor = [UIColor clearColor];
    
    [RWR.resultForView removeAllObjects];
    [tableViewResult reloadData];
    
    [self reloadData];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (RWR != nil && [RWR.resultForView count] > 0) {
        return [RWR.resultForView count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isExistSomeResult;
    
    ResultForView *rfw = nil;
    if (RWR != nil && [RWR.resultForView count] > 0) {
        rfw = [RWR.resultForView objectAtIndex:indexPath.row];

        isExistSomeResult = YES;
    }
    else {
        isExistSomeResult = NO;
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    KVTableViewCellResultScreen *cell = [tableViewResult dequeueReusableCellWithIdentifier:CellIdentifier];
    
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

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    for (UIView* subview in [tableView cellForRowAtIndexPath:indexPath].subviews) 
    {
        if ([subview isKindOfClass:[ScrollingLabel class]]) {
            [(ScrollingLabel *)subview startAnimate];
            textOfCell = [NSString stringWithFormat:@"%@", [(ScrollingLabel *)subview text]];
        }
    }
    
    NSMutableArray *allStops = [[AllRoutesAndStops sharedMySingleton] getStopsByName:[[FullInfoAboutRoute sharedMySingleton] currentStop]];
    ResultForView *rfw = [RWR.resultForView objectAtIndex:indexPath.row];
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
    PleaseWaitAlertView *alertView = [[PleaseWaitAlertView alloc] initWithTitle:@"Поиск" message:@"Пожалуйста, подождите..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];

    if (RWR.isNeedUpdateResultScreen == YES) {
        [alertView show];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        
        dispatch_async(queue, ^{
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            
            FullInfoAboutRoute *fiar = [FullInfoAboutRoute sharedMySingleton];
            NSLog(@"%@ - %@", fiar.currentStop, fiar.destinationStop);
            if ([fiar.currentStop isEqualToString:fiar.destinationStop]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Попробуйте пройтись пешком:)" message:@"Вы серьезно? Ладно, я Вас понимаю, Вы просто решили протестировать программу:) Пишите, если найдете ошибку. Спасибо." delegate:self cancelButtonTitle:@"Вернуться назад" otherButtonTitles:nil, nil];
                    [av show];
                    [av release];
                    [alertView dismissWithClickedButtonIndex:-1 animated:YES];
                    [alertView release];
                });
            }
            else {
                AllRoutesAndStops *aRAS = [AllRoutesAndStops sharedMySingleton];
                [aRAS findAllPossibleRoutes];
                // на случай, если остались объекты в массиве, удаляем их
                [RWR.resultForView removeAllObjects];
                if ([RWR.allPossibleRoutes count] > 0) {
                    for (MRouteWithSchedule *mrws in RWR.allPossibleRoutes) {
                        NSString *transportNumber = mrws->transportNumber;
                        
                        for (NSNumber *time in mrws.schedule) {
                            ResultForView *oneResultForView = [[ResultForView alloc] init];
                            oneResultForView.typeOfTransport = mrws->typeOfTransport;
                            oneResultForView.time = [time intValue];
                            oneResultForView.transportNumber = transportNumber;
                            oneResultForView.routeId = mrws->routeId;
                            
                            [RWR.resultForView addObject:oneResultForView];
                            [oneResultForView release];
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableViewResult reloadData];
                    [alertView dismissWithClickedButtonIndex:-1 animated:YES];
                    [alertView release];
                    
                    if ([RWR.resultForView count] == 0) {
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Ничего не найдено" message:@"К сожалению, в данное время между выбранными остановками транспорт не ходит" delegate:self cancelButtonTitle:@"Вернуться назад" otherButtonTitles:nil, nil];
                        [av show];
                        [av release];
                    }
                    
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    SortResultTypeEnum sortType = [[def valueForKey:SORT_TYPE] intValue];
                    [RWR sortResultForView:sortType]; // сортируем массив с результатом
                });
            }
            
            [pool drain];
        });
    }
    
    // Do any additional setup after loading the view from its nib.
    
    // говорит, что тэйблвью обновлен, и если не изменится условие поиска, то обновлять не надо
    RWR.isNeedUpdateResultScreen = YES;
    
    FullInfoAboutRoute *fiar = [FullInfoAboutRoute sharedMySingleton];
    SettingsOfMinsktrans *settings = [SettingsOfMinsktrans sharedMySingleton];
    NSInteger interval = [settings interval];
    NSString *from = [fiar currentStop];
    NSString *to = [fiar destinationStop];
    
    labelFrom.text = from;
    labelTo.text = to;
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
