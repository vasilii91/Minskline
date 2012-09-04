//
//  ScrollingLabel.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 21.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ScrollingLabel : UIScrollView {
    
}

-(NSString *)text;
-(void) startAnimate;

@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) NSString *text;

@end
