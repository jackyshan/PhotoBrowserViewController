//
//  UIView+FrameHelper.m
//  KKBusiness
//
//  Created by lulucas on 10/23/14.
//  Copyright (c) 2014 lulucas. All rights reserved.
//

#import "UIView+FrameHelper.h"

@implementation UIView (FrameHelper)

- (CGFloat)left
{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)right
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)top
{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)buttom
{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}


@end
