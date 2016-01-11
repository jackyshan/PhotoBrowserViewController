//
//  PhotoCollectionViewCell.m
//  BlockAlertViewController
//
//  Created by jackyshan on 1/11/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "ClickImageView.h"
#import "UIImageView+WebCache.h"
#import "HDPhotoWindow.h"

@interface PhotoCollectionViewCell()<ClickImageViewDelegate> {
    UIImageView *_imgV;
    NSString *_url;
}

@end

@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        ClickImageView *imgV = [[ClickImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 180)];
        [self.contentView addSubview:imgV];
        imgV.delegate = self;
        _imgV = imgV;
    }
    
    return self;
}

- (void)updateWithUrl:(NSString *)url {
    if ([_url isEqualToString:url]) {
        return;
    }
    
    _url = url;

    [_imgV sd_setImageWithURL:[NSURL URLWithString:url]];
}

- (void)clickImageTap:(ClickImageView *)view {
    
    HDPhotoModel *model = [[HDPhotoModel alloc] initWithThumbImg:view.image hdUrl:[NSURL URLWithString:_url] srcRect:[self convertToWindow:view]];
    
    
    BlockAlertView *alertView = [[BlockAlertView alloc] initWithTitle:@"分享"];
    [alertView addTitle:@"朋友圈" block:^(id result) {
        NSLog(@"朋友圈");
    }];
    [alertView addTitle:@"朋友" block:^(id result) {
        NSLog(@"朋友");
    }];
    [alertView addTitle:@"微信好友" block:^(id result) {
        NSLog(@"微信好友");
    }];
    [alertView addTitle:@"QQ空间" block:^(id result) {
        NSLog(@"QQ空间");
    }];
    [alertView addTitle:@"陌陌" block:^(id result) {
        NSLog(@"陌陌");
    }];
    
    [[HDPhotoWindow shareInstance] show:model alert:alertView];
}

- (CGRect)convertToWindow:(UIView *)view {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    return [view convertRect:view.bounds toView:window];
}

@end
