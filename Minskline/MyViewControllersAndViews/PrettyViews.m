//
//  PrettyViews.m
//  Minskline
//
//  Created by Vasilii Kasnitski on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrettyViews.h"

@implementation PrettyViews

+ (UILabel *)labelToNavigationBarWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = TAB_BAR_TITLE_COLOR; // change this color
    label.text = title;
    [label sizeToFit];
    
    return [label autorelease];
}

+ (UIButton *)buttonToNavigationBarWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [button setTitle:@"Delete" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
    [button.layer setCornerRadius:4.0f];
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor: [[UIColor grayColor] CGColor]];
    button.frame=CGRectMake(0.0, 100.0, 60.0, 30.0);
    [button addTarget:self action:@selector(batchDelete) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
