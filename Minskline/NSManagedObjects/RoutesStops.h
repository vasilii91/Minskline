//
//  RoutesStops.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 28.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Routes, Stops;

@interface RoutesStops : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * RouteStopId;
@property (nonatomic, retain) NSNumber * RouteId;
@property (nonatomic, retain) NSNumber * StopId;
@property (nonatomic, retain) NSNumber * OrdinalNumberOfStopInRoute;
@property (nonatomic, retain) Routes * RelationshipBetweenRouteIds;
@property (nonatomic, retain) Stops * RelationshipBetweenStopIds;

@end
