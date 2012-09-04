//
//  MRoute.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 18.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MRouteWithSchedule.h"

@interface MRouteWithSchedule (Private)
-(NSString *)startName;
-(NSString *)endName;
@end

@implementation MRouteWithSchedule

@synthesize schedule;

+(id)newMRoute
{
    MRouteWithSchedule *route = [[MRouteWithSchedule alloc] init];
//    route->schedule = [[NSMutableArray alloc] init];
    
    return route;
}

-(void)dealloc
{
    [super dealloc];
}

-(NSString *)description
{
    NSString *descr = [NSString stringWithFormat:@"RouteId = %d; routeName = %@, typeOfTransprort = %d, transportNumber = %d, stopId = %d, dayOfWeek = %d; \n Schedule:\n %@", routeId, routeName, (int)typeOfTransport, transportNumber, stopId, dayOfWeek, schedule];
    
    return descr;
}

-(void)setRouteName:(NSString *)nameOfRoute
{
    routeName = nameOfRoute;
    nameOfStartStop = [self startName];
    nameOfEndStop = [self endName];
}

-(NSString *)routeName
{
    return routeName;
}

-(NSString *)nameOfStartStop
{
    return nameOfStartStop;
}

-(NSString *)nameOfEndStop
{
    return nameOfEndStop;
}

// Почему-то не работает с такими именами
//2011-09-20 01:54:44.422 Minsktrans[47997:6b07] Error with end of name: Автозаводская линия
//2011-09-20 01:54:44.453 Minsktrans[47997:6b07] Error with start of name: ДС Сухарево – ст.м.Институт культуры
//2011-09-20 01:54:44.456 Minsktrans[47997:6b07] Error with end of name: ДС Сухарево – ст.м.Институт культуры
//2011-09-20 01:54:44.462 Minsktrans[47997:6b07] Error with start of name: ДС Сухарево – D
//2011-09-20 01:54:44.463 Minsktrans[47997:6b07] Error with end of name: ДС Сухарево – D
//2011-09-20 01:54:44.495 Minsktrans[47997:6b07] Error with start of name: ДС Карастояновой – ст.м. пл.Я.Коласа
//2011-09-20 01:54:44.496 Minsktrans[47997:6b07] Error with end of name: ДС Карастояновой – ст.м. пл.Я.Коласа
//2011-09-20 01:54:44.535 Minsktrans[47997:6b07] Error with start of name: ДС Дражня – ст. м. "Пушкинская"
//2011-09-20 01:54:44.537 Minsktrans[47997:6b07] Error with end of name: ДС Дражня – ст. м. "Пушкинская"
//2011-09-20 01:54:44.570 Minsktrans[47997:6b07] Error with start of name: ДС Малинина – Запорожская пл.
-(NSString *)startName
{
    NSRange rangeOfDash;
    NSArray *possibilities = [NSArray arrayWithObjects:@" - ", @" – ", @"–", @"-", nil];
    for (int i = 0; i < [possibilities count]; i++) {
        rangeOfDash = [routeName rangeOfString:[possibilities objectAtIndex:i]];
        if (rangeOfDash.location != NSIntegerMax) {
            return [routeName substringToIndex:rangeOfDash.location];
        }
    }
    
    NSLog(@"Error with start of name: %@", routeName);
    
    return routeName;
}

-(NSString *)endName
{
    NSRange rangeOfDash = [routeName rangeOfString:@" - "];
    if (rangeOfDash.location != NSIntegerMax) {
        return [routeName substringFromIndex:rangeOfDash.location + 3];
    }
    rangeOfDash = [routeName rangeOfString:@" – "];
    if (rangeOfDash.location != NSIntegerMax) {
        return [routeName substringFromIndex:rangeOfDash.location + 3];
    }
    rangeOfDash = [routeName rangeOfString:@"–"];
    if (rangeOfDash.location != NSIntegerMax) {
        return [routeName substringFromIndex:rangeOfDash.location + 1];
    }
    rangeOfDash = [routeName rangeOfString:@"-"];
    if (rangeOfDash.location != NSIntegerMax) {
        return [routeName substringFromIndex:rangeOfDash.location + 1];
    }
    
    NSLog(@"Error with end of name: %@", routeName);
    
    return routeName;
}

@end
