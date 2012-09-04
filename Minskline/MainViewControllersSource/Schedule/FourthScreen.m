//
//  FourthScreen.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 04.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FourthScreen.h"

static NSInteger WIDTH_OF_ROW = 30;
static NSInteger WIDTH_FOR_ONE_SYMBOL_IN_HOUR = 5;
static NSInteger SPACING_SIZE = 2;
static NSInteger FONT_SIZE_FOR_HOUR = 26;
static NSInteger FONT_SIZE_FOR_MINUTES = 16;
static NSInteger INDECION_FROM_LEFT = 21;
static NSInteger INDECION_FROM_UP = 5;

static NSString *IMAGE_ROW_SELECTED = @"topAndBottomRowSelected.png";
static NSString *IMAGE_ROW_SELECTED_GRAY = @"topAndBottomRowSelected_gray.png";

@implementation FourthScreen

@synthesize numberOfTransport, typeOfTransport, currentStop, currentRoute;

@synthesize scrollViewSchedule, imageView, navBar;
@synthesize buttonWorkdays, buttonHolydays;
@synthesize buttonSunday, buttonSaturday;

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
    self.scrollViewSchedule = nil;
    self.imageView = nil;
    self.buttonHolydays = nil;
    self.buttonSaturday = nil;
    self.buttonSunday = nil;
    self.buttonWorkdays = nil;
    self.navBar = nil;
    
    [scheduleFull release];
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
    
    NSString *header = [NSString stringWithFormat:@"№%@", self.numberOfTransport];
    if (self.typeOfTransport == METRO)
        header = @"Метро";
    
    self.navigationItem.title= header;
    UILabel *label = [PrettyViews labelToNavigationBarWithTitle:header];
    self.navigationItem.titleView = label;
    
    dayOfWeek = [Schedule getCurrentDayOfWeek];
    [self reloadData];
    
    [self clickToNeedButton];
    
    // a page is the width of the scroll view
    scrollViewSchedule.pagingEnabled = NO;
    scrollViewSchedule.showsHorizontalScrollIndicator = NO;
    scrollViewSchedule.showsVerticalScrollIndicator = NO;
    scrollViewSchedule.scrollsToTop = NO;
    scrollViewSchedule.scrollEnabled = YES;
    
    isWorkDayChosen = YES;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Домой" style:UIBarButtonItemStyleBordered target:self action:@selector(goToHome:)];          
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton release];
}

-(void)goToHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createLabelsWithSchedule
{
    for (UIView *subview in [scrollViewSchedule subviews]) {
        [subview removeFromSuperview];
    }
    
    CGFloat heightOfScrollView;
    
    int countOfHours = 0;
    
    if ([sortedArrayOfHours count] == 0) {
        labelEmptySchedule = [[UILabel alloc] initWithFrame:CGRectMake(25, 50, 320, 30)];
        [labelEmptySchedule setFont:[UIFont systemFontOfSize:16]];
        [labelEmptySchedule setTextColor:[UIColor orangeColor]];
        [labelEmptySchedule setText:[NSString stringWithFormat: @"В этот день маршрут %@ не ходит", self.numberOfTransport]];
        [labelEmptySchedule setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:labelEmptySchedule];
        [labelEmptySchedule release];
    }
    else {
        if (labelEmptySchedule) {
            [labelEmptySchedule setHidden:YES];
            [labelEmptySchedule setText:@""];
        }
    }
    
    for (NSString *hour in sortedArrayOfHours) {
        
        UILabel *hourLabel = [[UILabel alloc] init];
        CGRect frame = CGRectMake(INDECION_FROM_LEFT, (WIDTH_OF_ROW + SPACING_SIZE) * (countOfHours + 0.3), ([hour length] == 2 ? WIDTH_FOR_ONE_SYMBOL_IN_HOUR * 2 : WIDTH_FOR_ONE_SYMBOL_IN_HOUR) + INDECION_FROM_LEFT * 2, WIDTH_OF_ROW);
        hourLabel.frame = frame;
        hourLabel.textColor = [UIColor orangeColor];
        hourLabel.backgroundColor = [UIColor clearColor];
        hourLabel.font = [UIFont systemFontOfSize:FONT_SIZE_FOR_HOUR];
        hourLabel.text = hour;
        [scrollViewSchedule addSubview:hourLabel];
        [hourLabel release];
        
        NSMutableArray *minutes = [dictionarySchedule objectForKey:hour];
        NSMutableString *minuteLabelString = [[NSMutableString alloc] init];
        
        ScrollingLabel *scrollingLabel = [[ScrollingLabel alloc] init];
        
        for (NSString *minute in minutes) {
            [minuteLabelString appendFormat:@"%@ ", minute];
        }
        scrollingLabel.text = minuteLabelString;
        scrollingLabel.textLabel.textColor = [UIColor yellowColor];
        scrollingLabel.textLabel.backgroundColor = [UIColor clearColor];
        scrollingLabel.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE_FOR_MINUTES];
        
        frame = CGRectMake(0, 0, 320 - 48, WIDTH_OF_ROW);
        scrollingLabel.frame = frame;
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:[UIColor clearColor] forState:UIButtonTypeCustom];
        frame = CGRectMake(65, (WIDTH_OF_ROW + SPACING_SIZE) * (countOfHours + 0.3) + INDECION_FROM_UP, 320 - 48, WIDTH_OF_ROW);
        [button setFrame:frame];
        [button addTarget:self action:@selector(buttonClickToMinutes:) forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:scrollingLabel];
        [scrollingLabel release];
        
        [scrollViewSchedule addSubview:button];
        [button release];
        [minuteLabelString release];
        
        countOfHours++;
    }
    
    heightOfScrollView = (countOfHours + 0.6) * (WIDTH_OF_ROW + SPACING_SIZE);

        
    scrollViewSchedule.contentSize = CGSizeMake(200, heightOfScrollView);
    
    [scrollViewSchedule setContentOffset:CGPointMake(0, 0) animated:YES];
    [scrollViewSchedule setScrollEnabled:YES];
}

