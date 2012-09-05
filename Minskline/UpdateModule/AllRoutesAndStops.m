
//
//  AllRoutes.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 31.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AllRoutesAndStops.h"

@interface AllRoutesAndStops (Private)
-(void)getAllRoutesFromURLAsynchronous;
-(void)getInfoAboutAllStopsAndSaveToDatabase;
-(void)showProgress;
-(void)setStatus:(NSNumber*)percent;
-(NSMutableString *)deleteNotNeedElements:(NSString*)fromItString andDeletingString:(NSString*)deletingString;
-(void)addStopToDatabase:(MStop *)stop;
-(void)addRouteToDatabase:(MRouteWithSchedule *)route;
-(void)addScheduleToDatabase:(MRouteWithSchedule *)schedule;

-(Routes *)getRouteById:(NSNumber *)routeId;
-(Times *)getScheduleByRouteIdAndStopId:(NSNumber *)routeId andStopId:(NSNumber *)stopId dayOfWeek:(NSNumber *)dayOfWeek;
-(NSNumber *)getCurrentDayOfWeek;
-(NSMutableArray *)sortArray:(NSMutableArray *)arrayToSort;
-(void)initializeArrays;
-(void)deallocInitializedArrays;
@end

static NSString* PERCENTAGE = @"Percentage";
static NSString *IS_INITIALIZED_ARRAYS = @"Is_initialized_arrays";

@implementation AllRoutesAndStops

// Synthesizing properties
@synthesize managedObjectContext;

static AllRoutesAndStops * _sharedMySingleton = nil;

static void singleton_remover()
{
    if (_sharedMySingleton) {
        [_sharedMySingleton release];
    }
}

+ (AllRoutesAndStops *) sharedMySingleton
{
    @synchronized(self)
    {
        if (!_sharedMySingleton) {
            _sharedMySingleton = [[AllRoutesAndStops alloc] init];
            _sharedMySingleton->allStopsFromDatabase = [[NSMutableArray alloc] init];
            _sharedMySingleton->allStopNamesFromDatabase = [[NSMutableArray alloc] init];
            _sharedMySingleton->allRoutesFromDatabase = [[NSMutableArray alloc] init];
            _sharedMySingleton->busNumbers = [[NSArray alloc] init];
            _sharedMySingleton->trolleybusNumbers = [[NSArray alloc] init];
            _sharedMySingleton->tramwayNumbers = [[NSArray alloc] init];
            _sharedMySingleton->metroNumbers = [[NSArray alloc] init];
            _sharedMySingleton->setBusNumbers = [[NSMutableSet alloc] init];
            _sharedMySingleton->setTrolleybusNumbers = [[NSMutableSet alloc] init];
            _sharedMySingleton->setTramwayNumbers = [[NSMutableSet alloc] init];
            _sharedMySingleton->setMetroNumbers = [[NSMutableSet alloc] init];
            // release instance at exit
            atexit(singleton_remover);
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:NO_AS_STRING forKey:IS_INITIALIZED_ARRAYS];
        }
    }
    
    return _sharedMySingleton;
}

-(void)dealloc
{
    [allStopsFromDatabase release];
    [allStopNamesFromDatabase release];
    [super dealloc];
}

-(void)initializeArrays
{
    mutableArray01_ID = [[NSMutableArray alloc] init];
    mutableArray02_City = [[NSMutableArray alloc] init];
    mutableArray03_Area = [[NSMutableArray alloc] init];
    mutableArray04_Street = [[NSMutableArray alloc] init];
    mutableArray05_Name = [[NSMutableArray alloc] init];
    mutableArray06_Info = [[NSMutableArray alloc] init];
    mutableArray07_Longitude = [[NSMutableArray alloc] init];
    mutableArray08_Latitude = [[NSMutableArray alloc] init];
    mutableArray09_Stops = [[NSMutableArray alloc] init];
}

-(void)deallocInitializedArrays
{
    [mutableArray01_ID release];
    [mutableArray02_City release];
    [mutableArray03_Area release];
    [mutableArray04_Street release];
    [mutableArray05_Name release];
    [mutableArray06_Info release];
    [mutableArray07_Longitude release];
    [mutableArray08_Latitude release];
    [mutableArray09_Stops release];
}

-(void)setIsUserClickedOnStopButtonWhenUpdate:(BOOL)isClicked
{
    _sharedMySingleton->isUserClickedOnStopButtonWhenUpdate = isClicked;
}

-(NSMutableString*)deleteNotNeedElements:(NSString *)fromItString andDeletingString:(NSString *)deletingString
{
    NSMutableString *temp = [NSMutableString stringWithString: fromItString];
    NSRange deletingRange = [temp rangeOfString: deletingString];
    if (deletingRange.location != 2147483647) {
        [temp deleteCharactersInRange: deletingRange];
    }
    return temp;
}

