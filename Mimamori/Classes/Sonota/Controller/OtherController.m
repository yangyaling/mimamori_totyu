//
//  OtherController.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "OtherController.h"
#import "OtherCollectionCell.h"
#import "AppDelegate.h"

@interface OtherController ()<UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;

@property (strong, nonatomic) IBOutlet UIButton        *OutButton;

@property (nonatomic, strong) NSArray                  *titleArray;

@end

@implementation OtherController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleArray = @[@"見守り設定" ,@"ユーザ情報",@"ヘルプ機能",@"お問合せ"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.OutButton.layer.cornerRadius = 5;
    
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.sectionInset = UIEdgeInsetsMake(15, 30, 30, 30);
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake((self.view.width - 90) / 2.0, 70);
    
    
    [self.collectionview setCollectionViewLayout:layout];
    
}

- (IBAction)OutAtion:(UIButton *)sender {
    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:nil message:@"ログアウトします。よろしいですか。" preferredStyle: UIAlertControllerStyleAlert];
    [alert2 addAction:[UIAlertAction actionWithTitle:@"はい" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        // 1. ログインFlag -> 1(未登録)
        [NITUserDefaults setObject:@"1" forKey:@"loginFlg"];
        // 2. 删除缓存数据(data)
        NSFileManager *manager = [NSFileManager defaultManager];
        
        [manager removeItemAtPath:NITDataPath error:nil];
        
        // 3 删除缓存数据(既読のお知らせアラート)
        [NITUserDefaults removeObjectForKey:@"readnotice"];
        
        // 4.返回登录页面
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [appDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"LoginIdentifier"];
        
        // 5.移除定时器
        [appDelegate removeTimer];
        
    }]];
    
    [alert2 addAction:[UIAlertAction actionWithTitle:@"いいえ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }]];
    [self presentViewController:alert2 animated:true completion:nil];
}


//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OtherCollectionCell * cell  = [OtherCollectionCell CellWithCollectionView:collectionView andIndexPath:indexPath];
    
    cell.layer.masksToBounds = YES;
    
    cell.layer.cornerRadius = 5;
    
    cell.cellTitle.text = _titleArray[indexPath.item];
    
    return cell;
}


//横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}


//纵向
- (CGFloat)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        [self performSegueWithIdentifier:@"settingpush" sender:self];
    } else if (indexPath.item == 1){
        [self performSegueWithIdentifier:@"selfPush" sender:self];
    } else if (indexPath.item == 2){
        
    } else {
       
    }
}

@end
