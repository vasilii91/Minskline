//
//  KVTableViewCellSecondScreen.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 29.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "KVTableViewCellSecondScreen.h"

@implementation KVTableViewCellSecondScreen
@synthesize bottomLabel, topLabel, overBottomLabel, routeToCell, buttonFavorite, indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView = [[[UIImageView alloc] init] autorelease];
		self.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
        UIImage *rowBackground = [UIImage imageNamed:@"routes_cell.png"];
        UIImage *selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
        
        ((UIImageView *)self.backgroundView).image = rowBackground;
        ((UIImageView *)self.selectedBackgroundView).image = selectionBackground;
        
        bottomLabel = [[UILabel alloc] initWithFrame: CGRectMake(100, 60, 300, 50)];
        bottomLabel.backgroundColor = [UIColor clearColor];
        bottomLabel.textColor = [UIColor colorWithRed:(float)255/255 green:(float)130/255 blue:(float)5/255 alpha:1.0];
        bottomLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
        bottomLabel.font = [UIFont systemFontOfSize:30];
        [self addSubview:bottomLabel];
        [bottomLabel release];
        
        topLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 300, 30)];
        topLabel.backgroundColor = [UIColor clearColor];
        topLabel.textColor = TAB_BAR_TITLE_COLOR;
        topLabel.highlightedTextColor = [UIColor blackColor];
        topLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:topLabel];
        [topLabel release];
        
        overBottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 34, 300, 30)];
        overBottomLabel.backgroundColor = [UIColor clearColor];
        overBottomLabel.textColor = TAB_BAR_TITLE_COLOR;
        overBottomLabel.highlightedTextColor = [UIColor blackColor];
        overBottomLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:overBottomLabel];
        [overBottomLabel release];
        
        buttonFavorite = [[UIButton alloc] initWithFrame:CGRectMake(270, 15, 35, 35)];
        [buttonFavorite addTarget:self action:@selector(clickOnFavoriteButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonFavorite];
        [buttonFavorite release];
    }
    return self;
}

- (void)dealloc
{
    indexPath = nil;
    [super dealloc];
}


#pragma mark - Actions 

- (void)clickOnFavoriteButton
{
    [self.delegate userClickedOnFavoriteButton:self];
}

@end