-(void)getAllRoutesFromURLAsynchronous
{
    NSLog(@"START");
    
    [self initializeArrays];
    isUserClickedOnStopButtonWhenUpdate = NO;
    isExistNetworkConnection = NO;
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    // get info about all stops from core-URL
    [self getInfoAboutAllStopsAndSaveToDatabase];
    
    // с - \U0441
    // д - \U0434
    // т - \U0442
    // э - \U044d
    // в - \U0432
    // г - \U0433
    // а - \U0430 
    // б - \U0431
    // A memory will be clear automatically because we don't use alloc and init
    NSArray* letters = [NSArray arrayWithObjects:@"а", @"б", @"в", @"г", 
                                                @"д", @"с", @"т", @"э", nil];
    NSArray* unicodeLetters = [NSArray arrayWithObjects:@"U0430", @"U0431", @"U0432", @"U0433", 
                               @"U0434", @"U0441", @"U0442", @"U044d", nil];
    
    NSDictionary *dictionaryWithLetters = [NSDictionary dictionaryWithObjects:letters forKeys:unicodeLetters];

    
    NSString *urlString = @"http://www.minsktrans.by/city/minsk/routes.txt";
    NSMutableDictionary *dictionaryOfHeaders = [[NSMutableDictionary alloc] init];
    
    NSString *webpage = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]encoding:NSUTF8StringEncoding error:nil];
    
	NSArray *lines = [webpage componentsSeparatedByString: @"\n"];
    
    if ([lines count] != 0) {
        NSArray *headers = [[lines objectAtIndex:0] componentsSeparatedByString:@";"];
        
        for (int i = 0; i < 15; i++) {
            isExistNetworkConnection = YES;
            NSString *line = [headers objectAtIndex:i];
            NSNumber *number = [NSNumber numberWithInt: i + 1];
            [dictionaryOfHeaders setObject:line forKey:number];
//            [line release];
//            [number release];
        }

        int i;
        NSString* previousRouteNumber = nil;
        NSString* routeNumber = nil;
        NSString* typeOfTransport = nil;
        NSString *typeOfTransport0 = nil;
        TypeOfTransportEnum typeOfTransportEnum;
        NSString* operator = nil;
        NSString* validityPeriod = nil;
        NSString* routeType = nil;
        NSString* routeId = nil;
        
        MRouteWithSchedule *mRoute = [MRouteWithSchedule newMRoute];
        
        NSInteger countOfProceededURLs = 0;
        
        for (i = 1; i < [lines count]; i++)
        {
            NSString *oneRouteString = [lines objectAtIndex:i];
            NSArray *oneRouteArray = [oneRouteString componentsSeparatedByString:@";"];
            
            routeNumber = [oneRouteArray objectAtIndex:0];
            
            if ([routeNumber isEqual:@""]) {
                routeNumber = previousRouteNumber;
            }
            else {
                previousRouteNumber = routeNumber;
            }
            
            NSUInteger backslashLocation = [previousRouteNumber rangeOfString:@"U"].location;
            if (backslashLocation != NSIntegerMax) {
                NSMutableString* correctRouteNumber = [NSMutableString stringWithString:[previousRouteNumber substringToIndex:backslashLocation - 1]]; 
                NSString* unicodeLetter = [previousRouteNumber substringFromIndex: backslashLocation];
                [correctRouteNumber appendFormat:@"%@%@", correctRouteNumber, [dictionaryWithLetters objectForKey:unicodeLetter]];
                [unicodeLetter release];
                previousRouteNumber = correctRouteNumber;
            }

            //----------------------------------------------//
            mRoute->transportNumber = previousRouteNumber;
            //----------------------------------------------//
            
            // get type of transport. Words "bus", "tram", "metro", "trol" meet once in source.
            
            NSString *temp = [oneRouteArray objectAtIndex:3];
            if (![temp isEqualToString:@""]) {
                typeOfTransport0 = temp;
            }
            
            if ([typeOfTransport0 isEqualToString:@"bus"]) {
                typeOfTransport = @"Autobus";
                typeOfTransportEnum = BUS;
            }
            else if ([typeOfTransport0 isEqualToString:@"tram"]) {
                typeOfTransport = @"Tramway";
                typeOfTransportEnum = TRAMWAY;
            }
            else if ([typeOfTransport0 isEqualToString:@"trol"]) {
                typeOfTransport = @"Trolleybus";
                typeOfTransportEnum = TROLLEYBUS;
            }
            else if ([typeOfTransport0 isEqualToString:@"metro"]) {
                typeOfTransport = @"Metro";
                typeOfTransportEnum = METRO;
            }
            
            //----------------------------------------------//
            mRoute->typeOfTransport = typeOfTransportEnum;
            //----------------------------------------------//
            
            operator = [oneRouteArray objectAtIndex:4];
            validityPeriod = [oneRouteArray objectAtIndex:5];
            
            routeType = [oneRouteArray objectAtIndex:8];
            routeType = [routeType stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
            
            NSString* routeNameInUnicode = [oneRouteArray objectAtIndex:10];
            
            //----------------------------------------------//
            [mRoute setRouteName: routeNameInUnicode];
            //----------------------------------------------//
            
            NSString* weekdays = [oneRouteArray objectAtIndex:11];
            NSMutableArray* weekdaysAsArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < [weekdays length]; i++) {
                NSString* weekday = [NSString stringWithFormat:@"%C",[weekdays characterAtIndex:i]];
                [weekdaysAsArray addObject:weekday];
            }
            
            routeId = [oneRouteArray objectAtIndex:12];
            
            //----------------------------------------------//
            mRoute->routeId = [routeId intValue];
            //----------------------------------------------//
            
            NSString* routeStops = [oneRouteArray objectAtIndex:14];
            NSArray* routeStopsAsArray = [routeStops componentsSeparatedByString:@","];
            
            // Need only Monday-schedule, Saturday-schedule and Sunday-schedule
            NSMutableArray* newWeekdaysAsArray = [[NSMutableArray alloc] init];
            for (NSString* weekday in weekdaysAsArray) {
                if ([weekday isEqualToString:@"1"] ||
                    [weekday isEqualToString:@"2"] ||
                    [weekday isEqualToString:@"3"] ||
                    [weekday isEqualToString:@"4"] ||
                    [weekday isEqualToString:@"5"]) {
                    
                    [newWeekdaysAsArray addObject:@"1"];
                    break;
                }
            }
            for (NSString* weekday in weekdaysAsArray) {
                if ([weekday isEqualToString:@"6"]) {
                    
                    [newWeekdaysAsArray addObject:@"6"];
                }
                else if ([weekday isEqualToString:@"7"]) {
                    [newWeekdaysAsArray addObject:@"7"];
                    break;
                }
            }
            
            for (NSString* stopId in routeStopsAsArray) {
                for (NSString* weekday in newWeekdaysAsArray) {
                    NSString *stopURL = [NSString stringWithFormat: @"http://www.minsktrans.by/pda/index.php?RouteNum=%@&StopID=%@&RouteType=%@&day=%@&Transport=%@", previousRouteNumber, stopId, routeType, weekday, typeOfTransport];
                    //----------------------------------------------//
                    mRoute->dayOfWeek = [weekday intValue];
                    mRoute->stopId = [stopId intValue];
                    //----------------------------------------------//
                    NSString* escapedStopURL = [stopURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    Schedule *schedule = [[Schedule alloc] init];
                    [schedule getScheduleFromURL:escapedStopURL];
                    
                    //----------------------------------------------//
                    mRoute.schedule = [schedule schedule];
                    mRoute->scheduleInStringFormat = [schedule scheduleInStringFormat];
                    //----------------------------------------------//

                    // add schedule to database
                    [self addScheduleToDatabase:mRoute];
                    
                    [schedule release];
                    
                    countOfProceededURLs++;
                }
            }
            
            //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
            [self addRouteToDatabase:mRoute];
            NSLog(@"schedules - %i, URLs - %i", counter++, countOfProceededURLs);
            
            [weekdaysAsArray release];
            [newWeekdaysAsArray release];
            [routeStopsAsArray release];
        }

        [mRoute release];
        [previousRouteNumber release];
        [routeNumber release];
        [typeOfTransport release];
        [operator release];
        [validityPeriod release];
        [routeType release];
        [routeId release];
    }
    
    [dictionaryOfHeaders release];
    [pool drain];
    
    [self deallocInitializedArrays];
    
    NSLog(@"FINISH");
}

-(void)getInfoAboutAllStopsAndSaveToDatabase
{
    NSString *urlString = @"http://www.minsktrans.by/city/minsk/stops.txt";
    NSMutableDictionary *dictionaryOfHeaders = [[NSMutableDictionary alloc] init];
    
    NSString *webpage = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]encoding:NSUTF8StringEncoding error:nil];
    
	NSArray *allStops = [webpage componentsSeparatedByString: @"\n"];
    
    if ([allStops count] != 0) {
        NSArray *line = [[allStops objectAtIndex:0] componentsSeparatedByString:@";"];
        for (int i = 1; i < [line count]; i++) {
            NSNumber *number = [NSNumber numberWithInt: i];
            [dictionaryOfHeaders setObject:[line objectAtIndex:i - 1] forKey:number];
        }
        
        NSString *ID = nil;
        NSString *city = nil;
        NSString *area = nil;
        NSString *street = nil;
        NSString *name = nil;
        NSString *info = nil;
        NSString *longitude = nil;
        NSString *latitude = nil;
//        NSArray *stopIds = nil;
        
        MStop *oneStop = [[MStop alloc] init];
        
        for (int i = 1; i <= [allStops count]; i++) {
            isExistNetworkConnection = YES;
            
            if (i >= [allStops count])
                break;
            
            NSArray *stopAsArray = [[allStops objectAtIndex:i] componentsSeparatedByString:@";"];
            if ([stopAsArray count] != 10)
                break;
            int k = 0;
            
            ID = [stopAsArray objectAtIndex:k++];
            [mutableArray01_ID addObject:ID];
            
            city = [stopAsArray objectAtIndex:k++];
            [mutableArray02_City addObject:city];
            
            area = [stopAsArray objectAtIndex:k++];
            [mutableArray03_Area addObject:area];
            
            street = [stopAsArray objectAtIndex:k++];
            [mutableArray04_Street addObject:street];
            
            NSString *tempName = [stopAsArray objectAtIndex:k++];
            name = [tempName isEqualToString:@""] ? name : tempName;;
            [mutableArray05_Name addObject:name];
            
            info = [stopAsArray objectAtIndex:k++];
            [mutableArray06_Info addObject:info];
            
            longitude = [stopAsArray objectAtIndex:k++];
            [mutableArray07_Longitude addObject:longitude];
            
            latitude = [stopAsArray objectAtIndex:k++];
            [mutableArray08_Latitude addObject:latitude];
            
            //----------------------------------------------//
            oneStop->stopId = [NSNumber numberWithInt: [ID intValue]];
            oneStop->stopName = name;
            oneStop->latitude = [NSNumber numberWithInt: [latitude intValue]];
            oneStop->longitude = [NSNumber numberWithInt: [longitude intValue]];
            
            [self addStopToDatabase:oneStop];
            [self showProgress];
            if (isUserClickedOnStopButtonWhenUpdate == YES) {
                [oneStop release];
                [dictionaryOfHeaders release];
                return;
            }
            //----------------------------------------------//
            
//            // equivalents of stopId
//            stopIds = [[stopAsArray objectAtIndex:k++] componentsSeparatedByString:@","];
//            [mutableArray09_Stops addObject:stopIds];
//            
//            //----------------------------------------------//
//            for (NSString *stopId in stopIds) {
//                oneStop->stopId = [NSNumber numberWithInt: [stopId intValue]];
//                
//                [self addStopToDatabase:oneStop];
//            }
//            //----------------------------------------------//
        }
        
        [oneStop release];
    }
    [dictionaryOfHeaders release];
}

