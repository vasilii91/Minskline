//
//  PrettyViews.h
//  Minskline
//
//  Created by Vasilii Kasnitski on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@interface PrettyViews : NSObject

+ (UILabel *)labelToNavigationBarWithTitle:(NSString *)title;
+ (UIButton *)buttonToNavigationBarWithTitle:(NSString *)title;

@end
