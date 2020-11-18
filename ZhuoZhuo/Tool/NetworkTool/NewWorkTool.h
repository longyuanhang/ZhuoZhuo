//
//  NewWorkTool.h
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/17.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZhuoZhuo/ZhuoZhuo.h>
@interface NewWorkTool : NSObject
+(instancetype)shareManager;
+(void)getFileDataWithUrl:(NSString *)url Success:(void(^)(NSArray *array))sucess andError:(void(^)(NSError *error))error;

@end

