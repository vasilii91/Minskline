//
//  RequestWithResult.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stops.h"
#import "MRouteWithSchedule.h"
#import "ResultForView.h"
#import "SortResultType.h"


@interface RequestWithResult : NSObject {
    
}

+(RequestWithResult *)sharedMySingleton;
- (void)sortResultForView:(SortResultTypeEnum)sortResultType;

// request
@property (nonatomic, retain) Stops *startStop;
@property (nonatomic, retain) Stops *destinationStop;
// result
@property (nonatomic, retain) Stops *nextStop;

//-----NSMutableArray<MRouteWithSchedule>------
@property (nonatomic, retain) NSMutableArray *allPossibleRoutes;

@property (nonatomic, retain) NSMutableArray *allPossibleRoutesOnCurrentStop;

//-----NSMutableArray<ResultForView>---------
@property (nonatomic, retain) NSMutableArray *resultForView;
@property (nonatomic, retain) NSMutableArray *resultForView2;

// переменная отвечает за то, нужно ли перерисовывать result screen
@property (nonatomic, assign) BOOL isNeedUpdateResultScreen;

@end
