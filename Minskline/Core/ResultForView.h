//
//  ResultForView.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 01.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeOfTransport.h"

@interface ResultForView : NSObject {
    
}

- (BOOL)isValidResult;
- (NSString *)rightTextByTime;

// for ResultScreen
@property (nonatomic) TypeOfTransportEnum typeOfTransport;
@property (nonatomic, retain) NSString *transportNumber;
@property (nonatomic) NSInteger time;

// for SecondScreen
@property (nonatomic) NSInteger routeNumber;
@property (nonatomic) NSInteger routeId;
// ------NSMutableArray<Stops>--------
@property (nonatomic, retain) NSMutableArray *stopsByRoute;

// for FourthScreen
@property (nonatomic, retain) NSMutableArray *sortedHours;
@property (nonatomic, retain) NSMutableDictionary *dictionaryWithSchedule;
@end
