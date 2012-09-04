//
//  DirectionsScreen.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 11.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollingLabel.h"
#import "AllRoutesAndStops.h"
#import "FullInfoAboutRoute.h"
#import "UIImageAdding.h"
#import "KVUILabel.h"
#import "KVTableViewCellSecondScreen.h"
#import "ThirdScreen.h"
#import "KVTableViewCellRoutes.h"
#import "ResultScreen2.h"
#import "PrettyViews.h"

@interface DirectionsScreen : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    
    NSInteger countOfItemsInTable;
    
    NSDictionary *possibleRoutes;
}

@property (nonatomic, retain) IBOutlet UITableView *tableViewRoutes;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

-(void)reloadData:(BOOL)isDeleteCell;
-(void)goToHome:(id)sender;

@end
