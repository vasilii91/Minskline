//
//  FirstScreen.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 04.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstScreen.h"

static NSString *IMAGE_NAME_AUTOBUS_CLICKED = @"autobus_clicked.png";
static NSString *IMAGE_NAME_TROLLEYBUS_CLICKED= @"trolleybus_clicked.png";
static NSString *IMAGE_NAME_TRAMWAY_CLICKED = @"tramway_clicked.png";
static NSString *IMAGE_NAME_METRO_CLICKED = @"metro_clicked.png";
static NSString *IMAGE_NAME_FAVORITE_CLICKED = @"favorite_selected.png";
static NSString *IMAGE_NAME_AUTOBUS_NONCLICKED = @"autobus_nonclicked.png";
static NSString *IMAGE_NAME_TROLLEYBUS_NONCLICKED= @"trolleybus_nonclicked.png";
static NSString *IMAGE_NAME_TRAMWAY_NONCLICKED = @"tramway_nonclicked.png";
static NSString *IMAGE_NAME_METRO_NONCLICKED = @"metro_nonclicked.png";
static NSString *IMAGE_NAME_FAVORITE_NONCLICKED = @"favorite_non_selected.png";
static NSString* MESSAGE_WHEN_USER_WANT_TO_UPDATE = @"Вы уверены, что хотите обновить все рассписание? Это может занять достаточно много времени (в зависимости от скорости соединения), а также будет использовано порядка 40 Мб вашего интернет-трафика. В любой момент вы можете остановить обновление и позже продолжить с прерванного места. Во время обновления приложение будет функционировать в обычном режиме!";

static NSInteger COUNT_OF_BUTTONS_IN_ROW = 4;
static NSInteger BUTTON_DIMENTION = 45;
static NSInteger SPACING_SIZE = 5;

@implementation FirstScreen

@synthesize firstScreenWindow;
@synthesize secondScreen;
@synthesize busButton, trolleybusButton, tramwayButton, metroButton, favoriteButton;
@synthesize progressView;
@synthesize percentageLabel;
@synthesize updateButton, stopButton;
@synthesize toGetSchedule;
@synthesize scrollViewToRoutes, scrollViewToRoutesBuses, scrollViewToRoutesTramways, scrollViewToRoutesTrolleybuses;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // Disregard parameters - nib name is an implementation detail
    return [self init];
}

- (void)dealloc
{
    [arrayToFavorities release];
    [arrayOfDirections release];
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
    
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1 green:0.39 blue:0 alpha:1];
    
    // Do any additional setup after loading the view from its nib.
    [FullInfoAboutRoute sharedMySingleton].typeOfTransport = BUS;
    progressView.progress = 0.0f;
    [progressView setHidden:YES];
    [percentageLabel setHidden:YES];
    [stopButton setHidden:YES];
    [updateButton setHidden:YES];
    
    [self addDataToArrayOfDirections:YES];
    
    // a page is the width of the scroll view
    scrollViewToRoutes.pagingEnabled = NO;
    scrollViewToRoutes.showsHorizontalScrollIndicator = NO;
    scrollViewToRoutes.showsVerticalScrollIndicator = YES;
    scrollViewToRoutes.scrollsToTop = NO;
    scrollViewToRoutes.scrollEnabled = YES;
    
    scrollViewToRoutesBuses.pagingEnabled = NO;
    scrollViewToRoutesBuses.showsHorizontalScrollIndicator = NO;
    scrollViewToRoutesBuses.showsVerticalScrollIndicator = YES;
    scrollViewToRoutesBuses.scrollsToTop = NO;
    scrollViewToRoutesBuses.scrollEnabled = YES;
    
    arrayToFavorities = [[NSArray alloc] initWithObjects:@"Автобусы", @"Троллейбусы", @"Трамваи", @"Метро", @"Все", nil];
    
    [busButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_AUTOBUS_CLICKED] forState:UIControlStateNormal];
    
    [self createButtonsOfRoutes:BUS];
    [self createButtonsOfRoutes:TROLLEYBUS];
    [self createButtonsOfRoutes:TRAMWAY];
    [self buttonClickOnOneOfButton:nil];
}

