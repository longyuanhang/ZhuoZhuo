//
//  ZModel.m
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/18.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#import "ZModel.h"

@implementation ZModel

-(instancetype)init{
    self=[super init];
    return self;
}
-(CGFloat)padding{
    return 10;
}
-(void)caculateCellHeight{
    self.rLabelHeight = [NSString getTextHeighyWithFont:[UIFont systemFontOfSize:17] andText:self.TitleText andWidth:(ScreenWidth-self.padding)/2];
    self.bLabelHeight = [NSString getTextHeighyWithFont:[UIFont systemFontOfSize:17] andText:self.SecondTitleText andWidth:(ScreenWidth-self.padding)/2];
    if (self.Image.ImageWidth!=0&&self.Image.ImageHeight!=0) {
        self.imageHeight = (ScreenWidth-self.padding)/2*(self.Image.ImageHeight/self.Image.ImageWidth);
    }else{
        self.imageHeight = 0;
    }
    self.cellHeight = self.rLabelHeight+self.bLabelHeight+self.imageHeight+50;
    NSLog(@"%f",self.cellHeight);
}

@end
