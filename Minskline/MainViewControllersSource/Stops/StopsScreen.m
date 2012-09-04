//
//  StopsScreen.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 10.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StopsScreen.h"

@implementation StopsScreen
@synthesize searchBar;
@synthesize doneInvisibleButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar.tintColor = TAB_BAR_COLOR;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    settings = [SettingsOfMinsktrans sharedMySingleton];
    if (settings.isNeedUpdate2 || settings.isChangedFromOneToAnother2) {
        
        settings.isChangedFromOneToAnother2 = NO;
        settings.isNeedUpdate2 = NO;
    }
}

- (void)viewDidUnload
{
    [self setDoneInvisibleButton:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    RequestWithResult *RWR = [RequestWithResult sharedMySingleton];
    RWR.isNeedUpdateResultScreen = YES;
    FullInfoAboutRoute *fullInfo = [FullInfoAboutRoute sharedMySingleton];
    fullInfo.currentStopToAllDirections = [super textOfCell];
    
    DirectionsScreen *toScreen = [[DirectionsScreen alloc] init];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:toScreen animated:YES];
    [toScreen release];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [doneInvisibleButton release];
    [searchBar release];
    [super dealloc];
}

@end