- (void)createButtonsOfRoutes:(TypeOfTransportEnum)typeOfTransport
{
    for (UIView *subview in [scrollViewToRoutes subviews]) {
        [subview removeFromSuperview];
    }
    
    CGFloat heightOfScrollView = 0;
    
    
    // т.е. это метро и нужны две другие кнопки
    if (typeOfTransport == METRO)
    {
        NSArray *namesForMetro = [[NSArray alloc] initWithObjects:@"Автозаводская линия", @"Московская линия", nil];
        for (int i = 0; i < 2; i++) 
        {
            UIButton *button = [[UIButton alloc] init];
            button.frame = CGRectMake(0,
                                      (BUTTON_DIMENTION + SPACING_SIZE) * i, 
                                      (BUTTON_DIMENTION + SPACING_SIZE) * COUNT_OF_BUTTONS_IN_ROW,
                                      BUTTON_DIMENTION);
            [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
            UIImage *image = [UIImage imageNamed:@"metro_and_favorites_cell.png"];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [button setTitle:[namesForMetro objectAtIndex:i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClickOnRouteButton:) forControlEvents:UIControlEventTouchUpInside];
            [scrollViewToRoutes addSubview:button];
            
            if (i == 0) {
                buttonPreviousChosen = button;
            }
            [button release];
            
            heightOfScrollView = 2 * (BUTTON_DIMENTION + SPACING_SIZE);
        }
        [namesForMetro release];
        [scrollViewToRoutes setHidden:NO];
        [scrollViewToRoutesBuses setHidden:YES];
        [scrollViewToRoutesTrolleybuses setHidden:YES];
        [scrollViewToRoutesTramways setHidden:YES];
    }
    else if (typeOfTransport == FAVORITIES) {
        
        for (int i = 0; i < [arrayToFavorities count]; i++) 
        {
            UIButton *button = [[UIButton alloc] init];
            button.frame = CGRectMake(0,
                                      (BUTTON_DIMENTION + SPACING_SIZE) * i, 
                                      (BUTTON_DIMENTION + SPACING_SIZE) * COUNT_OF_BUTTONS_IN_ROW,
                                      BUTTON_DIMENTION);
            [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
            UIImage *image = [UIImage imageNamed:@"metro_and_favorites_cell.png"];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [button setTitle:[arrayToFavorities objectAtIndex:i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClickOnRouteButton:) forControlEvents:UIControlEventTouchUpInside];
            [scrollViewToRoutes addSubview:button];
            
            if (i == 0) {
                buttonPreviousChosen = button;
            }
            [button release];
            
            heightOfScrollView = 2 * (BUTTON_DIMENTION + SPACING_SIZE);
        }
        [scrollViewToRoutes setHidden:NO];
        [scrollViewToRoutesBuses setHidden:YES];
        [scrollViewToRoutesTrolleybuses setHidden:YES];
        [scrollViewToRoutesTramways setHidden:YES];
    }
    else {
        clock_t start = clock();
        TypeOfTransportEnum typeOfTransport = [FullInfoAboutRoute sharedMySingleton].typeOfTransport;
        
        BOOL isInitialized = NO;
        switch (typeOfTransport) {
            case BUS:
                if (isInitBuses)
                    isInitialized = YES;
                break;
            case TROLLEYBUS:
                if (isInitTrolleybuses) 
                    isInitialized = YES;
                break;
            case TRAMWAY:
                if (isInitTramways) 
                    isInitialized = YES;
                break;
            default:
                break;
        }

        if (!isInitialized) {
            NSInteger countOfRows = [arrayOfDirections count] / COUNT_OF_BUTTONS_IN_ROW;
            if ([arrayOfDirections count] % COUNT_OF_BUTTONS_IN_ROW != 0) {
                countOfRows++;
            }
            for (int i = 0; i < countOfRows; i++)
            {
                for (int j = 0; j < COUNT_OF_BUTTONS_IN_ROW; j++)
                {
                    if (i * COUNT_OF_BUTTONS_IN_ROW + j == [arrayOfDirections count]) {
                        break;
                    }
                    UIButton *button = [[UIButton alloc] init];
                    button.frame = CGRectMake((BUTTON_DIMENTION + SPACING_SIZE) * j, 
                                              (BUTTON_DIMENTION + SPACING_SIZE) * i, 
                                              BUTTON_DIMENTION, BUTTON_DIMENTION);
                    [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
                    UIImage *image = [UIImage imageNamed:@"black_button_2.png"];
                    [button setBackgroundImage:image forState:UIControlStateNormal];
                    [button setTitle:[arrayOfDirections objectAtIndex:i * COUNT_OF_BUTTONS_IN_ROW + j] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(buttonClickOnRouteButton:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollViewToRoutes addSubview:button];
                    switch (typeOfTransport) {
                        case BUS:
                            isInitBuses = YES;
                            [scrollViewToRoutesBuses addSubview:button];
                            break;
                        case TROLLEYBUS:
                            isInitTrolleybuses = YES;
                            [scrollViewToRoutesTrolleybuses addSubview:button];
                            break;
                        case TRAMWAY:
                            isInitTramways = YES;
                            [scrollViewToRoutesTramways addSubview:button];
                            break;
                        default:
                            break;
                    }
                    
                    if (i == 0 && j == 0) {
                        buttonPreviousChosen = button;
                    }
                    [button release];
                }
            }
        }

            switch (typeOfTransport) {
                case BUS:
                    [scrollViewToRoutes setHidden:YES];
                    [scrollViewToRoutesBuses setHidden:NO];
                    [scrollViewToRoutesTrolleybuses setHidden:YES];
                    [scrollViewToRoutesTramways setHidden:YES];
                    break;
                case TROLLEYBUS:
                    [scrollViewToRoutes setHidden:YES];
                    [scrollViewToRoutesBuses setHidden:YES];
                    [scrollViewToRoutesTrolleybuses setHidden:NO];
                    [scrollViewToRoutesTramways setHidden:YES];
                    break;
                case TRAMWAY:
                    [scrollViewToRoutes setHidden:YES];
                    [scrollViewToRoutesBuses setHidden:YES];
                    [scrollViewToRoutesTrolleybuses setHidden:YES];
                    [scrollViewToRoutesTramways setHidden:NO];
                    break;
                default:
                    break;
            }

        clock_t finish = clock();
        
        clock_t duration = finish - start;
        double durInSec = (double)duration / CLOCKS_PER_SEC;
        NSLog(@"%lu - %f", duration, durInSec);

        heightOfScrollView = [arrayOfDirections count] / 
        COUNT_OF_BUTTONS_IN_ROW * (BUTTON_DIMENTION + SPACING_SIZE);        
    }
    
    CGFloat widthOfContentSize = scrollViewToRoutes.frame.size.width;
    CGFloat heightOfContentSize = heightOfScrollView - 5;
    CGSize size = CGSizeMake(widthOfContentSize, heightOfContentSize);
    
    scrollViewToRoutes.contentSize = size;
    scrollViewToRoutesBuses.contentSize = size;
    scrollViewToRoutesTrolleybuses.contentSize = size;
    
    [scrollViewToRoutes setContentOffset:CGPointMake(0, 0) animated:YES];
    [scrollViewToRoutesBuses setContentOffset:CGPointMake(0, 0) animated:YES];
    [scrollViewToRoutesTrolleybuses setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)buttonClickOnRouteButton:(id)sender
{
    FullInfoAboutRoute *fiar = [FullInfoAboutRoute sharedMySingleton];
//    TypeOfTransportEnum typeOfTransport = fiar.typeOfTransport;
//    UIImage *blackImage = nil;
//    if (typeOfTransport == METRO || typeOfTransport == FAVORITIES) {
//        blackImage = [UIImage imageNamed:@"topAndBottomRowSelected_gray.png"];
//    }
//    else {
//        blackImage = [UIImage imageNamed:@"black_button_2.png"];
//    }
//    
//    [buttonPreviousChosen setBackgroundImage:blackImage forState:UIControlStateNormal];
//    [buttonPreviousChosen setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
//    
    UIButton *clickedButton = ((UIButton *)sender);
//    buttonPreviousChosen = clickedButton;
//    UIImage *image = nil;
//    if (typeOfTransport == METRO || typeOfTransport == FAVORITIES) {
//        image = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
//    }
//    else {
//        image = [UIImage imageNamed:@"orange_button_2.png"];
//    }
//    [clickedButton setBackgroundImage:image forState:UIControlStateNormal];
//    [clickedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    NSString *rowFromPickerView = clickedButton.titleLabel.text;
    [FullInfoAboutRoute sharedMySingleton].numberOfTransport = rowFromPickerView;
    
    fiar->isNeedUpdateSecondScreen = YES;
    
    SecondScreen *secondScreenViewController = [[SecondScreen alloc] init];
    [self.navigationController pushViewController:secondScreenViewController animated:YES];
    [secondScreenViewController release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)setProgress:(NSNotification*)progress
{
    float progressFloat = [[progress object] floatValue];
    if (progressFloat == -2) 
    {
        [progressView setHidden:YES];
//        [percentageLabel setHidden:YES];
        [stopButton setHidden:YES];
        [updateButton setHidden:NO];
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Вы прервали загрузку!"];
        [alert setMessage: @"Вы можете возобновить загрузку позже, с прерванного места!"];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"Ок"];
        [alert show];
        [alert release];
    }
    else if (progressFloat == -1)
    {
        [progressView setHidden:YES];
//        [percentageLabel setHidden:YES];
        [stopButton setHidden:YES];
        [updateButton setHidden:NO];
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Проверьте соединение"];
        [alert setMessage: @"Доступ в интернет отсутствует. Проверьте ваше соединение."];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"Ок"];
        [alert show];
        [alert release];
    }
    else {
        [progressView setHidden:NO];
        [percentageLabel setHidden:NO];
        [updateButton setHidden:YES];
        [stopButton setHidden:NO];
        totalProgress += progressFloat;
        [progressView setProgress:totalProgress / 100];
        percentageLabel.text = [NSString stringWithFormat:@"%f percent", totalProgress];
    }
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setProgress:) name:@"Percentage" object:nil];
    }
    return self;
}

- (id)init
{
    // Call the superclass's designated initializer
//    [super initWithNibName:nil bundle:nil];
    
    return self = [super initWithNibName:nil bundle:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)initializeSecondScreen
{
    secondScreen = [[ResultScreen alloc] initWithNibName:@"SecondScreen" bundle:nil];
}

- (IBAction) buttonClickOnUpdateButton:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Обновить все рассписание?"];
	[alert setMessage: MESSAGE_WHEN_USER_WANT_TO_UPDATE];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Нет, позже"];
	[alert addButtonWithTitle:@"Да, обновить"];
	[alert show];
	[alert release];
}

- (IBAction)buttonClickOnStopButton:(id)sender
{
    [[AllRoutesAndStops sharedMySingleton] setIsUserClickedOnStopButtonWhenUpdate:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		// No
	}
	else if (buttonIndex == 1)
	{
        // Yes, do something
        [[AllRoutesAndStops sharedMySingleton] getAllRoutes];
	}
}

- (IBAction) buttonClickOnOneOfButton:(id)sender
{
    TypeOfTransportEnum typeOfTransport = BUS;
    switch ([sender tag]) {
        case 0:
            typeOfTransport = BUS;  
            [busButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_AUTOBUS_CLICKED] forState:UIControlStateNormal];
            [trolleybusButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_TROLLEYBUS_NONCLICKED] forState:UIControlStateNormal];
            [tramwayButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_TRAMWAY_NONCLICKED] forState:UIControlStateNormal];
            [metroButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_METRO_NONCLICKED] forState:UIControlStateNormal];
            [favoriteButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_FAVORITE_NONCLICKED] forState:UIControlStateNormal];
            break;
        case 1:
            typeOfTransport = TROLLEYBUS;
            [busButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_AUTOBUS_NONCLICKED] forState:UIControlStateNormal];
            [trolleybusButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_TROLLEYBUS_CLICKED] forState:UIControlStateNormal];
            [tramwayButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_TRAMWAY_NONCLICKED] forState:UIControlStateNormal];
            [metroButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_METRO_NONCLICKED] forState:UIControlStateNormal];
            [favoriteButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_FAVORITE_NONCLICKED] forState:UIControlStateNormal];
            break;
        case 2:
            typeOfTransport = TRAMWAY;
            [busButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_AUTOBUS_NONCLICKED] forState:UIControlStateNormal];
            [trolleybusButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_TROLLEYBUS_NONCLICKED] forState:UIControlStateNormal];
            [tramwayButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_TRAMWAY_CLICKED] forState:UIControlStateNormal];
            [metroButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_METRO_NONCLICKED] forState:UIControlStateNormal];
            [favoriteButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_FAVORITE_NONCLICKED] forState:UIControlStateNormal];
            break;
        case 3:
            typeOfTransport = METRO;
            [busButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_AUTOBUS_NONCLICKED] forState:UIControlStateNormal];
            [trolleybusButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_TROLLEYBUS_NONCLICKED] forState:UIControlStateNormal];
            [tramwayButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_TRAMWAY_NONCLICKED] forState:UIControlStateNormal];
            [metroButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_METRO_CLICKED] forState:UIControlStateNormal];
            [favoriteButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_FAVORITE_NONCLICKED] forState:UIControlStateNormal];
            break;
        case 4:
            typeOfTransport = FAVORITIES;
            [busButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_AUTOBUS_NONCLICKED] forState:UIControlStateNormal];
            [trolleybusButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_TROLLEYBUS_NONCLICKED] forState:UIControlStateNormal];
            [tramwayButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_TRAMWAY_NONCLICKED] forState:UIControlStateNormal];
            [metroButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_METRO_NONCLICKED] forState:UIControlStateNormal];
            [favoriteButton setBackgroundImage:[UIImage imageNamed: IMAGE_NAME_FAVORITE_CLICKED] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [FullInfoAboutRoute sharedMySingleton].typeOfTransport = typeOfTransport;
    [self addDataToArrayOfDirections:NO];
    
    [self createButtonsOfRoutes: typeOfTransport];
}

