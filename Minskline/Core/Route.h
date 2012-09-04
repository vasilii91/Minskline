//
//  Route.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 31.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeOfTransport.h"

@interface Route : NSObject<NSCoding>

@property (nonatomic, retain) NSNumber *routeId;
@property (nonatomic, retain) NSString *routeName;
@property (nonatomic, retain) NSString *nameOfStartStop;
@property (nonatomic, retain) NSString *nameOfEndStop;
@property (nonatomic, assign) TypeOfTransportEnum typeOfTransport;
@property (nonatomic, retain) NSString *routeNumber;

@end
