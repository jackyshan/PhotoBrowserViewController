//
//  ViewController.m
//  PhotoBrowserViewController
//
//  Created by apple on 8/23/15.
//  Copyright (c) 2015 jackyshan. All rights reserved.
//

#import "ViewController.h"
#import "ClickImageView.h"
#import "UIImageView+WebCache.h"
#import "HDPhotoWindow.h"

@interface ViewController ()<ClickImageViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"PhotoBroser";
    
    ClickImageView *imageView = [[ClickImageView alloc] initWithFrame:CGRectMake(10, 160, 200, 300)];
    [self.view addSubview:imageView];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://jackyshan.gitcafe.io/images/block_alert_view.png"]];
    imageView.delegate = self;
}

- (void)clickImageTap:(ClickImageView *)view {
    
    HDPhotoModel *model = [[HDPhotoModel alloc] initWithThumbImg:view.image hdUrl:[NSURL URLWithString:@"http://jackyshan.gitcafe.io/images/block_alert_view.png"] srcRect:[self convertToWindow:view]];
    
    
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
