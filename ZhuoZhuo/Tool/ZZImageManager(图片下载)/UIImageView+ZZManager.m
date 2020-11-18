//
//  UIImageView+ZZManager.m
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/18.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#import "UIImageView+ZZManager.h"
#import "ZZImageManager.h"


@implementation UIImageView (ZZManager)
-(void)ZZDownloadImageWithURL:(NSString *)url andPlaceholderImage:(UIImage *) placeholderImage{
    //初始化  设置默认图片 防止Cell 重用错乱的问题
    if (placeholderImage) {
        self.image = placeholderImage;
    }else{
        self.image = nil;
    }
    [[ZZImageManager shareManager]ZzManagerDownLoadWithUrl:url andFinishHandlerSucess:^(UIImage *image) {
        //下载完成后  加载图片
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
        });
    } andError:^(NSError *error) {
        
    }];
}
@end
