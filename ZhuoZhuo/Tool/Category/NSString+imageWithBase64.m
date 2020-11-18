//
//  NSString+imageWithBase64.m
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/17.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#import "NSString+imageWithBase64.h"

@implementation NSString (imageWithBase64)

+(UIImage *)imageWithBase64:(NSString *)string{
    NSData * imageData =[[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *photo = [UIImage imageWithData:imageData];
    return photo;
}

@end
