//
//  BlockAlertView.m
//  YSBBusiness
//
//  Created by jackyshan on 15/7/28.
//  Copyright (c) 2015年 lu lucas. All rights reserved.
//

#import "BlockAlertView.h"

@interface BlockAlertView()<UIActionSheetDelegate>

@end

@implementation BlockAlertView

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        _alertTitle = title;
    }
    
    return [self init];
}

- (instancetype)init {
    if (self = [super init]) {
        _models = [NSMutableArray array];
    }
    
    return self;
}

- (void)addTitle:(NSString *)title block:(AlertBlock)block {
    BlockAlertModel *model = [[BlockAlertModel alloc] initWithTitle:title block:block];
    [_models addObject:model];
}

- (void)showInView:(UIView *)view {
    [self showInView:view result:nil];
}

- (void)showInView:(UIView *)view result:(id)result {
    _result = result;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    sheet.title = _alertTitle;
    sheet.delegate = self;
    BlockAlertModel *cancel = [[BlockAlertModel alloc] initWithTitle:@"取消" block:nil];
    [_models addObject:cancel];
    [_models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BlockAlertModel *model = obj;
        model.index = [sheet addButtonWithTitle:model.title];
    }];
    sheet.cancelButtonIndex = _models.count-1;
    [sheet showInView:view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [_models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BlockAlertModel *model = obj;
        
        if (model.index == buttonIndex) {
            if (model.alertBlock) {
                model.alertBlock(_result);
            }
            *stop = YES;
        }
    }];
    
    [_models removeLastObject];
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
}

- (void)dealloc {
    NSLog(@"block view dealloc");
}

@end

@implementation BlockAlertModel

- (instancetype)initWithTitle:(NSString *)title block:(AlertBlock)block {
    if (self = [super init]) {
        self.title = title;
        self.alertBlock = block;
    }
    
    return self;
}

@end