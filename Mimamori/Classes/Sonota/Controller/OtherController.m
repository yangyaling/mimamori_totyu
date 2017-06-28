//
//  OtherController.m
//  Mimamori
//
//  Created by NISSAY IT on 2016/12/14.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "OtherController.h"
#import "OtherCollectionCell.h"
#import "AppDelegate.h"

#import "MHttpTool.h"


/**
 その他画面のコントローラ
 */
@interface OtherController ()<UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView      *collectionview;

@property (strong, nonatomic) IBOutlet UIButton              *OutButton;

@property (nonatomic, strong) NSArray                        *titleArray;  //クラスのボタン名
@property (strong, nonatomic) IBOutlet DropButton            *facilitiesBtn;


/** ユーザー权限*/
@property (nonatomic, strong) NSString                       *MasterUser;

@end

@implementation OtherController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleArray = @[@"見守り\n設定" ,@"ユーザ\n情報",@"管理者\n機能",@"ヘルプ\n機能",@"お問合せ\n機能",@""];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.sectionInset = UIEdgeInsetsMake(15, 30, 30, 30);
    
    //
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //
    layout.itemSize = CGSizeMake((self.view.width - 90) / 2.0, 70);
    
    
    [self.collectionview setCollectionViewLayout:layout];
    
    
    /** ユーザー权限*/
    _MasterUser = [NITUserDefaults objectForKey:@"MASTER_UERTTYPE"];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}



/**
 Logout method
 */
- (IBAction)OutAtion:(UIButton *)sender {
    
    [NITDeleteAlert SharedAlertShowMessage:@"ログアウトします。よろしいですか。" andControl:self withOk:^(BOOL isOk) {
        // 1. ログインFlag -> 1(未登録)
        // 2. 删除缓存数据(data)
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *plistPath = [NITDocumentDirectory stringByAppendingPathComponent:@"loginFlgRecord.plist"];
        [manager removeItemAtPath:NITDataPath error:nil];
        BOOL blDele= [manager removeItemAtPath:plistPath error:nil];
        if (blDele) {
            NITLog(@"登录记录清除成功");
        }else {
            NSLog(@"dele fail");
            [MBProgressHUD showError:@"delete fail"];
            return ;
        }
        
        NSArray *arr = nil;
        [NITUserDefaults setObject:arr forKey:@"FacilityList"];
        [NITUserDefaults setObject:arr forKey:@"CellImagesName"];
        [NITUserDefaults setObject:arr forKey:@"TempcellImagesName"];
        [NITUserDefaults setObject:arr forKey:@"TempFacilityName"];
        
        // バッファをクリアする
        NSString*appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [NITUserDefaults removePersistentDomainForName:appDomain];
        
        
        // back to Login class
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [appDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"LoginIdentifier"];
        
        // タイマー   ストップ
        [appDelegate stopTimer];
    }];
    
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OtherCollectionCell * cell  = [OtherCollectionCell CellWithCollectionView:collectionView andIndexPath:indexPath];
    if ([self.MasterUser isEqualToString:@"3"] && indexPath.row == 2) {
        cell.cellTitle.backgroundColor = [UIColor grayColor];
    }
    
    cell.cellTitle.text = _titleArray[indexPath.item];
    
    return cell;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}



/**
 push ->他のクラス
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        [self performSegueWithIdentifier:@"settingpush" sender:self];
    } else if (indexPath.item == 1){
        [self performSegueWithIdentifier:@"selfPush" sender:self];
    } else if (indexPath.item == 2){
        if (![self.MasterUser isEqualToString:@"3"]) {
            [self performSegueWithIdentifier:@"pushMasterC" sender:self];
        }
    } else {
       
    }
}

@end
