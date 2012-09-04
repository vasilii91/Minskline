//
//  AllRoutes.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 31.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRouteWithSchedule.h"
#import "MStop.h"
#import "Route.h"
#import "FullInfoAboutRoute.h"
#import "Schedule.h"
#import "Routes.h"
#import "Stops.h"
#import "RoutesStops.h"
#import "Times.h"
#import "RequestWithResult.h"
#import "ResultForView.h"
#import "Constants.h"

@interface AllRoutesAndStops : NSObject
{
    float totalPercent;
    BOOL isExistNetworkConnection;
    NSInteger counterRouteStopId;
    NSInteger counterHelperIdTimes;
    NSInteger ordinalNumberOfStopInRoute;
    NSInteger currentRouteId;
    
    @public
    //-----------------------------------------
    // Arrays to getting info from @"http://www.minsktrans.by/city/minsk/routes.txt"
    
    //-----------------------------------------
    // Arrays to getting info from @"http://www.minsktrans.by/city/minsk/stops.txt"
    NSMutableArray* mutableArray01_ID;
    NSMutableArray* mutableArray02_City;
    NSMutableArray* mutableArray03_Area;
    NSMutableArray* mutableArray04_Street;
    NSMutableArray* mutableArray05_Name;
    NSMutableArray* mutableArray06_Info;
    NSMutableArray* mutableArray07_Longitude;
    NSMutableArray* mutableArray08_Latitude;
    NSMutableArray* mutableArray09_Stops;
    
    BOOL isUserClickedOnStopButtonWhenUpdate;
    
    NSMutableArray *allStopsFromDatabase;
    NSMutableArray *allStopNamesFromDatabase;
    NSArray *allRouteIdsFromDatabase;
    NSArray *allRoutesFromDatabase;
    
    NSArray *busNumbers;
    NSArray *trolleybusNumbers;
    NSArray *tramwayNumbers;
    NSArray *metroNumbers;
    
    NSMutableSet *setBusNumbers;
    NSMutableSet *setTrolleybusNumbers;
    NSMutableSet *setTramwayNumbers;
    NSMutableSet *setMetroNumbers;
    
    NSInteger counter;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(void)getAllRoutes;
-(void)setIsUserClickedOnStopButtonWhenUpdate:(BOOL)isClicked;
-(NSMutableArray *)getAllStopsFromDatabase;
- (NSMutableArray *)getFavoriteStopsFromDatabase;
-(NSArray *)getAllRoutesByTypeOfTransport:(TypeOfTransportEnum)typeOfTransport;
-(NSMutableArray *)getAllRoutesByTypeAndNumberOfTransport:(TypeOfTransportEnum)typeOfTransport andNumber:(NSString *)numberOfTransport;
-(NSMutableArray *)getAllFavoritiesRoutes:(TypeOfTransportEnum)typeOfTransport;
-(NSMutableArray *)getAllStopsByRoute:(Routes *)route;
-(NSMutableArray *)getAllStopsByPatternOrByFirstLetter:(BOOL)isByLetter patternOfFirstLetter:(NSString *)patternOrFirstLetter;
-(ResultForView *)getScheduleByRouteId:(NSNumber *)routeId andStopId:(NSNumber *)stopId andDayOfWeek: (NSNumber *)dayOfWeek;
-(Times *)getScheduleByRouteIdAndStopId:(NSNumber *)routeId andStopId:(NSNumber *)stopId dayOfWeek:(NSNumber *)dayOfWeek;

-(NSMutableArray *)getStopsByName:(NSString *)stopName;
-(Routes *)getRouteById:(NSNumber *)routeId;

-(void)findAllPossibleRoutes;
-(void)findAllPossibleRoutesOnCurrentStop:(NSNumber *)currentStopId currentRoutes:(NSArray *)routeIds;
-(NSDictionary *)findAllPossibleRoutesByRouteName;
-(void)setIsFavorite:(Routes *)route;
-(void)addToFavoriteRoute:(Route *)route;
-(void)addToFavoriteStop:(NSString *)nameOfStop;
-(void)removeFromFavoriteStop:(NSString *)nameOfStop;
+ (AllRoutesAndStops *)sharedMySingleton;

- (void)saveFavoritiesRoutesAndStops;

@end
