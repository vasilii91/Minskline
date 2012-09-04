//
//  Route.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 31.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Route.h"

static NSString *ROUTE_NAME = @"route name";
static NSString *ROUTE_ID = @"route id";
static NSString *START_NAME = @"start name";
static NSString *TRANSPORT_NUMBER = @"transport number";
static NSString *END_NAME = @"end name";

@implementation Route

@synthesize routeId, routeName, routeNumber, nameOfEndStop, nameOfStartStop, typeOfTransport;

-(void)dealloc
{
    [super dealloc];
}

- (NSString *)description
{
    NSString *result = [NSString stringWithFormat:@"%@, %@, %@, %i, %@", routeId, nameOfStartStop, nameOfEndStop, typeOfTransport, routeNumber];
    
    return result;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.routeName forKey:ROUTE_NAME];
    [encoder encodeObject:self.routeId forKey:ROUTE_ID];
    [encoder encodeObject:self.nameOfStartStop forKey:START_NAME];
    [encoder encodeObject:self.nameOfEndStop forKey:END_NAME];
    [encoder encodeObject:self.routeNumber forKey:TRANSPORT_NUMBER];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.routeName = [decoder decodeObjectForKey:ROUTE_NAME];
        self.routeId = [decoder decodeObjectForKey:ROUTE_ID];
        self.nameOfStartStop = [decoder decodeObjectForKey:START_NAME];
        self.nameOfEndStop = [decoder decodeObjectForKey:END_NAME];
        self.routeNumber = [decoder decodeObjectForKey:TRANSPORT_NUMBER];
    }
    return self;
}

@end
