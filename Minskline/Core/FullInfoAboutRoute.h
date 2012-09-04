//
//  FullInfoAboutRow.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 11.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeOfTransport.h"
#import "Routes.h"
#import "Stops.h"

@interface FullInfoAboutRoute : NSObject {
//    TypeOfTransportEnum typeOfTransport;
//    NSString *numberOfTransport;
//    NSString *currentStop;
//    NSString *destinationStop;
    
    @public
    BOOL isNeedUpdateThirdScreen;
    BOOL isNeedUpdateSecondScreen;
    BOOL isNeedUpdateFourthScreen;
    Routes *currentRouteFromSecondScreen;
    Stops *currentStopFromThirdScreen;
    NSArray *currentRoutesOnStop;
    NSNumber *currentStopId;
}

@property (nonatomic) TypeOfTransportEnum typeOfTransport;
@property (nonatomic, retain) NSString *numberOfTransport;
@property (nonatomic, retain) NSString *currentStop;
@property (nonatomic, retain) NSString *destinationStop;
@property (nonatomic, retain) NSString *currentStopToAllDirections;

//- (TypeOfTransportEnum) typeOfTransport;
//- (void) setTypeOfTransport: (TypeOfTransportEnum) type;
//- (NSString *) numberOfTransport;
//- (void) setNumberOfTransport: (NSString *) number;
//- (NSString *) currentStop;
//- (void) setCurrentStop: (NSString *)current;
//- (NSString *) destinationStop;
//- (void) setDestinationStop: (NSString *) destination;

+ (FullInfoAboutRoute *)sharedMySingleton;

@end
