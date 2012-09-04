//
//  MStop.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 18.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MStop : NSObject {
    
    @public
    NSNumber *stopId;
    NSString *stopName;
    NSNumber *latitude;
    NSNumber *longitude;
}

+(id)newMStop;

@end
