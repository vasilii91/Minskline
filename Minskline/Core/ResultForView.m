//
//  ResultForView.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 01.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultForView.h"


@implementation ResultForView
@synthesize transportNumber, time, typeOfTransport;
@synthesize routeNumber, stopsByRoute, routeId;
@synthesize sortedHours, dictionaryWithSchedule;

- (BOOL)isValidResult
{
    if (transportNumber != nil && time >= 0 && typeOfTransport <= 4) 
        return YES;
    return NO;
}

- (NSString *)rightTextByTime
{
    NSInteger lastDigit = time % 10;
    NSString *textToCell = @"";
    switch (lastDigit) {
        case 0:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
            textToCell = @"минут";
            break;
            
        case 2:
        case 3:
        case 4:
            textToCell = @"минуты";
            break;
            
        case 1:
            textToCell = @"минуту";
            break;
    }
    if (time / 10 == 1)
        textToCell = @"минут";
    
    return textToCell;
}

-(void)dealloc
{
    self.stopsByRoute = nil;
    self.sortedHours = nil;
    self.dictionaryWithSchedule = nil;
    [super dealloc];
}

@end
