//
//  ScrollingLabel.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 21.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScrollingLabel.h"


@implementation ScrollingLabel

@synthesize textLabel;
@synthesize text;

-(void)dealloc
{
    self.text = nil;
    self.textLabel = nil;
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        textLabel = [[UILabel alloc] initWithFrame:frame];
        textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel];
        self.userInteractionEnabled = NO;
        [self becomeFirstResponder];
    }
    return self;
}

-(void) setText:(NSString *)textParam
{
    textLabel.text = textParam;
    [textLabel sizeToFit];
    if (textLabel.frame.size.width > self.frame.size.width)
    {
        self.contentSize = CGSizeMake(textLabel.frame.size.width, textLabel.frame.size.height);
        self.contentOffset = CGPointMake(0, 0);
    }
    [textLabel sizeToFit];
}

-(NSString *)text
{
    return textLabel.text;
}

-(void) backAnimate
{
    [UIView beginAnimations:@"animateLabel2" context:nil];
    double factor = [textLabel.text length] / 30;
    double duration = 1.0f * factor;
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];
}

-(void) startAnimate
{
    if (textLabel.frame.size.width < self.frame.size.width) 
        return;
    
    [UIView beginAnimations:@"animateLabel" context:nil];
    double factor = [textLabel.text length] / 30;
    double duration = 1.3f * factor;
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(backAnimate)];
    int textLabelOffset = textLabel.frame.size.width - self.frame.size.width + 10;
    CGPoint offset = CGPointMake(textLabelOffset, 0);
    self.contentOffset = offset;
    [UIView commitAnimations];
}
@end
