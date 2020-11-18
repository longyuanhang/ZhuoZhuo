//
//  WaterFlowLayout.h
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/18.
//  Copyright © 2020 wisesoft. All rights reserved.
//
#import <UIKit/UIKit.h>

extern NSString *const kSupplementaryViewKindHeader;

@protocol CollectionWaterfallLayoutProtocol;
@interface CollectionWaterfallLayout : UICollectionViewLayout

@property (nonatomic, weak) id<CollectionWaterfallLayoutProtocol> delegate;
@property (nonatomic, assign) NSUInteger columns;
@property (nonatomic, assign) CGFloat columnSpacing;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) UIEdgeInsets insets;

@end



@protocol CollectionWaterfallLayoutProtocol <NSObject>

- (CGFloat)collectionViewLayout:(CollectionWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)collectionViewLayout:(CollectionWaterfallLayout *)layout heightForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath;

@end
