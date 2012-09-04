//
//  SecondScreen.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 02.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollingLabel.h"
#import "AllRoutesAndStops.h"
#import "FullInfoAboutRoute.h"
#import "UIImageAdding.h"
#import "KVUILabel.h"
#import "KVTableViewCellSecondScreen.h"
#import "ThirdScreen.h"
#import "PrettyViews.h"

@interface SecondScreen : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    // ---<String>-----
    NSMutableArray *differentRoutes;
    // ---<Routes>-----
    NSMutableArray *differentRoutesFull;
    
    NSInteger countOfItemsInTable;
}

@property (nonatomic, retain) IBOutlet UITableView *tableViewRoutes;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

-(void)reloadData:(BOOL)isDeleteCell;
-(void)buttonClickOnIsFavorite:(id)sender;
-(void)goToHome:(id)sender;

@end
