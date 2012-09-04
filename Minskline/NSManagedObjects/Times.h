//
//  Times.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 28.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Routes, Stops;

@interface Times : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * RouteStopId;
@property (nonatomic, retain) NSNumber * DayOfWeek;
@property (nonatomic, retain) NSString * Time;
@property (nonatomic, retain) NSNumber * HelperId;
@property (nonatomic, retain) Stops * RelationshipBetweenStopIds;
@property (nonatomic, retain) Routes * RelationshipBetweenRouteIds;

@end
