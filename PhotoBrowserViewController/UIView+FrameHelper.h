//
//  UIView+FrameHelper.h
//  KKBusiness
//
//  Created by lulucas on 10/23/14.
//  Copyright (c) 2014 lulucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameHelper)
/**
 *  顶端
 *
 *  @return <#return value description#>
 */
- (CGFloat)top;
/**
 *  底部
 *
 *  @return <#return value description#>
 */
- (CGFloat)buttom;
/**
 *  左边
 *
 *  @return <#return value description#>
 */
- (CGFloat)left;
/**
 *  右边
 *
 *  @return <#return value description#>
 */
- (CGFloat)right;
/**
 *  宽
 *
 *  @return <#return value description#>
 */
- (CGFloat)width;
/**
 *  高
 *
 *  @return <#return value description#>
 */
- (CGFloat)height;

@end
