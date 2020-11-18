//
//  ZModel.h
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/18.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#import <ZhuoZhuo/ZhuoZhuo.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSString+Height.h"

#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height


@interface ZModel : RDMTCellData
//为了不重复计算高度
@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,assign)CGFloat rLabelHeight;
@property (nonatomic,assign)CGFloat bLabelHeight;
@property (nonatomic,assign)CGFloat imageHeight;
@property (nonatomic,assign)CGFloat padding;
-(void)caculateCellHeight;
@end



