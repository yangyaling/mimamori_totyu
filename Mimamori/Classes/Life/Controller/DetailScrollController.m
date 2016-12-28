//
//  DetailScrollController.m
//  Mimamori
//
//  Created by 楊亜玲 on 16/9/26.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "DetailScrollController.h"

#import "DetailChartViewController.h"
#import "ZworksChartModel.h"

#define Surplus 93

@interface DetailScrollController ()

@property (nonatomic, strong) NSMutableArray                 *controllersArray;  //控制器数组

@end

@implementation DetailScrollController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //タイトル
    self.navigationItem.title = [NSString stringWithFormat:@"%@（%@）",self.chartModel.devicename,self.chartModel.nodename];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    //从缓存中取得点击的是第几页进入详细页面的
    
    [self setupControllers];
    
    [self setupCollectionView];
    
}



- (void)setupControllers
{
    self.controllersArray = [NSMutableArray new];
    
    for (int i = 0; i < self.SumPage; i++) {
        
        NSString *dateStr = [NSDate otherDay:[NSDate date] symbols:LGFMinus dayNum:fabs(i-6.0)];
        
        DetailChartViewController *VC  = [[DetailChartViewController alloc] init];
        
        VC.dateString = dateStr;
        VC.nodeId = self.chartModel.nodeid;
        VC.userid0 = self.userid0;
        VC.subdeviceinfo = self.chartModel.subdeviceinfo;
        
        [self addChildViewController:VC];
        
        [self.controllersArray addObject:VC]; //viewC放到数组里面
        
    }
   
}



/**
 *  定义collection的一些相关属性 / cell的id注册
 */
- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumLineSpacing = 0;
    
    flowLayout.minimumInteritemSpacing = 0;
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;  //水平
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.collectionViewLayout = flowLayout;
    
    self.collectionView.showsHorizontalScrollIndicator = NO;      //滚动条
    
    self.collectionView.pagingEnabled = YES;             //分页
    
    flowLayout.itemSize = CGSizeMake(NITScreenW, NITScreenH - Surplus);
    
    self.collectionView.contentOffset = CGPointMake(self.selectindex * NITScreenW, 0);
    
    [self.collectionView reloadData];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.SumPage;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *view = [self.controllersArray[indexPath.item] view];
    
    [cell.contentView addSubview:view];
    
    view.size = cell.size;
    
    return cell;
}



@end