-(void)showProgress
{
    // count of all urls with 1, 6, 7 - days
    int countOfURLs = 29009 + 2555; 

    float percent = (float)((1.0f / (float)countOfURLs) * 100.0f);
    NSNumber* percentage = [[NSNumber alloc] initWithFloat: (float)(percent)];
    [self performSelectorOnMainThread:@selector(setStatus:) withObject: percentage waitUntilDone:NO];
    [percentage release];
    
    if (isUserClickedOnStopButtonWhenUpdate == YES)
    {
        NSNumber *error = [[NSNumber alloc] initWithFloat:(float)(-2.0f)];
        [self performSelectorOnMainThread:@selector(setStatus:) withObject:error waitUntilDone:NO];
        [error release];
    }
    if (isExistNetworkConnection == NO)
    {
        NSNumber* error = [[NSNumber alloc] initWithFloat: (float)(-1.0f)];
        [self performSelectorOnMainThread:@selector(setStatus:) withObject:error waitUntilDone:NO];
        [error release];
    }
}

-(void)setStatus:(NSNumber*)percent
{
    float percentFloat = [percent floatValue];
    totalPercent += percentFloat;
    
    NSError* error = nil;
    
    if ( error == nil ) 
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:PERCENTAGE object:percent];
    } 
}

-(void)getAllRoutes
{
    [self performSelectorOnMainThread:@selector(getAllRoutesFromURLAsynchronous) withObject:nil waitUntilDone:YES];
//    [self performSelectorInBackground:@selector(getAllRoutesFromURLAsynchronous) withObject:nil];
    
}

-(void)addRouteToDatabase:(MRouteWithSchedule *)route
{
    Routes *routesEntity = (Routes *)[NSEntityDescription insertNewObjectForEntityForName: @"Routes" inManagedObjectContext: managedObjectContext];
    
    // saving one Routes-entity
    NSNumber *routeIdNumber = [NSNumber numberWithInt: route->routeId];
    routesEntity.RouteId = routeIdNumber;
    routesEntity.RouteName = [route routeName];
    routesEntity.StartName = [route nameOfStartStop];
    routesEntity.EndName = [route nameOfEndStop];
    routesEntity.TransportNumber = route->transportNumber;
    routesEntity.TypeOfTransport = [NSNumber numberWithInt: (int)route->typeOfTransport];
    
    [managedObjectContext save:nil];
}

-(void)addScheduleToDatabase:(MRouteWithSchedule *)schedule
{
    RoutesStops *routesStopsEntity = (RoutesStops *)[NSEntityDescription insertNewObjectForEntityForName:@"RoutesStops" inManagedObjectContext: managedObjectContext];
    
    // saving one Routes-entity
    NSNumber *routeIdNumber = [NSNumber numberWithInt: schedule->routeId];
    
    // saving one RoutesStops-entity
    NSNumber *stopIdNumber = [NSNumber numberWithInt: schedule->stopId];
    NSNumber *routeStopIdNumber = [NSNumber numberWithInt:counterRouteStopId++];
    routesStopsEntity.RouteId = routeIdNumber;
    routesStopsEntity.StopId = stopIdNumber;
    routesStopsEntity.RouteStopId = routeStopIdNumber;
    
    if (currentRouteId != [routeIdNumber intValue]) {
        currentRouteId = [routeIdNumber intValue];
        ordinalNumberOfStopInRoute = 0;
    }
    
    NSNumber *ordinalNumber = [NSNumber numberWithInt:ordinalNumberOfStopInRoute];
    routesStopsEntity.OrdinalNumberOfStopInRoute = ordinalNumber;
    ordinalNumberOfStopInRoute++;
    
    counterHelperIdTimes++;
    Times *timesEntity = (Times *)[NSEntityDescription insertNewObjectForEntityForName:@"Times" inManagedObjectContext: managedObjectContext];
    timesEntity.HelperId = [NSNumber numberWithInt:counterHelperIdTimes];
    timesEntity.RouteStopId = routeStopIdNumber;
    timesEntity.DayOfWeek = [NSNumber numberWithInt: schedule->dayOfWeek];
    timesEntity.Time = schedule->scheduleInStringFormat;

    [managedObjectContext save:nil];
}

-(void)addStopToDatabase:(MStop *)stop
{
    Stops *stopsEntity = (Stops *)[NSEntityDescription insertNewObjectForEntityForName:@"Stops" inManagedObjectContext:managedObjectContext];
    
    stopsEntity.StopId = stop->stopId;
    stopsEntity.StopName = stop->stopName;
    stopsEntity.Latitude = stop->latitude;
    stopsEntity.Longitude = stop->longitude;
    
    [managedObjectContext save:nil];
}

-(NSMutableArray *)getAllStopsFromDatabase
{
    if ([allStopsFromDatabase count] == 0) 
    {
        NSFetchRequest *requestToStops = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entityDescriptionToStops = [NSEntityDescription entityForName:@"Stops" inManagedObjectContext:managedObjectContext];
        [requestToStops setEntity:entityDescriptionToStops];

//        NSPredicate *predicateToStops = [NSPredicate predicateWithFormat:@"StopId > %@", [NSNumber numberWithInt:0]];
//        [requestToStops setPredicate:predicateToStops];

        NSSortDescriptor *descriptorToStops = [[NSSortDescriptor alloc] initWithKey:@"StopName" ascending:YES];
        [requestToStops setSortDescriptors:[NSArray arrayWithObject:descriptorToStops]];
        [descriptorToStops release];


        NSError *error = nil;   
        NSArray *array = [managedObjectContext executeFetchRequest:requestToStops error:&error];

        NSString *previousStopName = @"";
        NSInteger previousStopId = 0;
        for (Stops *stop in array)
        {
            if (![stop.StopName isEqualToString:previousStopName])           
            {
                previousStopName = stop.StopName;
                [allStopNamesFromDatabase addObject:stop.StopName];
            }
            if ([stop.StopId intValue] != previousStopId) {
                [allStopsFromDatabase addObject: stop];
            }
                
//            NSLog(@"StopName = %@, StopId = %d, Latitude = %d, Longitude = %d", (NSString *)stop.StopName, [stop.StopId intValue], [stop.Latitude intValue], [stop.Longitude intValue]);
        }    
    }
    
    return allStopsFromDatabase;
}

- (NSMutableArray *)getFavoriteStopsFromDatabase
{
    NSError *error = nil;
    
    NSFetchRequest *requestToRoutes = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDescriptionToRoutes= [NSEntityDescription entityForName:@"Stops" inManagedObjectContext: managedObjectContext];
    [requestToRoutes setEntity:entityDescriptionToRoutes];
    
    NSPredicate *predicateToRoutes = nil;
    predicateToRoutes = [NSPredicate predicateWithFormat:@"isSelected == %@", [NSNumber numberWithInt:1]];
    [requestToRoutes setPredicate:predicateToRoutes];
    
    NSSortDescriptor *descriptorToRoutes = [[NSSortDescriptor alloc] initWithKey:@"StopName" ascending:YES];
    [requestToRoutes setSortDescriptors:[NSArray arrayWithObject:descriptorToRoutes]];
    [descriptorToRoutes release];
    
    //-----NSArray<Routes>-----
    NSArray *resultFromDatabase = [managedObjectContext executeFetchRequest:requestToRoutes error:&error];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSMutableSet *setOfStops = [[NSMutableSet alloc] init];
    for (Stops *stop in resultFromDatabase) {
        [setOfStops addObject:stop.StopName];
        BOOL isInside = NO;
        for (Stops *routeInResult in result) {
            if ([stop.StopName isEqualToString:routeInResult.StopName]) {
                isInside = YES;
            }
        }
        if (!isInside) {
            [result addObject:stop];
        }
    }
    [setOfStops release];
    
    return [result autorelease];
}

///////////---NSMutableArray<NSNumber>---///////////
-(NSMutableArray *)getStopIdsByName:(NSString *)stopName
{
    NSMutableArray *arrayOfPossibleStopIds = [[NSMutableArray alloc] init];
    for (Stops *stop in allStopsFromDatabase) {
        if ([stop.StopName rangeOfString:stopName].location == 0 && [stop.StopName length] == [stopName length]) {
            NSNumber *stopIdNumber = stop.StopId;
            [arrayOfPossibleStopIds addObject:stopIdNumber];
        }
    }   
    
    return [arrayOfPossibleStopIds autorelease];
}

