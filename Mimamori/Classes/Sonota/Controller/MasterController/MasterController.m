//
//  MasterController.m
//  Mimamori2
//
//  Created by NISSAY IT on 2017/4/28.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import "MasterController.h"
#import "OtherCollectionCell.h"


/**
 その他＞管理者機能画面のコントローラ
 */
@interface MasterController ()
@property (strong, nonatomic) IBOutlet DropButton            *facilityBtn;

@property (strong, nonatomic) IBOutlet UICollectionView      *collectionView;

@property (nonatomic, strong) NSArray                        *titleArray;  //クラスのボタン名
@property (nonatomic, strong) NSString                       *masterUser; /** ユーザー权限*/

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
    
    _titleArray = @[@"マスタ\n関連" ,@"",@"施設情報",@"機器情報",@"使用者情報\n（見守る人）",@"入居者情報\n（見守られる人）"];
  
    
    //初期化 UICollectionViewFlowLayout
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
    
    if ([self.masterUser isEqualToString:@"2"] && indexPath.row == 0) {
        cell.cellTitle.backgroundColor = [UIColor lightGrayColor];
    }
    
    
    if (indexPath.item == 1) {
        cell.cellTitle.backgroundColor = [UIColor whiteColor];
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
    
    if (indexPath.item == 0) {
        if (![self.masterUser isEqualToString:@"2"]) {
            [self performSegueWithIdentifier:@"pushberelated" sender:self];
        }
    } else if (indexPath.item == 1){
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
