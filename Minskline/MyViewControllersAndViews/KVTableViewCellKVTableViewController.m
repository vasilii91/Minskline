//
//  KVTableViewCellKVTableViewController.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 09.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "KVTableViewCellKVTableViewController.h"

@implementation KVTableViewCellKVTableViewController

@synthesize centerLabel, buttonFavorite, nameOfStop, indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        buttonFavorite = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonFavorite.frame = CGRectMake(260, 10, 34, 34);
        [buttonFavorite setHidden:NO];
        [self addSubview:buttonFavorite];
        
        self.backgroundView = [[[UIImageView alloc] init] autorelease];
		self.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
        
        UIImage *rowBackground = [UIImage imageNamed:@"stop_cell.png"];
        UIImage *selectionBackground = [UIImage imageNamed:@"stop_cell_selected.png"];
        
        ((UIImageView *)self.backgroundView).image = rowBackground;
        ((UIImageView *)self.selectedBackgroundView).image = selectionBackground;
        
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.imageView.image = nil;// [[UIImage imageNamed:@"stop_image.png"] imageScaledToSize:CGSizeMake(imageWidth, imageHeight)];
        
        centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 8, 250, 40)];
        centerLabel.backgroundColor = [UIColor clearColor];
        centerLabel.textColor = TAB_BAR_TITLE_COLOR;
        [self addSubview:centerLabel];
        [centerLabel release];
        
    }
    return self;
}

@end