-(NSMutableArray *)getStopsByName:(NSString *)stopName
{
    NSMutableArray *arrayOfPossibleStops = [[NSMutableArray alloc] init];
    for (Stops *stop in allStopsFromDatabase) {
        if ([stop.StopName rangeOfString:stopName].location == 0 && [stop.StopName length] == [stopName length]) {
            [arrayOfPossibleStops addObject:stop];
        }
    }   
    
    return [arrayOfPossibleStops autorelease];
}

-(NSMutableArray *)getAllStopsByPatternOrByFirstLetter:(BOOL)isByLetter patternOfFirstLetter:(NSString *)patternOrFirstLetter
{
    [self getAllStopsFromDatabase];
    
    NSMutableArray *resultStops = [[NSMutableArray alloc] init];
    for (NSString *stopName in allStopNamesFromDatabase)
    {
//        NSMutableString *stopNameMutable = [NSString stringWithString: stopName];
        NSRange rangeOfPattern = [stopName rangeOfString:patternOrFirstLetter];
        if (rangeOfPattern.location != NSIntegerMax)
        {
            [resultStops addObject:stopName];
        }
//        [stopNameMutable release];
    }
    
    return [resultStops autorelease];
}

-(NSArray*)getAllRoutesByTypeOfTransport:(TypeOfTransportEnum)typeOfTransport
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([allRoutesFromDatabase count] == 0)
    {
        NSError *error = nil;

        NSFetchRequest *requestToRoutes = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entityDescriptionToRoutes= [NSEntityDescription entityForName:@"Routes" inManagedObjectContext: managedObjectContext];
        [requestToRoutes setEntity:entityDescriptionToRoutes];
        NSDictionary *entityProperties = [entityDescriptionToRoutes propertiesByName];
        [requestToRoutes setReturnsDistinctResults:NO];
        [requestToRoutes setPropertiesToFetch:[NSArray arrayWithObject:[entityProperties objectForKey:@"RouteId"]]];
        
        //-----NSArray<Routes>-----
        allRoutesFromDatabase = [managedObjectContext executeFetchRequest:requestToRoutes error:&error];
        [allRoutesFromDatabase retain];
    }
    
    NSString *currentState = [userDefaults valueForKey:IS_INITIALIZED_ARRAYS];
    BOOL isInitialized = [currentState isEqualToString:YES_AS_STRING];
    if (!isInitialized) {
        [userDefaults setValue:YES_AS_STRING forKey:IS_INITIALIZED_ARRAYS];
        for (Routes *route in allRoutesFromDatabase) {
//            NSLog(@"%i -- %@ -- %@ -- %@", [route.RouteId intValue], route.TypeOfTransport, route.TransportNumber, route.RouteName);
            switch ([route.TypeOfTransport intValue]) {
                case BUS:
                    [setBusNumbers addObject: route.TransportNumber];
                    break;
                case TROLLEYBUS:
                    [setTrolleybusNumbers addObject: route.TransportNumber];
                    break;
                case TRAMWAY:
                    [setTramwayNumbers addObject: route.TransportNumber];
                    break;
                case METRO:
                    [setMetroNumbers addObject:route.TransportNumber];
                    break;
                default:
                    break;
            }
        }
        [userDefaults setValue:IS_INITIALIZED_ARRAYS forKey:YES_AS_STRING];
    }

    NSLog(@"Bus - %i, Trolleybus - %i, Tramway - %i, Metro - %i", [setBusNumbers count], [setTrolleybusNumbers count], [setTramwayNumbers count], [setMetroNumbers count]);
    
    NSComparisonResult (^sortBlock)(id, id) = ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) { 
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return [obj1 compare:obj2];
    };
    
    
    switch (typeOfTransport) {
        case BUS:
        {
            if ([busNumbers count] == 0) {
                busNumbers = [setBusNumbers allObjects];
                busNumbers = [busNumbers sortedArrayUsingComparator:sortBlock];
            }
            return busNumbers;
        }
        case TROLLEYBUS:
        {
            if ([trolleybusNumbers count] == 0) {
                trolleybusNumbers = [setTrolleybusNumbers allObjects];
                trolleybusNumbers = [trolleybusNumbers sortedArrayUsingComparator:sortBlock];
            }
            return trolleybusNumbers;
        }
        case TRAMWAY:
        {
            if ([tramwayNumbers count] == 0) {
                tramwayNumbers = [setTramwayNumbers allObjects];
                tramwayNumbers = [tramwayNumbers sortedArrayUsingComparator:sortBlock];
            }
            return tramwayNumbers;
        }
        case METRO:
        {
            if ([metroNumbers count] == 0) {
                metroNumbers = [setMetroNumbers allObjects];
            }
            return metroNumbers;
        }
        default:
            return nil;
    }
    
    return nil;
}

-(NSMutableArray *)getAllRoutesByTypeAndNumberOfTransport:(TypeOfTransportEnum)typeOfTransport andNumber:(NSString *)numberOfTransport
{
    NSError *error = nil;
    
    NSFetchRequest *requestToRoutes = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDescriptionToRoutes= [NSEntityDescription entityForName:@"Routes" inManagedObjectContext: managedObjectContext];
    [requestToRoutes setEntity:entityDescriptionToRoutes];
    
    NSNumber *typeOfTransportN = [NSNumber numberWithInt:typeOfTransport];
    if ([numberOfTransport isEqualToString:@"Автозаводская линия"]) {
        numberOfTransport = @"M2";
    }
    else if ([numberOfTransport isEqualToString:@"Московская линия"]) {
        numberOfTransport = @"M1";
    }
    
    NSPredicate *predicateToRoutes = [NSPredicate predicateWithFormat:@"TypeOfTransport == %@ && TransportNumber == %@", typeOfTransportN, numberOfTransport];
    [requestToRoutes setPredicate:predicateToRoutes];
    
    NSSortDescriptor *descriptorToRoutes = [[NSSortDescriptor alloc] initWithKey:@"TransportNumber" ascending:YES];
    [requestToRoutes setSortDescriptors:[NSArray arrayWithObject:descriptorToRoutes]];
    [descriptorToRoutes release];
    
    //-----NSArray<Routes>-----
    NSArray *resultFromDatabase = [managedObjectContext executeFetchRequest:requestToRoutes error:&error];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (Routes *route in resultFromDatabase) {
        BOOL isInside = NO;
        for (Routes *routeInResult in result) {
            if ([route.RouteId intValue] == [routeInResult.RouteId intValue]) {
                isInside = YES;
            }
        }
        if (!isInside) {
            [result addObject:route];
        }
    }
    
//    for (Routes *route in result) {
//        NSLog(@"%i, %@, %i, %i", [route.RouteId intValue], route.RouteName, [route.TransportNumber intValue], [route.TypeOfTransport intValue]);
//    }
    
    return [result autorelease];
}

-(NSMutableArray *)getAllFavoritiesRoutes:(TypeOfTransportEnum)typeOfTransport
{
    NSError *error = nil;
    
    NSFetchRequest *requestToRoutes = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDescriptionToRoutes= [NSEntityDescription entityForName:@"Routes" inManagedObjectContext: managedObjectContext];
    [requestToRoutes setEntity:entityDescriptionToRoutes];
    
    NSPredicate *predicateToRoutes = nil;
    if (typeOfTransport == FAVORITIES) {
        predicateToRoutes = [NSPredicate predicateWithFormat:@"isSelected == %@", [NSNumber numberWithInt:1]];
    }
    else {
        predicateToRoutes = [NSPredicate predicateWithFormat:@"isSelected == %@ && TypeOfTransport == %@", [NSNumber numberWithInt:1], [NSNumber numberWithInt:typeOfTransport]];
    }
    [requestToRoutes setPredicate:predicateToRoutes];
    
    NSSortDescriptor *descriptorToRoutes = [[NSSortDescriptor alloc] initWithKey:@"TransportNumber" ascending:YES];
    [requestToRoutes setSortDescriptors:[NSArray arrayWithObject:descriptorToRoutes]];
    [descriptorToRoutes release];
    
    //-----NSArray<Routes>-----
    NSArray *resultFromDatabase = [managedObjectContext executeFetchRequest:requestToRoutes error:&error];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (Routes *route in resultFromDatabase) {
        BOOL isInside = NO;
        for (Routes *routeInResult in result) {
            if ([route.RouteId intValue] == [routeInResult.RouteId intValue]) {
                isInside = YES;
            }
        }
        if (!isInside) {
            [result addObject:route];
        }
    }
    
//    for (Routes *route in result) {
//        NSLog(@"%i, %@, %i, %i", [route.RouteId intValue], route.RouteName, [route.TransportNumber intValue], [route.TypeOfTransport intValue]);
//    }
    
    return [result autorelease];
}

