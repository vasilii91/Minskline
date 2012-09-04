//
//  KVTableViewCellResultScreen.m
//  Minsktrans
//
//  Created by Vasilii Kasnitski on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KVTableViewCellResultScreen.h"

@implementation KVTableViewCellResultScreen

@synthesize topLabel, bottomLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //
        // Create a background image view.
        //
        self.backgroundView = [[[UIImageView alloc] init] autorelease];
        self.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
        
        UIImage *rowBackground = [UIImage imageNamed:@"time_result_cell.png"];
        UIImage *selectionBackground = [UIImage imageNamed:@"time_result_cell.png"];
        ((UIImageView *)self.backgroundView).image = rowBackground;
        ((UIImageView *)self.selectedBackgroundView).image = selectionBackground;
        
        topLabel = [[[UILabel alloc] initWithFrame: CGRectMake(80, 0, 300, 50)] autorelease];
        [self.contentView addSubview:topLabel];
        //
        // Configure the properties for the text that are the same on every row
        //
        topLabel.backgroundColor = [UIColor clearColor];
        topLabel.textColor = [UIColor colorWithRed:(float)205/255 green:(float)48/255 blue:(float)13/255 alpha:1.0];// [UIColor colorWithRed:(float)255/255 green:(float)130/255 blue:(float)5/255 alpha:1.0];
        topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
        topLabel.font = [UIFont systemFontOfSize:22];
        
        //
        // Create the label for the top row of text
        //
        bottomLabel = [[[UILabel alloc] initWithFrame: CGRectMake(80, 30, 300, 50)] autorelease];
        [self.contentView addSubview:bottomLabel];
        //
        // Configure the properties for the text that are the same on every row
        //
        bottomLabel.backgroundColor = [UIColor clearColor];
        bottomLabel.textColor = TAB_BAR_TITLE_COLOR;
        bottomLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
        bottomLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
