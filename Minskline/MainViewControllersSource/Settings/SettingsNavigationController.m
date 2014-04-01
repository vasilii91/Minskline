//
//  SettingsNavigationController.m
//  Minskline
//
//  Created by Vasilii Kasnitski on 4/1/14.
//
//

#import "SettingsNavigationController.h"
#import "SettingsScreen.h"

@interface SettingsNavigationController ()

@end

@implementation SettingsNavigationController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    SettingsScreen *settingsScreen = [[SettingsScreen alloc] init];
    [self pushViewController:settingsScreen animated:NO];
    [settingsScreen release];
    
    self.navigationBar.topItem.title= @"Настройки";
    UILabel *label = [PrettyViews labelToNavigationBarWithTitle:@"Настройки"];
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
    [tbi setTitle:@"Настройки"];
    
    
    // Create a UIImage from a file
    UIImage *icon = [UIImage imageNamed:@"settings_tab_bar_icon.png"];
    
    // Put that image on the tabBarItem
    [tbi setImage:icon];
    
    return self = [super init];
}

@end
