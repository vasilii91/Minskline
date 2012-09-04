//
//  ThirdScreen.h
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
#import "FourthScreen.h"
#import "PrettyViews.h"

@interface ThirdScreen : UIViewController<UITableViewDelegate, UITableViewDataSource>  {
    // ---<String>---
    NSMutableArray *stopsInRoute;
    // ---<Stops>---
    NSMutableArray *stopsInRouteFull;
}

@property (nonatomic, retain) IBOutlet UITableView *tableViewStops;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

-(void)reloadData;
-(void)goToHome:(id)sender;

@end
