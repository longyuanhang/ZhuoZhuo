//
//  ZZImageManager.h
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/17.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ZZImageManager : NSObject

+(ZZImageManager *)shareManager;

//下载图片
-(void)ZzManagerDownLoadWithUrl:(NSString *)url andFinishHandlerSucess:(void(^)(UIImage *image))image andError:(void(^)(NSError *error))error;



//清除磁盘缓存
-(void)clearDisk;
//清除内存缓存
-(void)clearCache;

@end
