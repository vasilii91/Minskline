//
//  ScheduleNavigationController.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 06.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleNavigationController.h"

@implementation ScheduleNavigationController

@synthesize navigationController;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    FirstScreen *firstScreenViewController = [[FirstScreen alloc] init];
    [self pushViewController:firstScreenViewController animated:NO];
    [firstScreenViewController release];
    
    self.navigationBar.topItem.title= @"Расписание";
    UILabel *label = [PrettyViews labelToNavigationBarWithTitle:@"Расписание"];
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
    [tbi setTitle:@"Расписание"];
    
    // Create a UIImage from a file
    UIImage *icon = [UIImage imageNamed:@"schedule_tab_bar_icon.png"];
    
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
