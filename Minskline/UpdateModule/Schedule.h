//
//  Schedule.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsOfMinsktrans.h"

@interface Schedule : NSObject {
    NSMutableArray *schedule;
}

// Return count of bytes from URL
-(int)getScheduleFromURL:(NSString *)URL;
-(NSMutableArray *)schedule;
-(NSString *)scheduleInStringFormat;
+(NSMutableArray *)scheduleInIntegerFormat:(NSString *)scheduleInStringFormat;
+(NSMutableArray *)scheduleInIntegerFormatFull:(NSString *)scheduleInStringFormat;
+(NSInteger)getCurrentDayOfWeek;
+(NSString *)getCurrentDate;
+(NSComparisonResult)compareOneDate:(NSString *)firstDateString withAnother:(NSString *)secondDateString;
+(NSInteger)getCurrentTimeInMinutes;

@end
