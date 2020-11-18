//
//  NewWorkTool.m
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/17.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#import "NewWorkTool.h"

#define DataNotFound @"DataNotFound"
@interface NewWorkTool ()
@property (nonatomic,retain)dispatch_queue_t currentQueue;
@end
@implementation NewWorkTool



+(instancetype)shareManager{
    static NewWorkTool *netTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netTool = [[NewWorkTool alloc]init];
        netTool.currentQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    });
    return netTool;
}

+(void)getFileDataWithUrl:(NSString *)url Success:(void(^)(NSArray *array))sucess andError:(void(^)(NSError *error))error{
    NewWorkTool *tool = [NewWorkTool shareManager];
    dispatch_async(tool.currentQueue, ^{
        NSError *err = [NSError errorWithDomain:@"" code:404 userInfo:@{@"msg":DataNotFound}];
        NSArray *array = GetListData__NotAllowInMainThread();
        dispatch_async(dispatch_get_main_queue(), ^{
            if (array) {
                sucess(array);
            }else{
                error(err);
            }
        });
    });
    
}


@end

