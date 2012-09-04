//
//  PleaseWaitAlertView.m
//  Good Earth
//
//  Created by Vasilii Kasnitski on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PleaseWaitAlertView.h"

@implementation PleaseWaitAlertView

- (void)layoutSubviews
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - 50);
    [indicator startAnimating];
    
    [self addSubview:indicator];
    [indicator release];
}


@end