-(NSMutableArray *)getAllStopsByRoute:(Routes *)route
{
    NSError *error = nil;
    
    NSMutableArray *allStopsByRoute = [[NSMutableArray alloc] init];
    
    NSFetchRequest *requestToRoutesStopsId = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDescriptionToRoutesStopsId = [NSEntityDescription entityForName:@"RoutesStops" inManagedObjectContext: managedObjectContext];
    [requestToRoutesStopsId setEntity:entityDescriptionToRoutesStopsId];
    
    NSPredicate *predicateToRoutesStopsId = [NSPredicate predicateWithFormat:@"RouteId == %@", [NSNumber numberWithInt:[route.RouteId intValue]]];
    [requestToRoutesStopsId setPredicate:predicateToRoutesStopsId];
    
//    NSSortDescriptor *descriptorToRoutesStops = [[NSSortDescriptor alloc] initWithKey:@"OrdinalNumberOfStopInRoute" ascending:YES];
//    [requestToRoutesStopsId setSortDescriptors:[NSArray arrayWithObject:descriptorToRoutesStops]];
//    [descriptorToRoutesStops release];
    
    //-----NSArray<RouteStops>-----
    NSArray *stopsByRoute  = [managedObjectContext executeFetchRequest:requestToRoutesStopsId error:&error];
    [stopsByRoute retain];
    
    // каждый элемент повторяется по три раза, нужно удалить 2 из них, можно взять только
    // каждый третий:)
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSMutableArray *stopsResult = [[NSMutableArray alloc] init];
    for (int i = 0; i < [stopsByRoute count]; i+=1) {
        RoutesStops *routeStop = [stopsByRoute objectAtIndex:i];
        NSNumber *stopId = routeStop.StopId;
        BOOL isInside = NO;
        for (int i = 0; i < [tempArray count]; i++) {
            if ([[tempArray objectAtIndex:i] intValue] == [stopId intValue]) {
                isInside = YES;
                break;
            }
        }
        if (!isInside) {
            [tempArray addObject:stopId];
            [stopsResult addObject: routeStop];
        }
    }
    [tempArray release];
    [stopsByRoute release];
    //        for (RoutesStops *routeStop in stopsResult) {
    //            NSLog(@"%i, %i, %i", [routeStop.OrdinalNumberOfStopInRoute intValue], [routeStop.RouteId intValue], [routeStop.StopId intValue]);
    //        }
    
    for (RoutesStops *routeStop in stopsResult) {
        NSFetchRequest *requestToStops = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entityDescriptionToStops = [NSEntityDescription entityForName:@"Stops" inManagedObjectContext: managedObjectContext];
        [requestToStops setEntity:entityDescriptionToStops];
        
        NSPredicate *predicateToStops = [NSPredicate predicateWithFormat:@"StopId == %@", [NSNumber numberWithInt:[routeStop.StopId intValue]]];
        [requestToStops setPredicate:predicateToStops];
        
        //-----NSArray<Stops>-----
        NSArray *stopsByStopId  = [managedObjectContext executeFetchRequest:requestToStops error:&error];
        [stopsByStopId retain];
        
        for (Stops *stop in stopsByStopId) {
//            NSLog(@"%i, %@, %i, %i", [stop.StopId intValue], stop.StopName, [stop.Latitude intValue], [stop.Longitude intValue]);
            if (![stop.StopName isEqualToString:@""]) {
                // первую остановку с каким-нибудь именем не пустым, добавляем в массив
                [allStopsByRoute addObject:stop];
                break;
            }
        }
        [stopsByStopId release];
    }
    [stopsResult release];
    
//    for (Stops *stop in allStopsByRoute) {
//        NSLog(@"%i, %@, %i, %i", [stop.StopId intValue], stop.StopName, [stop.Latitude intValue], [stop.Longitude intValue]);
//    }
    
    // почему-то некоторые остановки дублируются, иногда дублируются полностью, иногда меняется stopId. 
    return [allStopsByRoute autorelease];
}

-(ResultForView *)getScheduleByRouteId:(NSNumber *)routeId andStopId:(NSNumber *)stopId andDayOfWeek:(NSNumber *)dayOfWeek
{
    NSError *error = nil;
    
    NSFetchRequest *requestToRoutesStopsId = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDescriptionToRoutesStopsId = [NSEntityDescription entityForName:@"RoutesStops" inManagedObjectContext: managedObjectContext];
    [requestToRoutesStopsId setEntity:entityDescriptionToRoutesStopsId];
    
    NSPredicate *predicateToRoutesStopsId = [NSPredicate predicateWithFormat:@"RouteId == %@ && StopId == %@", routeId, stopId];
    [requestToRoutesStopsId setPredicate:predicateToRoutesStopsId];
    
    //-----NSArray<RouteStops>-----
    NSArray *routeStopIds = [managedObjectContext executeFetchRequest:requestToRoutesStopsId error:&error];
    [routeStopIds retain];
    
    // какого-то фига тоже по три одинаковые routestops находит, хотя должна только 1
    // поэтому берем первую и все
    
    NSNumber *routeStopId = nil;
    NSInteger index = 0;
    switch ([dayOfWeek intValue]) {
        case 1:
            index = 0;
            break;
        case 6:
            index = 1;
            break;
        case 7:
            index = 2;
            break;    
        default:
            break;
    }

    if ([routeStopIds count] > index) {
        routeStopId = ((RoutesStops *)[routeStopIds objectAtIndex:index]).RouteStopId;
    }
    else {
        routeStopId = [NSNumber numberWithInt:-1];
    }
    [routeStopIds release];
    
    NSFetchRequest *requestToRoutes = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDescriptionToRoutes = [NSEntityDescription entityForName:@"Times" inManagedObjectContext:managedObjectContext];
    [requestToRoutes setEntity:entityDescriptionToRoutes];
    NSPredicate *predicateToRoutes = [NSPredicate predicateWithFormat:@"RouteStopId == %@", routeStopId];
    [requestToRoutes setPredicate:predicateToRoutes];
    
    NSArray *arrayOfTimes = [managedObjectContext executeFetchRequest:requestToRoutes error:&error];
    [arrayOfTimes retain];
    
    Times * oneOfTime = (arrayOfTimes == nil || [arrayOfTimes count] == 0) ? nil : [arrayOfTimes objectAtIndex:0];
    
    [arrayOfTimes release];
    
    NSMutableArray *schedule = nil;

    schedule = [Schedule scheduleInIntegerFormatFull:oneOfTime.Time];
    [schedule retain];
    
    if ([schedule count] == 0) {
        [schedule release];
        return nil;
    }
    
    NSMutableDictionary *dictionarySchedule = [[NSMutableDictionary alloc] init];
    NSInteger currentHour = [[schedule objectAtIndex:0] integerValue] / 60;
    NSMutableArray *minutes = [[NSMutableArray alloc] init];
    NSString *stringFormat = @"";
    
    for (NSNumber *timeInMinute in schedule)
    {
        NSInteger hour = (NSInteger)[timeInMinute integerValue] / 60;
        NSInteger minute = [timeInMinute integerValue] - hour * 60;
        if (hour != currentHour) {
            if (currentHour < 10) {
                stringFormat = @"0%i";
            }
            else {
                stringFormat = @"%i";
            }
            [dictionarySchedule setValue:minutes forKey:[NSString stringWithFormat:stringFormat, currentHour]];
            currentHour = hour;
            [minutes release];
            minutes = [[NSMutableArray alloc] init];
        }
        if (minute < 10) {
            stringFormat = @"0%i";
        }
        else {
            stringFormat = @"%i";
        }
        [minutes addObject:[NSString stringWithFormat:stringFormat, minute]];
    }
    [schedule release];
    [minutes release];
    
    NSComparisonResult (^sortBlock)(id, id) = ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) { 
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSMutableArray *dictionaryScheduleCopy = [[dictionarySchedule allKeys] copy];
    NSArray *keys = [dictionaryScheduleCopy sortedArrayUsingComparator:sortBlock];
    [dictionaryScheduleCopy release];
    
    NSMutableArray *sortedHours = [NSMutableArray arrayWithArray: keys];
    ResultForView *result = [[ResultForView alloc] init];
    result.dictionaryWithSchedule = dictionarySchedule;
    result.sortedHours = sortedHours;
    [dictionarySchedule release];
    
    return [result autorelease];
}


