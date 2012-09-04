//
//  KVTableViewCellRoutes.m
//  Minsktrans
//
//  Created by Vasilii Kasnitski on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KVTableViewCellRoutes.h"

@implementation KVTableViewCellRoutes

@synthesize labelRoutes, labelNumbers;

+ (KVTableViewCellRoutes *)cell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"KVTableViewCellRoutes" owner:nil options:nil];
    return [array objectAtIndex:0];
}

@end
