//
//  KVUILabel.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 10.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KVUILabel.h"


@implementation KVUILabel

+(UILabel *)getLabelWithName:(NSString *)nameOfLabel
{
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFrame:CGRectMake(0, 0, 320, 40)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
    [nameLabel setTextColor:[UIColor orangeColor]];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [nameLabel setText:nameOfLabel];
    [nameLabel setTextAlignment:UITextAlignmentCenter];
    
    return [nameLabel autorelease];
}
@end
