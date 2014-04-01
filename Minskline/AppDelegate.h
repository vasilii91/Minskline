//
//  MinsktransAppDelegate.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 01.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstScreen.h"
#import "ResultScreen.h"
#import "ToScreen.h"
#import "FromScreen.h"
#import "SecondScreen.h"
#import "ThirdScreen.h"
#import "FourthScreen.h"
#import "AboutScreen.h"
#import "StopsNavigationController.h"
#import "FromToNavigationController.h"
#import "ScheduleNavigationController.h"
#import "SettingsNavigationController.h"

@class AllRoutesAndStops;

@interface AppDelegate : NSObject <UIApplicationDelegate, UIScrollViewDelegate> {
    UITabBarController *tabBarController;
    
    IBOutlet UIImageView *splashView;
    
    NSUInteger count;
    AllRoutesAndStops *allRoutes;
}

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end