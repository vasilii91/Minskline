//
//  FullInfoAboutRow.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 11.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FullInfoAboutRoute.h"


@implementation FullInfoAboutRoute

@synthesize currentStop, destinationStop, typeOfTransport, numberOfTransport, currentStopToAllDirections;

static FullInfoAboutRoute * _sharedMySingleton = nil;

static void singleton_remover()
{
    if (_sharedMySingleton) {
        [_sharedMySingleton release];
    }
}

+ (FullInfoAboutRoute *) sharedMySingleton
{
    @synchronized(self)
    {
        if (!_sharedMySingleton) {
            _sharedMySingleton = [[FullInfoAboutRoute alloc] init];
            
            // release instance at exit
            atexit(singleton_remover);
        }
    }
    
    return _sharedMySingleton;
}

-(void)dealloc
{
    [super dealloc];
}
@end
