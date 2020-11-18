//
//  NSString+MD5.m
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/18.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
@implementation NSString (MD5)

-(NSString *)stringToMD5{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)stringFromBytes:(unsigned char *)bytes length:(NSUInteger)length
{
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}
@end
