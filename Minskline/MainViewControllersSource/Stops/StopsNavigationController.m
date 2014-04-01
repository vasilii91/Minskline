//
//  StopsNavigationController.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 10.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StopsNavigationController.h"

@implementation StopsNavigationController

@synthesize navigationController;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    StopsScreen *stopsScreenViewController = [[StopsScreen alloc] init];
    [self pushViewController:stopsScreenViewController animated:NO];
    [stopsScreenViewController release];
    
    self.navigationBar.topItem.title= @"Остановки";
    UILabel *label = [PrettyViews labelToNavigationBarWithTitle:@"Остановки"];
    self.navigationBar.topItem.titleView = label;
    self.navigationBar.tintColor = TAB_BAR_TITLE_COLOR;
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = NO;
}

- (id)init
{
    // Get the tab bar item
    UITabBarItem *tbi = [self tabBarItem];
    
    // Give it a label
    [tbi setTitle:@"Остановки"];
    
    // Create a UIImage from a file
    UIImage *icon = [UIImage imageNamed:@"to_icon.png"];
    
    // Put that image on the tabBarItem
    [tbi setImage:icon];
    
    return self = [super init];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
