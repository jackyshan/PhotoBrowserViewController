//
//  HDPhotoWindow.m
//  YSBBusiness
//
//  Created by jackyshan on 15/7/23.
//  Copyright (c) 2015年 lu lucas. All rights reserved.
//

#import "HDPhotoWindow.h"
#import "ClickImageView.h"
#import "UIView+FrameHelper.h"
#import "UIImageView+WebCache.h"

#define ANI_TIME 0.3f
#define PHOTO_CELL @"photoCell"

@interface HDPhotoWindow()<HDPhotoViewDelegate> {
    NSMutableArray *_photos;
    HDPhotoView *_photoView;
    BlockAlertView *_blockAlertView;
}

@end

@implementation HDPhotoWindow

+ (instancetype)shareInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.backgroundColor = [UIColor blackColor];
        
        _photos = [NSMutableArray array];
        
        HDPhotoView *photoView = [[HDPhotoView alloc] initWithFrame:self.bounds];
        photoView.delegate = self;
        [self addSubview:photoView];
        _photoView = photoView;
    }
    
    return self;
}

- (void)show:(HDPhotoModel *)model alert:(BlockAlertView *)alert {
    [self show:@[model] atIndex:0 alert:alert];
}

- (void)show:(NSArray *)photos atIndex:(NSInteger)index alert:(BlockAlertView *)alert {
    self.hidden = NO;
    self.alpha =  1.f;
    self.backgroundColor = [UIColor blackColor];
    
    _blockAlertView = nil;
    _blockAlertView = alert;
    
    [_photos removeAllObjects];
    [_photos addObjectsFromArray:photos];
    
    [_photoView show:photos atIndex:index];
}

- (void)dismiss {
    _blockAlertView = nil;
    
    self.alpha = 0.f;
    self.hidden = YES;
    [self removeFromSuperview];
}

#pragma mark - HDPhotoViewDelegate
- (void)onTap:(UIView *)view model:(HDPhotoModel *)model {
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:ANI_TIME animations:^{
        view.frame = model.srcRect;
    } completion:^(BOOL finished) {
        [self dismiss];
    }];
}

- (void)onLongTap:(UIView *)view model:(HDPhotoModel *)model {
    [_blockAlertView showInView:view result:view];
}

@end

@interface HDPhotoView()<UITableViewDataSource, UITableViewDelegate, HDPhotoCellDelegate> {
    NSArray *_photos;
    NSInteger _currentIdx;
    UITableView *_tableView;
}

@end

@implementation HDPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _photos = [NSArray array];
        _currentIdx = 0;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.height, self.width)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.pagingEnabled = YES;
        tableView.rowHeight = self.width;
        tableView.center = CGPointMake(self.width * 0.5f, self.height * 0.5f);
        tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        [self addSubview:tableView];
        _tableView = tableView;
    }
    
    return self;
}

- (void)show:(NSArray *)photos atIndex:(NSInteger)index {
    _photos = photos;
    _currentIdx = index;
    
    [_tableView reloadData];
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                      atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:PHOTO_CELL];
    
    if (nil == cell)
    {
        cell = [[HDPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PHOTO_CELL];
        cell.frame = CGRectMake(0, 0, tableView.height, tableView.width);
        cell.transform = CGAffineTransformMakeRotation(M_PI / 2);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(HDPhotoCell *)cell updateWithModel:_photos[indexPath.row] ani:_currentIdx == indexPath.row];
    _currentIdx = indexPath.row;
}

#pragma mark - HDPhotoCellDelegate
- (void)onTap:(UIView *)view model:(HDPhotoModel *)model {
    if (!_delegate && ![_delegate respondsToSelector:@selector(onTap:model:)]) {
        return;
    }
    
    [_delegate onTap:view model:model];
}

- (void)onLongTap:(UIView *)view model:(HDPhotoModel *)model {
    if (!_delegate && ![_delegate respondsToSelector:@selector(onLongTap:model:)]) {
        return;
    }
    
    [_delegate onLongTap:view model:model];
}

