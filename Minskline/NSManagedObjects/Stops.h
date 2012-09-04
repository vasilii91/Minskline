//
//  Stops.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 27.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Stops : NSManagedObject

@property (nonatomic, retain) NSNumber * Latitude;
@property (nonatomic, retain) NSNumber * Longitude;
@property (nonatomic, retain) NSString * StopName;
@property (nonatomic, retain) NSNumber * StopId;
@property (nonatomic, retain) NSNumber * isSelected;

@end
