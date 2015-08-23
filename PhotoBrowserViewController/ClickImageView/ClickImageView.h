//
//  ClickImageView.h
//  YSBBusiness
//
//  Created by jackyshan on 15/7/23.
//  Copyright (c) 2015年 lu lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickImageViewDelegate;
@interface ClickImageView : UIImageView

@property (nonatomic, weak) id<ClickImageViewDelegate> delegate;

@end

@protocol ClickImageViewDelegate <NSObject>

- (void)clickImageTap:(UIView *)view;

@end