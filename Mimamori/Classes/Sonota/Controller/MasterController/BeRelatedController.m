//
//  BeRelatedController.m
//  Mimamori2
//
//  Created by NISSAY IT on 2017/4/28.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import "BeRelatedController.h"
#import "OtherCollectionCell.h"


/**
 その他＞管理者機能＞マスター関連画面のコントロール
 */
@interface BeRelatedController ()
@property (strong, nonatomic) IBOutlet DropButton            *facilityBtn;
@property (nonatomic, strong) NSArray                        *titleArray; //クラスのボタン名
@property (strong, nonatomic) IBOutlet UICollectionView      *collectionView;
@property (nonatomic, strong) NSString                       *MasterUser; /** ユーザー权限*/
@end

@implementation BeRelatedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.MasterUser = [NITUserDefaults objectForKey:@"MASTER_UERTTYPE"];
    [self setUI];
    
}


/**
 更新施設名
 */
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}



/**
 初期化 UICollectionViewFlowLayout
 */
-(void)setUI {
    _titleArray = @[@"設置場所\nマスタ" ,@"企業\nマスタ",@"施設\nマスタ",@"シナリオ\nマスタ"];
 
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.sectionInset = UIEdgeInsetsMake(15, 30, 30, 30);
 
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    layout.itemSize = CGSizeMake((self.view.width - 90) / 2.0, 70);
    
    
    [self.collectionView setCollectionViewLayout:layout];
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

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


/**
 ピッチ
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}


/**
 ピッチ
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

/**
 ボタンイベントのコントローラジャンプ
 */
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
