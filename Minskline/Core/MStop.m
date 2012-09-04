//
//  MStop.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 18.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MStop.h"


@implementation MStop

+(id)newMStop
{
    MStop *stop = [[MStop alloc] init];
    
    return stop;
}

-(NSString *)description
{
    NSString *descr = [NSString stringWithFormat:@"StopId = %d; stopName = %@, latitude = %d, longitude = %d", [stopId intValue], stopName, [latitude intValue] , [longitude intValue]];
    
    return descr;
}

@end
