//
//  UIImageView+ZZManager.h
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/18.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImageView (ZZManager)
-(void)ZZDownloadImageWithURL:(NSString *)url andPlaceholderImage:(UIImage *) placeholderImage;

@end

