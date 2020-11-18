//
//  NSString+Height.m
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/18.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#import "NSString+Height.h"

@implementation NSString (Height)
+(CGFloat)getTextHeighyWithFont:(UIFont *)font andText:(NSString *)text andWidth:(CGFloat)width{
    if(text.length == 0||!text){
        return 0;
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    return rect.size.height;
}
@end
