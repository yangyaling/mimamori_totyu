//
//  MasterController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/4/28.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "MasterController.h"
#import "OtherCollectionCell.h"


@interface MasterController ()
@property (strong, nonatomic) IBOutlet DropButton            *facilityBtn;

@property (strong, nonatomic) IBOutlet UICollectionView      *collectionView;

@property (nonatomic, strong) NSArray                        *titleArray;
@property (nonatomic, strong) NSString                       *masterUser;

@end

@implementation MasterController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.masterUser = [NITUserDefaults objectForKey:@"MASTER_UERTTYPE"];
    [self setUI];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}

-(void)setUI {
    
    _titleArray = @[@"マスタ関連" ,@"",@"施設情報",@"機器情報",@"使用者情報（見守る人）",@"入居者情報（見守られる人）"];
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
    
    
    if ([self.masterUser isEqualToString:@"2"] && indexPath.row == 0) {
        cell.cellTitle.backgroundColor = [UIColor lightGrayColor];
    }
    
    
    if (indexPath.item == 1) {
        cell.cellTitle.backgroundColor = [UIColor whiteColor];
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
    if (indexPath.item == 0) {
        if (![self.masterUser isEqualToString:@"2"]) {
            [self performSegueWithIdentifier:@"pushberelated" sender:self];
        }
    } else if (indexPath.item == 1){
//        [self performSegueWithIdentifier:@"selfPush" sender:self];
    } else if (indexPath.item == 2){
        [self performSegueWithIdentifier:@"pushIntelligence" sender:self];
        
    } else if (indexPath.item == 3){
        [self performSegueWithIdentifier:@"pushMachine" sender:self];
    } else if (indexPath.item == 4){
        [self performSegueWithIdentifier:@"pushUserMaster" sender:self];
    } else {
        [self performSegueWithIdentifier:@"pushHomeMaster" sender:self];
    }
}

@end
