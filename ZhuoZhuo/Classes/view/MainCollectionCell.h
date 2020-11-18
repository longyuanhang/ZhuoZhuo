//
//  MainCollectionCell.h
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/17.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZModel.h"

typedef void(^DeleteBlock)(void);
@interface MainCollectionCell : UICollectionViewCell
@property (nonatomic,strong)ZModel *zModel;
@property (nonatomic,copy) DeleteBlock block;
@end

