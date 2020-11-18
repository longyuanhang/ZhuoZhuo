//
//  MainViewController.m
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/17.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#define baseUrl @"ssss"

#import "ZZImageManager.h"

#import "MainViewController.h"
#import "NewWorkTool.h"
#import "MainCollectionCell.h"
#import "NSString+Height.h"
#import "CollectionWaterfallLayout.h"
@interface MainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CollectionWaterfallLayoutProtocol>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic,strong) CollectionWaterfallLayout *flowOut;
@property (nonatomic,strong) NSMutableArray <ZModel *>*dataArray;
@end
static NSString *CellId = @"ZCell";

@implementation MainViewController


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}

-(void)initView{
    self.flowOut = [[CollectionWaterfallLayout alloc]init];
    self.flowOut.delegate = self;
    self.flowOut.columns =2;
    self.flowOut.columnSpacing = 5;
    self.flowOut.itemSpacing = 5;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:self.flowOut];
    [self.collectionView registerClass:[MainCollectionCell class] forCellWithReuseIdentifier:CellId];
    self.collectionView.delegate = self;
    self.collectionView.dataSource =self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

//获取数据
-(void)getData{
    [NewWorkTool getFileDataWithUrl:baseUrl Success:^(NSArray *array) {
        for (RDMTCellData *model in array) {
            ZModel *data = [[ZModel alloc]init];
            data.DataType = model.DataType;
            data.HeadImgBase64 = model.HeadImgBase64;
            data.Image = model.Image;
            data.TitleText = model.TitleText;
            data.SecondTitleText=model.SecondTitleText;
            data.CanDel = model.CanDel;
            [self.dataArray addObject:data];
        }
        // self.dataArray = [NSMutableArray arrayWithArray:array];
        [self caculateCellHeight];
    } andError:^(NSError *error) {
        
    }];
}

//计算Cell高度
-(void)caculateCellHeight{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (ZModel *model in self.dataArray) {
            [model caculateCellHeight];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}
#pragma mark dataSource and delelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}



- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    cell.zModel = [self.dataArray objectAtIndex:indexPath.row];
    
    //点击删除按钮触发
    __weak typeof(self)weakSelf = self;
    cell.block = ^{
        [weakSelf.dataArray removeObject:weakSelf.dataArray[indexPath.row]];
        [weakSelf.collectionView reloadData];
        [UIView animateWithDuration:0.5 animations:^{
            
        }];
    };
    return cell;;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//waterFlow Delefate
//- (CGFloat)collectionViewLayout:(WaterFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath{
//    ZModel *model = [self.dataArray objectAtIndex:indexPath.row];
//    return model.cellHeight;
////    return 100.f;
//}
- (CGFloat)collectionViewLayout:(CollectionWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZModel *model = [self.dataArray objectAtIndex:indexPath.row];
    return model.cellHeight;
}


- (CGFloat)collectionViewLayout:(CollectionWaterfallLayout *)layout heightForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    //收到内存警告清理图片
    [[ZZImageManager shareManager] clearCache];
    [[ZZImageManager shareManager] clearDisk];
    
}

/*
 #
 
 - (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
 
 }
 pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


