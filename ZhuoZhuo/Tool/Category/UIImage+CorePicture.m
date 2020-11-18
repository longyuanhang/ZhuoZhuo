//
//  UIImage+CorePicture.m
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/18.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#import "UIImage+CorePicture.h"

@implementation UIImage (CorePicture)

+(void)drawImgWithBounds:(CGRect)rect{
//开始上下文
   UIGraphicsBeginImageContext(rect.size);
   CGContextRef context = UIGraphicsGetCurrentContext();
    
    //填充色
   [[UIColor whiteColor] set];
    
//    CGRect bigRect = CGRectMake(rect.origin.x + kBorderWith,
//    rect.origin.y+ kBorderWith,
//    rect.size.width - kBorderWith*2,
//    rect.size.height - kBorderWith*2);
    
    CGRect bigRect = CGRectMake(rect.origin.x + 2,
                                 rect.origin.y+ 2,
                                 rect.size.width - 2*2,
                                 rect.size.height - 2*2);
    
    CGContextSetLineWidth(context, 3);
    
   UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
   UIGraphicsEndImageContext();
}
@end
