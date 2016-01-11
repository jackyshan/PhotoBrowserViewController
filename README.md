![](images/photo_browser_view.gif)

##步骤
1、初始化imageview

```
ClickImageView *imgV = [[ClickImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 180)];
[self.contentView addSubview:imgV];
imgV.delegate = self;
```

2、初始化model,alertView,实现photowindow

```
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

```