// --------NSMutableArray<AllRoutesAndStops>---------
-(void)findAllPossibleRoutes
{
    clock_t start;
    clock_t finish;
    clock_t duration;
    double durInSec;
    
    start = clock();
    
    if ([allRouteIdsFromDatabase count] == 0)
    {
        NSError *error = nil;

        NSFetchRequest *requestToRoutesStopsId = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entityDescriptionToRoutesStopsId = [NSEntityDescription entityForName:@"RoutesStops" inManagedObjectContext: managedObjectContext];
        [requestToRoutesStopsId setEntity:entityDescriptionToRoutesStopsId];

        //-----NSArray<RouteStops>-----
        allRouteIdsFromDatabase = [managedObjectContext executeFetchRequest:requestToRoutesStopsId error:&error];
        [allRouteIdsFromDatabase retain];
    }
    
    // Берем все возможные айдишники для точки отправления и для точки прибытия
    // одновременно исключая все повторения айдишников, т.е. в итоге имеем
    // все уникальные айдишники для отправления и прибытия
    FullInfoAboutRoute *fullInfo = [FullInfoAboutRoute sharedMySingleton];
    NSMutableArray *possibleIdsOfCurrentStop = [[self getStopIdsByName: fullInfo.currentStop]retain];
    NSMutableArray *possibleIdsOfDestinationStop = [[self getStopIdsByName: fullInfo.destinationStop]retain];
    
    //-----NSMutableArray<NSNumber>-----
    NSMutableArray *possibleRouteIdsForCurrent = [[NSMutableArray alloc] init];
    NSMutableArray *possibleRouteIdsForDestination = [[NSMutableArray alloc] init];
    
    
    // Проходим по всем маршрутам, которые заранее извлекли из базы и находим
    // все маршруты, которые есть на остановке с которой отправляемся
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for (RoutesStops *routeStop in allRouteIdsFromDatabase)
    {
        for (NSNumber *possibleId in possibleIdsOfCurrentStop) {
            if ([routeStop.StopId intValue] == [possibleId intValue]) {
                if (![possibleRouteIdsForCurrent containsObject:routeStop.RouteId]) {
                    [possibleRouteIdsForCurrent addObject:routeStop.RouteId];
                    [a addObject:routeStop];
                }
            }
        }
    }

    // Проходим по всем маршрутам, которые заранее извлекли из базы и находим
    // все маршруты, которые есть на остановке на которую хотим доехать
    NSMutableArray *b = [[NSMutableArray alloc] init];
    for (RoutesStops *routeStop in allRouteIdsFromDatabase)
    {
        for (NSNumber *possibleId in possibleIdsOfDestinationStop) {
            if ([routeStop.StopId intValue] == [possibleId intValue]) {
                if (![possibleRouteIdsForDestination containsObject:routeStop.RouteId]) {
                    [possibleRouteIdsForDestination addObject:routeStop.RouteId];
                    [b addObject:routeStop];
                }
            }
        }
    }
    
    NSMutableSet *possibleIdsOfCurrentStop2 = [NSMutableSet new];
    
    // Проходим по возможным маршрутам точки отправления и точки прибытия и ищем 
    // совпадения, которые и будут являться всеми возможными способами добраться
    // из точки А в точку Б.
    NSMutableSet *result = [[NSMutableSet alloc] init];
    for (NSNumber *current in possibleRouteIdsForCurrent) {
        for (NSNumber *destination in possibleRouteIdsForDestination) {
            if ([current intValue] == [destination intValue]) {
                [result addObject:current];
            }
        }
    }
    
    NSLog(@"%@", possibleIdsOfCurrentStop2);
    
    [a release];
    [b release];
    
    finish = clock();
    
    duration = finish - start;
    durInSec = (double)duration / CLOCKS_PER_SEC;
    NSLog(@"Остальная херня 0 = %lu - %f", duration, durInSec);
    
    start = clock();
    
    NSMutableArray *newResult = [[NSMutableArray alloc]init];
    for (NSNumber *routeId in result) {
//        [self getRouteById:routeId];
        
        NSMutableArray *allStopsOfRoute = [[NSMutableArray alloc] init];
        int ordinalNumberOfCurrent = 0, ordinalNumberOfDestination = 0;
        // получаем все остановки текущего роута
        for (RoutesStops *rs in allRouteIdsFromDatabase) {
            if ([rs.RouteId intValue] == [routeId intValue]) {
                [allStopsOfRoute addObject:rs];
            }
        }

        for (NSNumber *possibleStopId in possibleIdsOfCurrentStop) {
            for (RoutesStops *routeStop in allStopsOfRoute) {
                if ([possibleStopId intValue] == [routeStop.StopId intValue]) {
                    ordinalNumberOfCurrent = [routeStop.OrdinalNumberOfStopInRoute intValue];
                }
            }
        }
        
        for (NSNumber *possibleStopId in possibleIdsOfDestinationStop) {
            for (RoutesStops *routeStop in allStopsOfRoute) {
                if ([possibleStopId intValue] == [routeStop.StopId intValue]) {
                    ordinalNumberOfDestination = [routeStop.OrdinalNumberOfStopInRoute intValue];
                }
            }
        }    
        if (ordinalNumberOfCurrent < ordinalNumberOfDestination) {
            [newResult addObject:routeId];
        }
        [allStopsOfRoute release];
    }
    [possibleIdsOfDestinationStop release];
    
    RequestWithResult *requestWithResult = [RequestWithResult sharedMySingleton];
    // т.к. массив в синглтоне не пересоздается, то удаляем из него все элементы
    // перед тем, как писать новые
    if (requestWithResult.allPossibleRoutes != nil) {
        [requestWithResult.allPossibleRoutes removeAllObjects];
    }
    finish = clock();
    
    duration = finish - start;
    durInSec = (double)duration / CLOCKS_PER_SEC;
    NSLog(@"Остальная херня 1 = %lu - %f", duration, durInSec);
    
    NSInteger count = 0;
    start = clock();
    
    NSNumber *dayOfWeek = [NSNumber numberWithInt: [Schedule getCurrentDayOfWeek]];
    // в newResult теперь лежат все возможные id-маршрутов, которые едут в нужном направлении и останавливаются на нужной нам остановке
    for (NSNumber *routeId in newResult) {
        for (NSNumber *stopId in possibleIdsOfCurrentStop) {
            
            // самая затратная херня. По секунде уходит на каждый айдишник
            Times *time = [self getScheduleByRouteIdAndStopId:routeId andStopId:stopId dayOfWeek:dayOfWeek];
            count++;
            
            if (time != nil) {
                Routes *route = [self getRouteById:routeId];
                // Creating object of class RouteWithSchedule
                MRouteWithSchedule *routeWithSchedule = [MRouteWithSchedule newMRoute];
                [routeWithSchedule setRouteName:route.RouteName];
                routeWithSchedule->routeId = [route.RouteId intValue];
                routeWithSchedule->stopId = [stopId intValue];
                routeWithSchedule->transportNumber = route.TransportNumber;
                routeWithSchedule->typeOfTransport = (TypeOfTransportEnum)[route.TypeOfTransport intValue];
                routeWithSchedule->dayOfWeek = [time.DayOfWeek intValue];
                NSMutableArray *schedule = [[Schedule scheduleInIntegerFormat:time.Time] retain];
                routeWithSchedule.schedule = schedule;
                [schedule release];
                
                // Adding created object to result
                [requestWithResult.allPossibleRoutes addObject:routeWithSchedule];
                [routeWithSchedule release];
            }
        }
    }
    NSLog(@"counter  - %d",  count);
    finish = clock();
    
    duration = finish - start;
    durInSec = (double)duration / CLOCKS_PER_SEC;
    NSLog(@"Остальная херня 2 = %lu - %f", duration, durInSec);
    
    [possibleIdsOfCurrentStop release];
    [newResult release];
    [possibleRouteIdsForCurrent release];
    [possibleRouteIdsForDestination release];
//    [allRouteIds release];
    [result release];
//    [allRouteIdsFromDatabase release];
//    [allRouteIdsFromDatabase retain];
//    [possibleIdsOfCurrentStop autorelease];
//    [possibleIdsOfDestinationStop autorelease];
}

