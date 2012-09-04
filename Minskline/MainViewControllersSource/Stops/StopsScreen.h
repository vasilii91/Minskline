//
//  StopsScreen.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 10.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "FullInfoAboutRoute.h"
#import "KVTableViewController.h"
#import "KVUILabel.h"
#import "DirectionsScreen.h"

@class KVTableViewController;

@interface StopsScreen : KVTableViewController
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@end
