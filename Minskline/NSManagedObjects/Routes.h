//
//  Routes.h
//  Minsktrans
//
//  Created by Vasilii Kasnitski on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Routes : NSManagedObject

@property (nonatomic, retain) NSString * RouteName;
@property (nonatomic, retain) NSNumber * RouteId;
@property (nonatomic, retain) NSString * StartName;
@property (nonatomic, retain) NSString * TransportNumber;
@property (nonatomic, retain) NSNumber * TypeOfTransport;
@property (nonatomic, retain) NSString * EndName;
@property (nonatomic, retain) NSNumber * isSelected;

@end
