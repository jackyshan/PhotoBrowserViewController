//
//  ClickImageView.m
//  YSBBusiness
//
//  Created by jackyshan on 15/7/23.
//  Copyright (c) 2015年 lu lucas. All rights reserved.
//

#import "ClickImageView.h"

@implementation ClickImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_click)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)_click {
    if (!_delegate && ![_delegate respondsToSelector:@selector(clickImageTap:)]) {
        return;
    }
    
    [_delegate clickImageTap:self];
}

@end