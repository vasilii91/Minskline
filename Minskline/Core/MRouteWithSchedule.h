//
//  MRoute.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 18.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TypeOfTransport.h"

@interface MRouteWithSchedule : NSObject {
    
    NSString *routeName;
    NSString *nameOfStartStop;
    NSString *nameOfEndStop;
    
    @public
    NSInteger routeId;
    TypeOfTransportEnum typeOfTransport;
    NSInteger stopId;
    NSString *transportNumber;
    NSString *scheduleInStringFormat;
    // if only weekdays - only 1, if only holidays - 6,7
    // if weekdays with holidays - 1, 6, 7
    NSInteger dayOfWeek;     
}

@property (nonatomic, retain) NSMutableArray *schedule;

+(id)newMRoute;
-(void)setRouteName:(NSString *)nameOfRoute;
-(NSString *)routeName;
-(NSString *)nameOfStartStop;
-(NSString *)nameOfEndStop;

@end
