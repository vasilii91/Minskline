//
//  FromToNavigationController.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 03.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FromToNavigationController.h"

@implementation FromToNavigationController

@synthesize navigationController;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    FromScreen *fromViewController = [[FromScreen alloc] init];
    fromViewController.title = @"Откуда-куда";
    [self pushViewController:fromViewController animated:NO];
    [fromViewController release];
    
    self.navigationBar.topItem.title= @"Откуда";
    UILabel *label = [PrettyViews labelToNavigationBarWithTitle:@"Откуда"];
    self.navigationBar.topItem.titleView = label;
    self.navigationBar.tintColor = TAB_BAR_TITLE_COLOR;
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = NO;
}

- (void)viewDidUnload
{
    self.navigationController = nil;
    [super viewDidUnload];
}

- (id)init
{
    UITabBarItem *tbi = [self tabBarItem];
    [tbi setTitle:@"Откуда-куда"];
    UIImage *icon = [UIImage imageNamed:@"from_icon.png"];
    [tbi setImage:icon];
    
    return self = [super init];
}

@end
