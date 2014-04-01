//
//  KVTableViewCellSecondScreen.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 29.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Routes.h"
#import "Constants.h"

@protocol KVTableViewCellSecondScreenDelegate <NSObject>

- (void)userClickedOnFavoriteButton:(id)cell;

@end


@interface KVTableViewCellSecondScreen : UITableViewCell
{
    @public
        BOOL isFavorite;
}

@property (nonatomic, retain) UILabel *bottomLabel;
@property (nonatomic, retain) UILabel *topLabel;
@property (nonatomic, retain) UILabel *overBottomLabel;
@property (nonatomic, retain) UIButton *buttonFavorite;

@property (nonatomic, retain) Routes *routeToCell;
@property (nonatomic, retain) NSIndexPath *indexPath;

@property (nonatomic, assign) NSObject<KVTableViewCellSecondScreenDelegate> *delegate;

@end
