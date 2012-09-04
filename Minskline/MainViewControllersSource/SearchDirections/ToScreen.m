//
//  ToScreen.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 04.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ToScreen.h"

@implementation ToScreen

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Домой" style:UIBarButtonItemStyleBordered target:self action:@selector(goToHome:)];          
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton release];
    
    UILabel *label = [PrettyViews labelToNavigationBarWithTitle:@"Куда"];
    self.navigationItem.title= @"Куда";
    self.navigationItem.titleView = label;
    
    self.sBar.tintColor = TAB_BAR_COLOR;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    settings = [SettingsOfMinsktrans sharedMySingleton];
    if (settings.isNeedUpdate3 || settings.isChangedFromOneToAnother3) {
        
        settings.isChangedFromOneToAnother3 = NO;
        settings.isNeedUpdate3 = NO;
    }
}

-(void)goToHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (id)init
{
    // Get the tab bar item
    UITabBarItem *tbi = [self tabBarItem];
    
    // Give it a label
    [tbi setTitle:@"Куда"];
    
    // Create a UIImage from a file
    UIImage *icon = [UIImage imageNamed:@"to_icon.png"];
    
    // Put that image on the tabBarItem
    [tbi setImage:icon];
    
    return self = [super init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    RequestWithResult *RWR = [RequestWithResult sharedMySingleton];
    RWR.isNeedUpdateResultScreen = YES;
    FullInfoAboutRoute *fullInfo = [FullInfoAboutRoute sharedMySingleton];
    fullInfo.destinationStop = [super textOfCell];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ResultScreen *resultViewController = [[ResultScreen alloc] init];
    [self.navigationController pushViewController:resultViewController animated:YES];
    [resultViewController release];
    
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}


@end
