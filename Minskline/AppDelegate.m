//
//  MinsktransAppDelegate.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 01.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


@synthesize window;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)loadCurrentState
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *routesData = [def objectForKey:FAVORITE_ROUTES];
    NSMutableArray *routes = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:routesData];
    for (Route *r in routes) {
        [allRoutes addToFavoriteRoute:r];
    }
    
    NSMutableArray *stopNames = [def objectForKey:FAVORITE_STOPS];
    for (NSString *stopName in stopNames) {
        [allRoutes addToFavoriteStop:stopName];
    }
    
    NSInteger interval = [[def valueForKey:INTERVAL] intValue];
    interval = interval == 0 ? 20 : interval;
    BOOL isFavorite = [[def valueForKey:IS_FAVORITES_SELECTED] boolValue];
    SortResultTypeEnum sortType = [[def valueForKey:SORT_TYPE] intValue];
    
    // для того, чтобы в настройках сразу установилось на нужный индекс UISegmentedControl'a
    if (interval == 20)
        [def setValue:[NSNumber numberWithInt:2] forKey:INTERVAL_INDEX];
    
    SettingsOfMinsktrans *settings = [SettingsOfMinsktrans sharedMySingleton];
    [settings setInterval:interval];
    settings.isFavorite = isFavorite;
    settings.sortResultType = sortType;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    clock_t start = clock();
    NSManagedObjectContext* managedOC = [self managedObjectContext];
    if (!managedOC){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"managedObjectContext == nil" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    allRoutes = [AllRoutesAndStops sharedMySingleton];
    allRoutes.managedObjectContext = managedOC;
    
    [self loadCurrentState];
    
    clock_t finish = clock();
    
    clock_t duration = finish - start;
    double durInSec = (double)duration / CLOCKS_PER_SEC;
    NSLog(@"Доступ к базе данных = %lu - %f", duration, durInSec);
    
    UIViewController *scheduleNavigationController = [[[ScheduleNavigationController alloc] init] autorelease];
    UIViewController *fromToNavigationController = [[[FromToNavigationController alloc] init] autorelease];
    UIViewController *stopsNavigationController = [[[StopsNavigationController alloc] init] autorelease];
    UIViewController *settingsScreen = [[[SettingsScreen alloc] init] autorelease];
    UIViewController *aboutScreen = [[[AboutScreen alloc] init] autorelease];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:scheduleNavigationController,fromToNavigationController, stopsNavigationController, settingsScreen, nil];
    
    tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:viewControllers];
    
    CGRect frame = CGRectMake(0.0, 0, 320, 48);
    
    UIView *v = [[UIView alloc] initWithFrame:frame];
    
    [v setBackgroundColor:TAB_BAR_COLOR];
    
    [tabBarController.tabBar insertSubview:v atIndex:0];
    [v release];
    
    BOOL isIOS5 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0;
    if (isIOS5) {
        [tabBarController.tabBar setTintColor:TAB_BAR_COLOR];
        [tabBarController.tabBar setSelectedImageTintColor:TAB_BAR_TITLE_COLOR];
    }
    
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
    
    sleep(2);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    AllRoutesAndStops *aRAS = [AllRoutesAndStops sharedMySingleton];
    [aRAS saveFavoritiesRoutesAndStops];
    [self saveContext];
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Minsktrans" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSString *) pathForDocuments
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSString *databaseName = @"Minskline";
    
    NSURL *storeBundleURL = [[NSBundle mainBundle] URLForResource:databaseName withExtension:@"sqlite"];
    NSURL *updateFileURL = [[NSBundle mainBundle] URLForResource:@"update" withExtension:@""];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Minskline.sqlite"];
    
    NSString *IS_COPIED = @"is copied";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if (![[def valueForKey:IS_COPIED] isEqualToString:@"YES"]) {
        // копируем содержимое базы данных в documentsDirectory только при первом запуске
        //        NSString *path = [NSString stringWithFormat:@"%@", [self pathForDocuments]];
        //        path = [path stringByAppendingFormat:@"/%@", databaseName];
        
        NSData *databaseData = [NSData dataWithContentsOfURL:storeBundleURL];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *relativePath = [storeURL relativePath];
        [fileManager createFileAtPath:relativePath contents:databaseData attributes:nil];
        
        NSString *updateDate = [NSString stringWithContentsOfURL:updateFileURL encoding:NSUTF8StringEncoding error:nil];
        //        [[NSUserDefaults standardUserDefaults] setValue:[Schedule getCurrentDate] forKey:CURRENT_UPDATE_DATE];
        [[NSUserDefaults standardUserDefaults] setValue:updateDate forKey:CURRENT_UPDATE_DATE];
        
        [def setValue:@"YES" forKey:IS_COPIED];
    }
    
    NSLog(@"%@", storeURL);
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)dealloc
{
    [__managedObjectModel release];
    [__managedObjectContext release];
    [__persistentStoreCoordinator release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end
