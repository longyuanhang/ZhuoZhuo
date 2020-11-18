//
//  MainCollectionCell.m
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/17.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#import "MainCollectionCell.h"
#import "NSString+imageWithBase64.h"
#import "UIImageView+ZZManager.h"
@interface MainCollectionCell ()
@property (nonatomic,strong) UIImageView *mainImageView;
@property (nonatomic,strong) UILabel *mainTitleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UIImage *dImage;
@end




@implementation MainCollectionCell
-(UIImageView *)mainImageView{
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc]init];
    }
    return _mainImageView;
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
    }
    return _headImageView;
}

-(UILabel *)mainTitleLabel{
    if (!_mainTitleLabel) {
        _mainTitleLabel = [[UILabel alloc]init];
        _mainTitleLabel.font = [UIFont systemFontOfSize:17];
        _mainTitleLabel.textColor = [UIColor redColor];
        _mainTitleLabel.numberOfLines = 0 ;
    }
    return _mainTitleLabel;
}

-(UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = [UIFont systemFontOfSize:17];
        _subTitleLabel.textColor = [UIColor blueColor];
        _subTitleLabel.numberOfLines = 0;
    }
    
    return _subTitleLabel;
}

-(UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _deleteButton;
}


//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.mainTitleLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.mainImageView];
        [self.contentView addSubview:self.mainTitleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.deleteButton];
        [self.deleteButton addTarget:self action:@selector(didClickButton) forControlEvents:UIControlEventTouchUpInside];
        self.contentView.backgroundColor = [UIColor grayColor];
    }
    return self;
}

-(void)setZModel:(ZModel *)zModel{
    self.mainImageView.backgroundColor = [UIColor blueColor];
    self.mainImageView.frame = CGRectMake(0, 0,( ScreenWidth-zModel.padding)/2, zModel.imageHeight);
    self.mainTitleLabel.frame = CGRectMake(0, zModel.imageHeight,( ScreenWidth-zModel.padding)/2, zModel.rLabelHeight);
    self.mainTitleLabel.text = zModel.TitleText;
    self.subTitleLabel.frame = CGRectMake(0,zModel.imageHeight+zModel.rLabelHeight,( ScreenWidth-zModel.padding)/2, zModel.bLabelHeight);
    self.subTitleLabel.text = zModel.SecondTitleText;
    self.headImageView.frame =CGRectMake(10, self.subTitleLabel.frame.origin.y+zModel.bLabelHeight, 40, 40);
    self.headImageView.image = [NSString imageWithBase64:zModel.HeadImgBase64];
    self.deleteButton.hidden = zModel.CanDel;
    [self.mainImageView ZZDownloadImageWithURL:zModel.Image.ImageUrl andPlaceholderImage:[UIImage imageNamed:@"ic_placeholder"]];
    self.deleteButton.frame = CGRectMake(self.frame.size.width-50, self.headImageView.frame.origin.y, 30, 30);
    self.deleteButton.backgroundColor = [UIColor redColor];
}


//点击删除按钮  回调
-(void)didClickButton{
    if (self.block) {
        self.block();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end

