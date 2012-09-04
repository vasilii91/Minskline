//
//  SettingsOfMinsktrans.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 04.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SortResultType.h"

@interface SettingsOfMinsktrans : NSObject
{
    NSInteger interval;
}

+ (SettingsOfMinsktrans *) sharedMySingleton;
- (NSInteger) interval;
- (void)setInterval:(NSInteger)myInterval;

// показывает, нужно ли обновлять экран. Допустим, когда пользователь довавляет/удаляет в/из избранное(го)
@property (nonatomic, assign) BOOL isNeedUpdate1;
@property (nonatomic, assign) BOOL isNeedUpdate2;
@property (nonatomic, assign) BOOL isNeedUpdate3;
// показывает, какой из экранов показывать
@property (nonatomic, assign) BOOL isFavorite;
// показывает, менял ли пользователь флаг все/избранные 
@property (nonatomic, assign) BOOL isChangedFromOneToAnother1;
@property (nonatomic, assign) BOOL isChangedFromOneToAnother2;
@property (nonatomic, assign) BOOL isChangedFromOneToAnother3;

@property (nonatomic, assign) SortResultTypeEnum sortResultType;

@end
