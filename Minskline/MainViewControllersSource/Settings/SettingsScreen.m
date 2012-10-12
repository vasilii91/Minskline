//
//  FourthScreen.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 04.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsScreen.h"

@implementation SettingsScreen
@synthesize navigationBar;

@synthesize segmentedControlToInterval, segmentedControlSortType, pickerViewInterval, segmentedIsFavorite, progressView;
@synthesize buttonUpdate, labelUpdateStatus;

- (void)dealloc
{
    [receivedData release];
    [navigationBar release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)getLastDateUpdate
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *urlString = @"http://minskline.by/update/update";
    NSString *urlString2 = @"http://minskline.by/update/update_size";
    
    updateDate = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]encoding:NSUTF8StringEncoding error:nil] retain];
    updateSize = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString2]encoding:NSUTF8StringEncoding error:nil] retain];
    
    currentUpdateDate = [[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_UPDATE_DATE];
    
    NSComparisonResult result = [Schedule compareOneDate:currentUpdateDate withAnother:updateDate];
    
    if (updateDate == nil) {
        labelUpdateStatus.text = @"Сервер недоступен. Проверьте Ваше интернет-соединение";
        [buttonUpdate setEnabled:NO];
    }
    else {
        if (result == -1) {
            // нужно обновлять
            NSString *status = [NSString stringWithFormat:@"У Вас база данных за %@, на данный момент уже доступна база за %@", currentUpdateDate, updateDate];
            labelUpdateStatus.text = status;
            [buttonUpdate setEnabled:YES];
        }
        else {
            labelUpdateStatus.text = @"База данных обновлена";
            [buttonUpdate setEnabled:NO];
            [buttonUpdate setTitle:@"Обновлена" forState:UIControlStateNormal]; 
        }
        
        NSLog(@"%@, %i", updateDate, result);
    }
//    [buttonUpdate setEnabled:YES]; // TODO: temp solution
    
    [pool drain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.topItem.title= @"Настройки";
    UILabel *label = [PrettyViews labelToNavigationBarWithTitle:@"Настройки"];
    self.navigationBar.topItem.titleView = label;
    self.navigationBar.tintColor = NAV_BAR_COLOR;
    
    settings = [SettingsOfMinsktrans sharedMySingleton];
    
    def = [NSUserDefaults standardUserDefaults];
    NSInteger selectedIndex = [[def valueForKey:INTERVAL_INDEX] intValue];
    BOOL isFavorite = [[def valueForKey:IS_FAVORITES_SELECTED] boolValue];
    SortResultTypeEnum sortType = [[def valueForKey:SORT_TYPE] intValue];
    
    [segmentedControlSortType setSelectedSegmentIndex:(int)sortType];
    [self selectSegmentedControlTypeOfSort:nil];
    
    intervals = [[NSArray alloc] initWithObjects:@"5", @"10", @"20", @"30", @"60", nil];
    [segmentedControlToInterval setSelectedSegmentIndex:selectedIndex];
    [segmentedIsFavorite setSelectedSegmentIndex:isFavorite == YES ? 1 : 0];
    [self selectSegmentedControlIsFavorite:nil];
    
    progressView = [[PDColoredProgressView alloc] initWithProgressViewStyle: UIProgressViewStyleDefault];
    [progressView setTintColor: [UIColor redColor]]; //or any other color you like
    [progressView setFrame:CGRectMake(20, 415, 280, 9)];
    [progressView setHidden:YES];
    [self.view addSubview: progressView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self performSelectorInBackground:@selector(getLastDateUpdate) withObject:nil];
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (id)init
{
    // Get the tab bar item
    UITabBarItem *tbi = [self tabBarItem];
    
    // Give it a label
    [tbi setTitle:@"Настройки"];
    
    
    // Create a UIImage from a file
    UIImage *icon = [UIImage imageNamed:@"settings_tab_bar_icon.png"];
    
    // Put that image on the tabBarItem
    [tbi setImage:icon];
    
    return self = [super init];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)selectSegmentedControl:(id)sender
{
    NSInteger intervalFromSegment = [[intervals objectAtIndex:segmentedControlToInterval.selectedSegmentIndex] intValue];
    
    [settings setInterval: intervalFromSegment];
    
    [def setValue:[NSNumber numberWithInt:segmentedControlToInterval.selectedSegmentIndex] forKey:INTERVAL_INDEX];
    [def setValue:[NSNumber numberWithInt:intervalFromSegment] forKey:INTERVAL];
}

-(IBAction)selectSegmentedControlIsFavorite:(id)sender
{
    BOOL isFavorite = segmentedIsFavorite.selectedSegmentIndex;
    
    settings.isFavorite = isFavorite;
    settings.isChangedFromOneToAnother1 = YES;
    settings.isChangedFromOneToAnother2 = YES;
    
    [def setValue:[NSNumber numberWithBool:isFavorite] forKey:IS_FAVORITES_SELECTED];
}

-(IBAction)selectSegmentedControlTypeOfSort:(id)sender
{
    SortResultTypeEnum sortType = segmentedControlSortType.selectedSegmentIndex;
    
    settings.sortResultType = sortType;
    
    NSNumber *n = [NSNumber numberWithInt:(int)sortType];
    [def setValue:n forKey:SORT_TYPE];
}

- (void)creatingConnection
{
    NSString *pathToFile = @"http://minskline.by/update/Minsktrans.sqlite";
    // Create the request.
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:pathToFile]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [[NSMutableData data] retain];
    } else {
        // Inform the user that the connection failed.
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
    
//    (float)((1.0f / (float)countOfURLs) * 100.0f)
    
    float persentage = (float)((float)[receivedData length] / 9800000.0f);
    [progressView setProgress:persentage];
    
//    NSLog(@"%i", [receivedData length]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)updateDAtabaseStatus
{
    
}

+ (NSString *) pathForDocuments
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    NSString *databaseName = @"Minskline.sqlite";
    
    NSString *path = [NSString stringWithFormat:@"%@", [SettingsScreen pathForDocuments]];
    path = [path stringByAppendingFormat:@"/%@", databaseName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err;
    [fileManager removeItemAtPath:path error:nil];
    [receivedData writeToFile:path atomically:YES];
    
    [[NSUserDefaults standardUserDefaults] setValue:updateDate forKey:CURRENT_UPDATE_DATE];
    
    [connection release];
    [receivedData release];
    AllRoutesAndStops *aRAS = [AllRoutesAndStops sharedMySingleton];
    [aRAS saveFavoritiesRoutesAndStops];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Обновление завершено" message:@"Для того, чтобы обновление вступило в силу, Вам необходимо перезагрузить Minskline" delegate:self cancelButtonTitle:nil otherButtonTitles: @"Хорошо", nil];
    [alertView show];
    [alertView release];
    [progressView setHidden:YES];
    [buttonUpdate setEnabled:NO];
    labelUpdateStatus.text = @"База данных обновлена";
}

-(IBAction)updateDatabase:(id)sender
{
    updateSize = updateSize == nil ? @"10" : updateSize;
    
    NSString *text = [NSString stringWithFormat:@"Вы собираетесь скачать обновление с официального сайта (%@ мб). Желаете продолжить?", updateSize];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Обновление" message:text delegate:self cancelButtonTitle:nil otherButtonTitles:@"Нет", @"Да", nil];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self creatingConnection];
        [buttonUpdate setEnabled:NO];
        [progressView setHidden:NO];
    }
}



@end
