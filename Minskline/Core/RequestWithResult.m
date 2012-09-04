//
//  RequestWithResult.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RequestWithResult.h"


@implementation RequestWithResult

@synthesize startStop, destinationStop, nextStop, allPossibleRoutes, allPossibleRoutesOnCurrentStop;
@synthesize resultForView, resultForView2, isNeedUpdateResultScreen;

static RequestWithResult * _sharedMySingleton = nil;

static void singleton_remover()
{
    if (_sharedMySingleton) {
        [_sharedMySingleton release];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        allPossibleRoutes = [[NSMutableArray alloc] init];
        allPossibleRoutesOnCurrentStop = [[NSMutableArray alloc] init];
        resultForView = [[NSMutableArray alloc] init];
        resultForView2 = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (RequestWithResult *) sharedMySingleton
{
    @synchronized(self)
    {
        if (!_sharedMySingleton) {
            _sharedMySingleton = [[RequestWithResult alloc] init];
            // release instance at exit
            atexit(singleton_remover);
        }
    }
    
    return _sharedMySingleton;
}

- (void)sortArraysUsingBlock:(SortResultTypeEnum)sortResultType
{
    NSComparisonResult (^sortBlock)(id, id) = ^(id obj1, id obj2) {
        ResultForView *r1 = (ResultForView *)obj1;
        ResultForView *r2 = (ResultForView *)obj2;
        
        switch (sortResultType) {
            case SortResultByTime:
            {
                if (r1.time > r2.time) { 
                    return (NSComparisonResult)NSOrderedDescending;
                }
                else if (r1.time < r2.time) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }
            case SortResultByTransportNumber:
            {
                if ([r1.transportNumber intValue] > [r2.transportNumber intValue]) { 
                    return (NSComparisonResult)NSOrderedDescending;
                }
                else if ([r1.transportNumber intValue] < [r2.transportNumber intValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                else {
                    return [r1.transportNumber compare:r2.transportNumber];
                }
            }
            case SortResultByTransportNumberAndTime:
            {
                if (r1.typeOfTransport > r2.typeOfTransport) { 
                    return (NSComparisonResult)NSOrderedDescending;
                }
                else if (r1.typeOfTransport < r2.typeOfTransport) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }
            default:
                return (NSComparisonResult)NSOrderedSame;
        }
    };
    
    self.resultForView = [NSMutableArray arrayWithArray: [self.resultForView sortedArrayUsingComparator:sortBlock]];
    self.resultForView2 = [NSMutableArray arrayWithArray: [self.resultForView2 sortedArrayUsingComparator:sortBlock]];
}

- (void)sortResultForView:(SortResultTypeEnum)sortResultType
{
    
    
    switch (sortResultType) {
        case SortResultByTime:
        {
            [self sortArraysUsingBlock:sortResultType];
            break;
        }
        case SortResultByTransportNumber:
        {
            // сначала сортируем по номеру, а потом меняем тип сортировки и сортируем по времени
            [self sortArraysUsingBlock:SortResultByTransportNumber];
//            [self sortArraysUsingBlock:SortResultByTime];
            break;
        }
        case SortResultByTransportNumberAndTime:
        {
            // сортируем сначала по типу транспорта, потом меняем тип сортировки на сортировку по времени
            // и снова сортируем
            [self sortArraysUsingBlock:SortResultByTransportNumberAndTime];
//            [self sortArraysUsingBlock:SortResultByTime];
            break;
        }
    }
}

-(void)dealloc
{
    [allPossibleRoutes release];
    [allPossibleRoutesOnCurrentStop release];
    [resultForView release];
    [resultForView2 release];
    [super dealloc];
}
@end
