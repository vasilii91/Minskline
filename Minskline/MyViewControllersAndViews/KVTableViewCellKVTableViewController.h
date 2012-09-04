//
//  KVTableViewCellKVTableViewController.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 09.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageAdding.h"
#import "Stops.h"
#import "Constants.h"

@interface KVTableViewCellKVTableViewController : UITableViewCell
{
    @public
        BOOL isFavorite;
}

@property (nonatomic, retain) UILabel *centerLabel;
@property (nonatomic, retain) UIButton *buttonFavorite;
@property (nonatomic, retain) NSString *nameOfStop;
@property (nonatomic, retain) NSIndexPath *indexPath;

@end