- (void)buttonClickToMinutes:(id)sender
{
    UIButton *button = (UIButton *)sender;
    for (UIView* subview in [button subviews]) 
    {
        if ([subview isKindOfClass:[ScrollingLabel class]]) {
            ScrollingLabel *tempLabel = (ScrollingLabel *)subview;
            [tempLabel startAnimate];
        }
    }
}

- (void)clickToNeedButton
{
    // чтобы сразу при загрузке была нажата одна кнопка
    if (!isEqualSaturdayAndSunday) {
        if (dayOfWeek == 6) {
            [self clickToSaturday:nil];
        }
        else if (dayOfWeek == 7) {
            [self clickToSunday:nil];
        }
        else {
            dayOfWeek = 1;
            [self clickToWorkdays:nil];
        }
    }
    else {
        if (dayOfWeek == 6 || dayOfWeek == 7) {
            dayOfWeek = 6;
            [self clickToHolidays:nil];
        }
        else {
            dayOfWeek = 1;
            [self clickToWorkdays:nil];
        }
    }
}

- (IBAction)clickToWorkdays:(id)sender
{
    dayOfWeek = 1;

    UIImage *image = [[UIImage imageNamed:IMAGE_ROW_SELECTED] imageScaledToSize:CGSizeMake(buttonHolydays.frame.size.width, buttonHolydays.frame.size.height)];
    [buttonWorkdays setBackgroundImage:image forState:UIControlStateNormal];
    [buttonWorkdays setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
        UIImage *blackImage = [[UIImage imageNamed:IMAGE_ROW_SELECTED_GRAY] imageScaledToSize:CGSizeMake(buttonSaturday.frame.size.width, buttonSaturday.frame.size.height)];
        [buttonSaturday setBackgroundImage:blackImage forState:UIControlStateNormal];
        [buttonSaturday setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        UIImage *blackImage2 = [[UIImage imageNamed:IMAGE_ROW_SELECTED_GRAY] imageScaledToSize:CGSizeMake(buttonSunday.frame.size.width, buttonSunday.frame.size.height)];
        [buttonSunday setBackgroundImage:blackImage2 forState:UIControlStateNormal];
        [buttonSunday setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        UIImage *blackImage3 = [[UIImage imageNamed:IMAGE_ROW_SELECTED_GRAY] imageScaledToSize:CGSizeMake(buttonHolydays.frame.size.width, buttonHolydays.frame.size.height)];
        [buttonHolydays setBackgroundImage:blackImage3 forState:UIControlStateNormal];
        [buttonHolydays setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];

    if (sender)
        [self reloadData];
}

- (IBAction)clickToHolidays:(id)sender
{
    dayOfWeek = 6;
    
    UIImage *image = [[UIImage imageNamed:IMAGE_ROW_SELECTED] imageScaledToSize:CGSizeMake(buttonHolydays.frame.size.width, buttonHolydays.frame.size.height)];
    [buttonHolydays setBackgroundImage:image forState:UIControlStateNormal];
    [buttonHolydays setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage *blackImage = [[UIImage imageNamed:IMAGE_ROW_SELECTED_GRAY] imageScaledToSize:CGSizeMake(buttonHolydays.frame.size.width, buttonHolydays.frame.size.height)];
    [buttonWorkdays setBackgroundImage:blackImage forState:UIControlStateNormal];
    [buttonWorkdays setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    if (sender)
        [self reloadData];
}

- (IBAction)clickToSaturday:(id)sender
{
    dayOfWeek = 6;
    
    UIImage *image = [[UIImage imageNamed:IMAGE_ROW_SELECTED] imageScaledToSize:CGSizeMake(buttonSaturday.frame.size.width, buttonSaturday.frame.size.height)];
    [buttonSaturday setBackgroundImage:image forState:UIControlStateNormal];
    [buttonSaturday setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage *blackImage = [[UIImage imageNamed:IMAGE_ROW_SELECTED_GRAY] imageScaledToSize:CGSizeMake(buttonWorkdays.frame.size.width, buttonWorkdays.frame.size.height)];
    [buttonWorkdays setBackgroundImage:blackImage forState:UIControlStateNormal];
    [buttonWorkdays setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    UIImage *blackImage2 = [[UIImage imageNamed:IMAGE_ROW_SELECTED_GRAY] imageScaledToSize:CGSizeMake(buttonSunday.frame.size.width, buttonSunday.frame.size.height)];
    [buttonSunday setBackgroundImage:blackImage2 forState:UIControlStateNormal];
    [buttonSunday setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    if (sender)
        [self reloadData];
}

- (IBAction)clickToSunday:(id)sender
{
    dayOfWeek = 7;
    
    UIImage *image = [[UIImage imageNamed:IMAGE_ROW_SELECTED] imageScaledToSize:CGSizeMake(buttonSunday.frame.size.width, buttonSunday.frame.size.height)];
    [buttonSunday setBackgroundImage:image forState:UIControlStateNormal];
    [buttonSunday setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage *blackImage = [[UIImage imageNamed:IMAGE_ROW_SELECTED_GRAY] imageScaledToSize:CGSizeMake(buttonWorkdays.frame.size.width, buttonWorkdays.frame.size.height)];
    [buttonWorkdays setBackgroundImage:blackImage forState:UIControlStateNormal];
    [buttonWorkdays setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    UIImage *blackImage2 = [[UIImage imageNamed:IMAGE_ROW_SELECTED_GRAY] imageScaledToSize:CGSizeMake(buttonSaturday.frame.size.width, buttonSaturday.frame.size.height)];
    [buttonSaturday setBackgroundImage:blackImage2 forState:UIControlStateNormal];
    [buttonSaturday setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    if (sender)
        [self reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)reloadData
{
    AllRoutesAndStops *aRAS = [AllRoutesAndStops sharedMySingleton];
    scheduleFull = [aRAS getScheduleByRouteId:self.currentRoute.RouteId andStopId:self.currentStop.StopId andDayOfWeek:[NSNumber numberWithInt:dayOfWeek]];
    [scheduleFull retain];
    
    ResultForView *scheduleFull_2 = [aRAS getScheduleByRouteId:self.currentRoute.RouteId andStopId:self.currentStop.StopId andDayOfWeek:[NSNumber numberWithInt:6]];
    ResultForView *scheduleFull_3 = [aRAS getScheduleByRouteId:self.currentRoute.RouteId andStopId:self.currentStop.StopId andDayOfWeek:[NSNumber numberWithInt:7]];
    
    isSaturdayFull = [scheduleFull_2.dictionaryWithSchedule count] == 0 ? NO : YES;
    isSundayFull = [scheduleFull_3.dictionaryWithSchedule count] == 0 ? NO : YES;
    
    isEqualSaturdayAndSunday = [scheduleFull_2.dictionaryWithSchedule isEqualToDictionary:scheduleFull_3.dictionaryWithSchedule];
    
    dictionarySchedule = scheduleFull.dictionaryWithSchedule;
    sortedArrayOfHours = scheduleFull.sortedHours;
    
    [self reloadButtons];
    
    [self createLabelsWithSchedule];
}

- (void)setOpacityToView:(UIView *)viewToChange
{
    viewToChange.layer.opacity = 0.5;
}

- (void)reloadButtons
{
    // если расписание в субботу и воскресенье отличаются, 
    // то вместо кнопки "Выходные дни" появляются две кнопки
    // "Сб" и "Вс". В основном это распространяется на метро, но также актуально и для
    // некоторых других маршрутов.
    
    if (!isEqualSaturdayAndSunday) {
        [buttonSaturday setHidden:NO];
        [buttonSunday setHidden:NO];
        [buttonHolydays setHidden:YES];
    }
    else {
        [buttonSaturday setHidden:YES];
        [buttonSunday setHidden:YES];
        [buttonHolydays setHidden:NO];
    }
    
    if (!isSaturdayFull) {
        [buttonSaturday setEnabled:NO];
        [self setOpacityToView:buttonSaturday];
    }
    if (!isSundayFull) {
        [buttonSunday setEnabled:NO];
        [self setOpacityToView:buttonSunday];
    }
    
}

@end