@end

@implementation HDPhotoModel

- (instancetype)initWithThumbImg:(UIImage *)img hdUrl:(NSURL *)url srcRect:(CGRect)rect {
    if (self = [super init]) {
        self.thumbImg = img;
        self.hdUrl = url;
        self.srcRect = rect;
    }
    
    return self;
}

@end

@interface HDPhotoCell()<UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    ClickImageView *_imgV;
    HDPhotoModel *_model;
}

@end

@implementation HDPhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.minimumZoomScale = 1.0f;
        scrollView.maximumZoomScale = 2.0f;
        scrollView.pagingEnabled = NO;
        scrollView.scrollEnabled = YES;
        scrollView.userInteractionEnabled = YES;
        scrollView.delegate = self;
        [self.contentView addSubview:scrollView];
        _scrollView = scrollView;
        
        ClickImageView *imgV = [[ClickImageView alloc] init];
        imgV.userInteractionEnabled = NO;
        [scrollView addSubview:imgV];
        _imgV = imgV;
        
        UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOneTap)];
        oneTap.numberOfTapsRequired = 1;
        [scrollView addGestureRecognizer:oneTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
        doubleTap.numberOfTapsRequired = 2;
        [scrollView addGestureRecognizer:doubleTap];
        
        [oneTap requireGestureRecognizerToFail:doubleTap];
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTap:)];
        [scrollView addGestureRecognizer:longTap];
    }
    
    return self;
}

- (void)updateWithModel:(HDPhotoModel *)model ani:(BOOL)ani {
    [_scrollView setZoomScale:1.f animated:NO];
    
    if ([_model.hdUrl isEqual:model.hdUrl]) {
        return;
    }
    
    _model = model;
    
    _scrollView.frame = self.contentView.bounds;
    CGRect rect = _scrollView.frame;
    rect.size.height = self.width;
    _scrollView.frame = rect;
    
    _imgV.frame = model.srcRect;
    if (!ani) {
        _imgV.center = _scrollView.center;
    }
    
    [_imgV sd_setImageWithURL:model.hdUrl placeholderImage:model.thumbImg options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [UIView animateWithDuration:ANI_TIME animations:^{
            _imgV.center = _scrollView.center;
        }];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (nil == error) {
            [UIView animateWithDuration:ANI_TIME animations:^{
                CGRect rect = _imgV.frame;
                rect.size.width = image.size.width*0.5f;
                rect.size.height = image.size.height*0.5f;
                _imgV.frame = rect;
                _imgV.center = _scrollView.center;
                [_scrollView setContentSize:CGSizeMake(_imgV.width + ABS(_imgV.left), _imgV.height)];
                
                _imgV.frame = CGRectMake(_imgV.left>0?_imgV.left:0, _imgV.top>0?_imgV.top:0, _imgV.width, _imgV.height);
            }];
        }
        else {
            [UIView animateWithDuration:ANI_TIME animations:^{
                _imgV.center = _scrollView.center;
            }];
        }
    }];
    
    [_scrollView setContentSize:CGSizeMake(_imgV.width + ABS(_imgV.left), _imgV.height)];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imgV;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *iv = _imgV;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    iv.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                            scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)handleOneTap {
    [_scrollView setZoomScale:1.f animated:NO];
    [_scrollView setContentSize:CGSizeZero];
    
    if (!_delegate && ![_delegate respondsToSelector:@selector(onTap:model:)]) {
        return;
    }
    
    [_delegate onTap:_imgV model:_model];
    _model = nil;
}

- (void)handleDoubleTap {
    if (_scrollView.zoomScale == 1.f) {
        [_scrollView setZoomScale:2.f animated:YES];
    }
    else {
        [_scrollView setZoomScale:1.f animated:YES];
    }
}

- (void)handleLongTap:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    if (!_delegate && ![_delegate respondsToSelector:@selector(onLongTap:model:)]) {
        return;
    }
    
    [_delegate onLongTap:_imgV model:_model];
}

@end