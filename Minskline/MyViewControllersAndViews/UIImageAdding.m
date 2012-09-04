//
//  UIImageAdding.m
//  Minsktrans
//
//  Created by Kasnitskij_V on 05.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImageAdding.h"


@implementation UIImage (TPAdditions)
- (UIImage*)imageScaledToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