// --------NSMutableArray<AllRoutesAndStops>---------
-(void)findAllPossibleRoutesOnCurrentStop:(NSNumber *)currentStopId currentRoutes:(NSArray *)routeIds
{
    RequestWithResult *requestWithResult = [RequestWithResult sharedMySingleton];
    // т.к. массив в синглтоне не пересоздается, то удаляем из него все элементы
    // перед тем, как писать новые
    if (requestWithResult.allPossibleRoutesOnCurrentStop != nil) {
        [requestWithResult.allPossibleRoutesOnCurrentStop removeAllObjects];
    }
    
    NSNumber *dayOfWeek = [NSNumber numberWithInt: [Schedule getCurrentDayOfWeek]];
    for (NSNumber *routeId in routeIds) {
        Routes *route = [self getRouteById:routeId];
            
        // самая затратная херня. По секунде уходит на каждый айдишник
        Times *time = [self getScheduleByRouteIdAndStopId:routeId andStopId:currentStopId dayOfWeek:dayOfWeek];
        
        if (time != nil) {
            // Creating object of class RouteWithSchedule
            MRouteWithSchedule *routeWithSchedule = [MRouteWithSchedule newMRoute];
            [routeWithSchedule setRouteName:route.RouteName];
            routeWithSchedule->routeId = [route.RouteId intValue];
            routeWithSchedule->stopId = [currentStopId intValue];
            routeWithSchedule->transportNumber = route.TransportNumber;
            routeWithSchedule->typeOfTransport = (TypeOfTransportEnum)[route.TypeOfTransport intValue];
            routeWithSchedule->dayOfWeek = [time.DayOfWeek intValue];
            NSMutableArray *schedule = [[Schedule scheduleInIntegerFormat:time.Time] retain];
            routeWithSchedule.schedule = schedule;
            [schedule release];
            
            // Adding created object to result
            if ([routeWithSchedule.schedule count] > 0) {
                [requestWithResult.allPossibleRoutesOnCurrentStop addObject:routeWithSchedule];
            }
            [routeWithSchedule release];
        }
    }
}

// --------NSMutableArray<AllRoutesAndStops>---------
-(NSDictionary *)findAllPossibleRoutesByRouteName
{
    if ([allRouteIdsFromDatabase count] == 0)
    {
        NSError *error = nil;
        
        NSFetchRequest *requestToRoutesStopsId = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entityDescriptionToRoutesStopsId = [NSEntityDescription entityForName:@"RoutesStops" inManagedObjectContext: managedObjectContext];
        [requestToRoutesStopsId setEntity:entityDescriptionToRoutesStopsId];
        //-----NSArray<RouteStops>-----
        allRouteIdsFromDatabase = [managedObjectContext executeFetchRequest:requestToRoutesStopsId error:&error];
        [allRouteIdsFromDatabase retain];
    }
    
    // Берем все возможные айдишники для точки отправления и для точки прибытия
    // одновременно исключая все повторения айдишников, т.е. в итоге имеем
    // все уникальные айдишники для отправления и прибытия
    FullInfoAboutRoute *fullInfo = [FullInfoAboutRoute sharedMySingleton];
    NSMutableArray *possibleIdsOfCurrentStop = [[self getStopIdsByName: fullInfo.currentStopToAllDirections]retain];
    
    //-----NSMutableArray<NSNumber>-----
    NSMutableArray *possibleRouteIdsForCurrentStopId = [[NSMutableArray alloc] init];
    NSMutableArray *possibleRoutesForCurrentStopId = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *stopIdAsKeyPossibleRoutesAsValue = [[NSMutableDictionary alloc] init];
    // Проходим по всем маршрутам, которые заранее извлекли из базы и находим
    // все маршруты, которые есть на остановке с которой отправляемся
    
    NSNumber *currentPossibleId = 0;
    for (NSNumber *possibleId in possibleIdsOfCurrentStop) 
    {
        for (RoutesStops *routeStop in allRouteIdsFromDatabase) {
            if ([routeStop.StopId intValue] == [possibleId intValue]) {
                if (![possibleRouteIdsForCurrentStopId containsObject:routeStop.RouteId]) {
                    Routes *routeEntity = [self getRouteById:routeStop.RouteId];
                    Route *route = [[Route alloc] init];
                    route.routeId = routeEntity.RouteId;
                    route.routeName = routeEntity.RouteName;
                    route.nameOfStartStop = routeEntity.StartName;
                    route.nameOfEndStop = routeEntity.EndName;
                    route.typeOfTransport = [routeEntity.TypeOfTransport intValue];
                    route.routeNumber = routeEntity.TransportNumber;
                    [possibleRouteIdsForCurrentStopId addObject:routeStop.RouteId];
                    [possibleRoutesForCurrentStopId addObject:route];
                    [route release];
                }
            }
            currentPossibleId = possibleId;
        }
        if ([possibleRoutesForCurrentStopId count] != 0) {
            [stopIdAsKeyPossibleRoutesAsValue setObject:possibleRoutesForCurrentStopId forKey:currentPossibleId];
        }
        [possibleRouteIdsForCurrentStopId removeAllObjects];
        [possibleRoutesForCurrentStopId release];
        possibleRoutesForCurrentStopId = [[NSMutableArray alloc] init];
    }
    
    [possibleIdsOfCurrentStop release];
    [possibleRoutesForCurrentStopId release];
    [possibleRouteIdsForCurrentStopId release];
    
    return [stopIdAsKeyPossibleRoutesAsValue autorelease];
}

-(Routes *)getRouteById:(NSNumber *)routeId
{
    NSError *error = nil;
    NSFetchRequest *requestToRoutes = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDescriptionToRoutes = [NSEntityDescription entityForName:@"Routes" inManagedObjectContext:managedObjectContext];
    [requestToRoutes setEntity:entityDescriptionToRoutes];
    NSPredicate *predicateToRoutes = [NSPredicate predicateWithFormat:@"RouteId == %@", routeId];
    [requestToRoutes setPredicate:predicateToRoutes];
    
    NSSortDescriptor *descriptorToRoutes = [[NSSortDescriptor alloc] initWithKey:@"RouteId" ascending:YES];
    [requestToRoutes setSortDescriptors:[NSArray arrayWithObject:descriptorToRoutes]];
    [descriptorToRoutes release];
    
    NSArray *arrayOfRoutes = [managedObjectContext executeFetchRequest:requestToRoutes error:&error];
    
//    for (Routes *route in arrayOfRoutes)
//    {
//        NSLog(@"%d, %@, %@, %@, %d, %d", [route.RouteId intValue], route.RouteName, route.StartName, route.EndName, [route.TypeOfTransport intValue], [route.TransportNumber intValue]);
//        break;
//    }
    return [arrayOfRoutes objectAtIndex:0];
}

-(Times *)getScheduleByRouteIdAndStopId:(NSNumber *)routeId andStopId:(NSNumber *)stopId dayOfWeek:(NSNumber *)dayOfWeek
{
    NSError *error = nil;
    NSFetchRequest *requestToRoutesStops = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDescriptionToRoutes = [NSEntityDescription entityForName:@"RoutesStops" inManagedObjectContext:managedObjectContext];
    [requestToRoutesStops setEntity:entityDescriptionToRoutes];
    NSPredicate *predicateToRoutes = [NSPredicate predicateWithFormat:@"RouteId == %@ && StopId == %@", routeId, stopId];
    [requestToRoutesStops setPredicate:predicateToRoutes];
    
    // здесь будет лежать на выходе от 0 до 3 элементов
    // 0 - если маршрут не ходит на остановке
    // 1 - если есть расписание на один день (пн-пт || суббота || воскресенье)
    // 2 - если есть расписание на два дня (пн-пт && суббота) || (пн-пт && воскресенье) || (суббота && воскресенье)
    // 3 - если есть расписание на всю неделю (пн-пт && суббота && воскресенье)
    NSArray *arrayOfRoutesStops = [managedObjectContext executeFetchRequest:requestToRoutesStops error:&error];
    
    NSArray *arrayOfTimes = nil;
    for (RoutesStops *routeStop in arrayOfRoutesStops)
    {
        NSFetchRequest *requestToTimes = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entityDescriptionToTimes = [NSEntityDescription entityForName:@"Times" inManagedObjectContext:managedObjectContext];
        [requestToTimes setEntity:entityDescriptionToTimes];
        NSPredicate *predicateToRoutes = [NSPredicate predicateWithFormat:@"RouteStopId == %@ && DayOfWeek == %@", routeStop.RouteStopId, dayOfWeek];
        [requestToTimes setPredicate:predicateToRoutes];
        
        arrayOfTimes = [managedObjectContext executeFetchRequest:requestToTimes error:&error];
        
//        for (Times *time in arrayOfTimes) {
//            NSLog(@"%i, %i, %@", [time.RouteStopId intValue], [time.DayOfWeek intValue], time.Time);
//        }
        if ([arrayOfTimes count] > 0) {
            return [arrayOfTimes objectAtIndex:0];
        }
    }
    
    return nil;
}

