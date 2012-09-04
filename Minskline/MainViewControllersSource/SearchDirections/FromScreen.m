//
//  FifthScreen.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 04.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FromScreen.h" 

@implementation FromScreen
//@synthesize doneInvisibleButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sBar.tintColor = TAB_BAR_COLOR;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    SettingsOfMinsktrans *settings = [SettingsOfMinsktrans sharedMySingleton];
    if (settings.isNeedUpdate1 || settings.isChangedFromOneToAnother1) {
        
        settings.isChangedFromOneToAnother1 = NO;
        settings.isNeedUpdate1 = NO;
    }
    [self.sBar setText:@""];
}

- (void)viewDidUnload
{
    [self setDoneInvisibleButton:nil];
    [super viewDidUnload];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    RequestWithResult *RWR = [RequestWithResult sharedMySingleton];
    RWR.isNeedUpdateResultScreen = YES;
    FullInfoAboutRoute *fullInfo = [FullInfoAboutRoute sharedMySingleton];
    fullInfo.currentStop = [self textOfCell];
    
    ToScreen *toScreen = [[ToScreen alloc] init];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:toScreen animated:YES];
    [toScreen release];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
//    [doneInvisibleButton release];
    [super dealloc];
}

@end
