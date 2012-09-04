//
//  KVTableViewCellRoutes.h
//  Minsktrans
//
//  Created by Vasilii Kasnitski on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KVTableViewCellRoutes : UITableViewCell
{
}
+ (KVTableViewCellRoutes *)cell;

@property (nonatomic, retain) IBOutlet UILabel *labelRoutes;
@property (nonatomic, retain) IBOutlet UILabel *labelNumbers;

@end
