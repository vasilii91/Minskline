//
//  KVTableViewController.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 23.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullInfoAboutRoute.h"
#import "AllRoutesAndStops.h"
#import "ScrollingLabel.h"
#import "KVTableViewCellKVTableViewController.h"

@class FullInfoAboutRoute;
@class AllRoutesAndStops;

@interface KVTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
                
    // в нем лежат только остановки для текущей секции
    NSMutableArray *listOfStops;
    
    // избранные остановки
    NSMutableArray *favoriveStops;
    // хранит копию всех остановок
    NSMutableArray *copyCurrentListOfStops;
    // хранит все текущие остановки
    NSMutableArray *currentListOfStops;
    
    // хранит все остановки
    NSMutableArray *globalListOfStops;
    
    BOOL letUserSelectRow;
    BOOL isFavorites;
    
    NSArray *russianLettersAndNumbers;
    
    SettingsOfMinsktrans *settings;
    AllRoutesAndStops *allRoutesAndStops;
    
    NSMutableDictionary *dictionaryListOfStopsByLetter;
    
    @private
    BOOL searching;
}

@property (nonatomic, retain) IBOutlet UITableView *tableViewResult;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UISearchBar *sBar;
@property (nonatomic, readwrite) NSInteger numberOfTransport;
@property (nonatomic, retain) NSString *textOfCell;
@property (retain, nonatomic) IBOutlet UIButton *doneInvisibleButton;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewIndicator;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

- (void) searchTableView;
- (void) doneSearchingClicked;
-(void)buttonClickOnIsFavorite:(id)sender;

@end
