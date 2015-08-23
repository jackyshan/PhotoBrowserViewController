//
//  HDPhotoWindow.h
//  YSBBusiness
//
//  Created by jackyshan on 15/7/23.
//  Copyright (c) 2015年 lu lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockAlertView.h"

@class HDPhotoModel;
@interface HDPhotoWindow : UIWindow

+ (instancetype)shareInstance;

- (void)show:(HDPhotoModel *)model alert:(BlockAlertView *)alert;
- (void)show:(NSArray *)photos atIndex:(NSInteger)index alert:(BlockAlertView *)alert;

@end

@protocol HDPhotoViewDelegate;
@interface HDPhotoView : UIView

@property (nonatomic, weak) id<HDPhotoViewDelegate> delegate;

- (void)show:(NSArray *)photos atIndex:(NSInteger)index;

@end

@protocol HDPhotoViewDelegate <NSObject>

@optional
- (void)onTap:(UIView *)view model:(HDPhotoModel *)model;
- (void)onLongTap:(UIView *)view model:(HDPhotoModel *)model;

@end

@interface HDPhotoModel : NSObject

@property (nonatomic, strong) UIImage *thumbImg;
@property (nonatomic, strong) NSURL *hdUrl;
@property (nonatomic, assign) CGRect srcRect;

- (instancetype)initWithThumbImg:(UIImage *)img hdUrl:(NSURL *)url srcRect:(CGRect)rect;

@end

@protocol HDPhotoCellDelegate;
@interface HDPhotoCell : UITableViewCell

@property (nonatomic, weak) id<HDPhotoCellDelegate> delegate;

- (void)updateWithModel:(HDPhotoModel *)model ani:(BOOL)ani;

@end

@protocol HDPhotoCellDelegate <NSObject>

@optional
- (void)onTap:(UIView *)view model:(HDPhotoModel *)model;
- (void)onLongTap:(UIView *)view model:(HDPhotoModel *)model;

@end