-(void)addToFavoriteStop:(NSString *)nameOfStop
{
    NSError *error = nil;
    NSFetchRequest *requestToRoutes = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDescriptionToRoutes = [NSEntityDescription entityForName:@"Stops" inManagedObjectContext:managedObjectContext];
    [requestToRoutes setEntity:entityDescriptionToRoutes];
    NSPredicate *predicateToRoutes = [NSPredicate predicateWithFormat:@"StopName == %@", nameOfStop];
    [requestToRoutes setPredicate:predicateToRoutes];
    
    NSArray *stopsFromBase  = [managedObjectContext executeFetchRequest:requestToRoutes error:&error];
    
    for (Stops *stopFromBase in stopsFromBase) {
        stopFromBase.isSelected = [NSNumber numberWithBool:YES];
    }
    
    //Save it
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error with Routes-Entity: %@", &error);
    }
}

-(void)removeFromFavoriteStop:(NSString *)nameOfStop
{
    NSError *error = nil;
    NSFetchRequest *requestToRoutes = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDescriptionToRoutes = [NSEntityDescription entityForName:@"Stops" inManagedObjectContext:managedObjectContext];
    [requestToRoutes setEntity:entityDescriptionToRoutes];
    NSPredicate *predicateToRoutes = [NSPredicate predicateWithFormat:@"StopName == %@", nameOfStop];
    [requestToRoutes setPredicate:predicateToRoutes];
    
    NSArray *stopsFromBase  = [managedObjectContext executeFetchRequest:requestToRoutes error:&error];
    
    for (Stops *stopFromBase in stopsFromBase) {
        stopFromBase.isSelected = [NSNumber numberWithBool:NO];
    }
    
    //Save it
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error with Routes-Entity: %@", &error);
    }
}

-(void)setIsFavorite:(Routes *)route
{
    NSError *error = nil;
    NSFetchRequest *requestToRoutes = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDescriptionToRoutes = [NSEntityDescription entityForName:@"Routes" inManagedObjectContext:managedObjectContext];
    [requestToRoutes setEntity:entityDescriptionToRoutes];
    NSPredicate *predicateToRoutes = [NSPredicate predicateWithFormat:@"RouteId == %@ && RouteName == %@ && TransportNumber == %@", route.RouteId, route.RouteName, route.TransportNumber];
    [requestToRoutes setPredicate:predicateToRoutes];
    
    Routes *routeFromBase  = [[managedObjectContext executeFetchRequest:requestToRoutes error:&error] lastObject];
    
    if (routeFromBase) {
        //Update the object
        routeFromBase.isSelected = route.isSelected;
    }
    
    //Save it
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error with Routes-Entity: %@", &error);
    }
}

-(void)addToFavoriteRoute:(Route *)route;
{
    NSError *error = nil;
    NSFetchRequest *requestToRoutes = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDescriptionToRoutes = [NSEntityDescription entityForName:@"Routes" inManagedObjectContext:managedObjectContext];
    [requestToRoutes setEntity:entityDescriptionToRoutes];
    NSPredicate *predicateToRoutes = [NSPredicate predicateWithFormat:@"RouteId == %@ && RouteName == %@ && TransportNumber == %@", route.routeId, route.routeName, route.routeNumber];
    [requestToRoutes setPredicate:predicateToRoutes];
    
    Routes *routeFromBase  = [[managedObjectContext executeFetchRequest:requestToRoutes error:&error] lastObject];
    
    if (routeFromBase) {
        //Update the object
        routeFromBase.isSelected = [NSNumber numberWithBool:YES];
    }
    
    //Save it
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error with Routes-Entity: %@", &error);
    }
}

-(NSNumber *)getCurrentDayOfWeek
{
    // узнаем текущую дату, чтобы выбрать из базы актуальную инфу, соответствующую
    // дню недели. В базе есть дни: 1 - будние, 6 - суббота, 7 - воскресенье
    NSDate *myDateHere = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSWeekdayCalendarUnit | NSHourCalendarUnit) fromDate:myDateHere];
    NSInteger hour = [dateComponents hour]; 
    NSInteger dayOfWeek = [dateComponents weekday];
    [gregorian release]; 
    // если уже больше двух часов ночи, то считаем, что это еще текущий день. Т.к. транспорт
    // в основном ходит до 1-2 ночи.
    if (hour <= 2) {
        // вообще, отнимать нужно единицу, но я тестировал где-то в 2 ночи с четверга
        // на пятницу и [dateComponents weekday] возвращал 6, хотя должен был 5 по логике
        dayOfWeek -= 2;
    }
    
    if (dayOfWeek >= 1 && dayOfWeek <= 5) {
        dayOfWeek = 1;
    }
    return [NSNumber numberWithInt:dayOfWeek];
}

- (Route *)routeFromRoutes:(Routes *)route
{
    Route *r = [[Route alloc] init];
    r.routeId = route.RouteId;
    r.routeName = route.RouteName;
    r.routeNumber = route.TransportNumber;
    
    return [r autorelease];
}

- (void)saveFavoritiesRoutesAndStops
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    dispatch_async(queue, ^{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        // формируем массивы для сохранения в NSUserDefaults
        NSMutableArray *favoriteBuses = [self getAllFavoritiesRoutes:BUS];
        NSMutableArray *favoriteTrolleybuses = [self getAllFavoritiesRoutes:TROLLEYBUS];
        NSMutableArray *favoriteTramways = [self getAllFavoritiesRoutes:TRAMWAY];
        NSMutableArray *favoriteMetros = [self getAllFavoritiesRoutes:METRO];
        
        NSMutableArray *favoriteRoutes = [[NSMutableArray alloc] init];
        [favoriteRoutes addObjectsFromArray:favoriteBuses];
        [favoriteRoutes addObjectsFromArray:favoriteTrolleybuses];
        [favoriteRoutes addObjectsFromArray:favoriteTramways];
        [favoriteRoutes addObjectsFromArray:favoriteMetros];
        
        NSMutableArray *favoriteRoutesToSave = [[NSMutableArray alloc] init];
        
        for (Routes *route in favoriteRoutes) {
            Route *r = [[self routeFromRoutes:route] retain];
            [favoriteRoutesToSave addObject:r];
            [r release];
        }
        [favoriteRoutes release];
        
        NSData *dataBuses = [NSKeyedArchiver archivedDataWithRootObject:favoriteRoutesToSave];
        [favoriteRoutesToSave release];
        [def setObject:dataBuses forKey:FAVORITE_ROUTES];
        
        NSMutableArray *favoriteStops = [self getFavoriteStopsFromDatabase];
        NSMutableArray *favoriteStopsToSave = [[NSMutableArray alloc] init];
        
        for (Stops *stop in favoriteStops) {
            [favoriteStopsToSave addObject:stop.StopName];
        }
        
        [def setObject:favoriteStopsToSave forKey:FAVORITE_STOPS];
        [favoriteStopsToSave release];
        
        [pool drain];
    });
    //    -(NSMutableArray *)getAllFavoritiesRoutes:(TypeOfTransportEnum)typeOfTransport; Routes
    //    getFavoriteStopsFromDatabase ; Stops
    //    -(void)setIsFavorite:(Routes *)route;
    //    -(void)addToFavoriteStop:(NSString *)nameOfStop;
}

@end
