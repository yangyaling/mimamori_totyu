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

#import "MHttpTool.h"


@interface OtherController ()<UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView      *collectionview;

@property (strong, nonatomic) IBOutlet UIButton              *OutButton;

@property (nonatomic, strong) NSArray                        *titleArray;
@property (strong, nonatomic) IBOutlet DropButton            *facilitiesBtn;

@property (nonatomic, strong) NSString                       *MasterUser;

@end

@implementation OtherController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleArray = @[@"見守り設定" ,@"ユーザ情報",@"管理者機能",@"ヘルプ機能",@"お問合せ機能",@""];
    
    //-----お問合せ
    
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
    
    _MasterUser = [NITUserDefaults objectForKey:@"MASTER_UERTTYPE"];
    
    
//    NSString *string =@"sw00007";
//    string = [string substringFromIndex:string.length - 5];
//    NSRange range = [string rangeOfString:@"0"];//匹配得到的下标
//    NSLog(@"rang:%@",NSStringFromRange(range));
//    string = [string substringWithRange:range];//截取范围类的字符串
//    NSLog(@"截取的值为：%@",string);
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}

/**
 弹出下拉设施菜单
 
 @param sender
 */
-(void)showSelectedList {
    
}


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
        
        // 3 删除缓存数据(既読のお知らせアラート)
        //[NITUserDefaults removeObjectForKey:@"readnotice"];
        
        //清空设施数组
        //        NSArray *alldropArray = [NITUserDefaults objectForKey:@"FacilityList"];
        //        NSArray *imagesArray = [NITUserDefaults objectForKey:@"CellImagesName"];
        //        NSArray *tmpimagesArray = [NITUserDefaults objectForKey:@"TempcellImagesName"];
        //        NSArray *facitilityname = [NITUserDefaults objectForKey:@"TempFacilityName"];
        //        alldropArray = nil;
        //        imagesArray = nil;
        //        tmpimagesArray = nil;
        //        facitilityname = nil;
        //        [NITUserDefaults setObject:alldropArray forKey:@"FacilityList"];
        //        [NITUserDefaults setObject:imagesArray forKey:@"CellImagesName"];
        //        [NITUserDefaults setObject:tmpimagesArray forKey:@"TempcellImagesName"];
        //        [NITUserDefaults setObject:facitilityname forKey:@"TempFacilityName"];
        
        // 清除缓存
        NSString*appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [NITUserDefaults removePersistentDomainForName:appDomain];
        
        
        // 4.返回登录页面
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [appDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"LoginIdentifier"];
        
        // 5.移除定时器
        [appDelegate stopTimer];
    }];
    
    
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
    if ([self.MasterUser isEqualToString:@"3"] && indexPath.row == 2) {
        cell.cellTitle.backgroundColor = [UIColor grayColor];
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