- (void)addDataToArrayOfDirections:(BOOL)isFirstly
{
    
    clock_t start = clock();
    TypeOfTransportEnum typeOfTransport = [FullInfoAboutRoute sharedMySingleton].typeOfTransport;
    AllRoutesAndStops *allRoutesAndStopes = [AllRoutesAndStops sharedMySingleton];    

    switch (typeOfTransport) {
        case BUS:
            arrayOfDirectionsBus = (arrayOfDirectionsBus == nil) ? [[allRoutesAndStopes getAllRoutesByTypeOfTransport:typeOfTransport] retain] : arrayOfDirectionsBus;
            arrayOfDirections = [[NSMutableArray alloc] initWithArray:arrayOfDirectionsBus];
            break;
        case TROLLEYBUS:
            arrayOfDirectionsTrolleybus = (arrayOfDirectionsTrolleybus == nil) ? [[allRoutesAndStopes getAllRoutesByTypeOfTransport:typeOfTransport] retain] : arrayOfDirectionsTrolleybus;
            arrayOfDirections = [[NSMutableArray alloc] initWithArray:arrayOfDirectionsTrolleybus];
            break;
        case TRAMWAY:
            arrayOfDirectionsTramway = (arrayOfDirectionsTramway == nil) ? [[allRoutesAndStopes getAllRoutesByTypeOfTransport:typeOfTransport] retain] : arrayOfDirectionsTramway;
            arrayOfDirections = [[NSMutableArray alloc] initWithArray:arrayOfDirectionsTramway];
            break;
        default:
            break;
    }
    clock_t finish = clock();
    
    clock_t duration = finish - start;
    double durInSec = (double)duration / CLOCKS_PER_SEC;
    NSLog(@"Получение всех маршрутов = %lu - %f", duration, durInSec);
}

@end
