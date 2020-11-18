//
//  NSString+Height.h
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/18.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Height)
//计算文本高度
+(CGFloat)getTextHeighyWithFont:(UIFont *)font andText:(NSString *)text andWidth:(CGFloat)width;


@end




