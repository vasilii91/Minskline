//
//  SettingsOfMinsktrans.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 04.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsOfMinsktrans.h"

@implementation SettingsOfMinsktrans

@synthesize isFavorite, isChangedFromOneToAnother1, isChangedFromOneToAnother2, isChangedFromOneToAnother3, isNeedUpdate1, isNeedUpdate2, isNeedUpdate3, sortResultType;

static SettingsOfMinsktrans * _sharedMySingleton = nil;

static void singleton_remover()
{
    if (_sharedMySingleton) {
        [_sharedMySingleton release];
    }
}

+ (SettingsOfMinsktrans *) sharedMySingleton
{
    @synchronized(self)
    {
        if (!_sharedMySingleton) {
            _sharedMySingleton = [[SettingsOfMinsktrans alloc] init];
            
            // release instance at exit
            atexit(singleton_remover);
        }
    }
    
    return _sharedMySingleton;
}

- (NSInteger) interval
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:@"Settings" ofType:@"plist"];
    NSMutableDictionary *dictionaryFromFile = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    
    NSString *value = [dictionaryFromFile objectForKey:@"Interval"];
    NSInteger intValue = [value integerValue];
    [dictionaryFromFile release];

    return intValue;
}

- (void)setInterval:(NSInteger)myInterval
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:@"Settings" ofType:@"plist"];
    NSMutableDictionary *dictionaryFromFile = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSString *stringInterval = [NSString stringWithFormat:@"%i", myInterval];
    [dictionaryFromFile setValue:stringInterval forKey:@"Interval"];
    [dictionaryFromFile writeToFile:filePath atomically:YES];
    [dictionaryFromFile release];
}

-(void)dealloc
{
    [super dealloc];
}

@end
