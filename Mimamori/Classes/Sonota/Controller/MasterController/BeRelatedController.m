//
//  BeRelatedController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/4/28.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "BeRelatedController.h"
#import "OtherCollectionCell.h"

@interface BeRelatedController ()
@property (strong, nonatomic) IBOutlet DropButton            *facilityBtn;
@property (nonatomic, strong) NSArray                        *titleArray;
@property (strong, nonatomic) IBOutlet UICollectionView      *collectionView;
@property (nonatomic, strong) NSString                       *MasterUser;
@end

@implementation BeRelatedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.MasterUser = [NITUserDefaults objectForKey:@"MASTER_UERTTYPE"];
    [self setUI];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}

-(void)setUI {
    _titleArray = @[@"設置場所\nマスタ" ,@"企業\nマスタ",@"施設\nマスタ",@"シナリオ\nマスタ"];
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.sectionInset = UIEdgeInsetsMake(15, 30, 30, 30);
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake((self.view.width - 90) / 2.0, 70);
    
    
    [self.collectionView setCollectionViewLayout:layout];
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
    if ([self.MasterUser isEqualToString:@"2"]) {
        cell.cellTitle.backgroundColor = [UIColor lightGrayColor];;
    }
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
    if ([self.MasterUser isEqualToString:@"2"]) return;
    
    if (indexPath.item == 0) {
                [self performSegueWithIdentifier:@"pushplacesetting" sender:self];
    } else if (indexPath.item == 1){
                [self performSegueWithIdentifier:@"pusdIntelligenceMaster" sender:self];
    } else if (indexPath.item == 2){
        [self performSegueWithIdentifier:@"pushFacilityMaster" sender:self];
    } else {
        [self performSegueWithIdentifier:@"pushSinarioMaster" sender:self];
    }
}


@end
