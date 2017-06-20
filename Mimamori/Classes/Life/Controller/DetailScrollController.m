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

#import "MSensorDataTool.h"
#define Surplus 148

@interface DetailScrollController ()<DropClickDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView      *collectionView;

@property (nonatomic, strong) NSMutableArray                 *controllersArray;  //controllers

@property (strong, nonatomic) IBOutlet UILabel               *ContrlTitle;

@property (strong, nonatomic) IBOutlet DropButton            *facilitiesBtn;


@property (nonatomic,strong) NSArray                         *chartArray;//chart  datas

@end

@implementation DetailScrollController

static NSString * const reuseIdentifier = @"DetailScrollCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // If YES, this navigation item will hide the back button when it's on top of the stack
    [self.navigationItem setHidesBackButton:YES];
    
    //タイトル
    self.ContrlTitle.text = [NSString stringWithFormat:@"%@（%@）%@",self.chartModel.devicename,self.chartModel.nodename,self.chartModel.displayname];
    
    // If a class is registered, it will be instantiated via alloc/initWithFrame:
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self setupCollectionView];
    
    [self getSensorDataInfoWithDate:self.datestring];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    //init
    _facilitiesBtn = [DropButton sharedDropButton];
    
    //更新施設名２
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
    
    _facilitiesBtn.DropClickDelegate = self;
    
    self.navigationItem.titleView = _facilitiesBtn;
}

/**
 *  サーバより指定日のセンサーデータを取得
 *  @param date 指定日(yyyy-MM-dd HH:mm:ss)
 */
-(void)getSensorDataInfoWithDate:(NSString *)date{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    MSensorDataParam *param = [[MSensorDataParam alloc]init];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    NSDate *getdate = [fmt dateFromString:date];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datestr = nil;
   BOOL isTure = [getdate isToday];
    if (isTure) {
        datestr = [fmt stringFromDate:[NSDate date]];
    } else {
        datestr = [fmt stringFromDate:getdate];
    }
    
    param.nowdate = datestr;
    param.staffid = [NITUserDefaults objectForKey:@"userid1"];
    param.custid = self.userid0;
    param.deviceclass = @"2";
    param.nodeid = self.chartModel.nodeid;
    
    [MSensorDataTool sensorDataWithParam:param type:MSensorDataTypeDaily success:^(NSDictionary *dic) {
      [MBProgressHUD hideHUDForView:self.view];
        NSArray *array = dic[@"deviceinfo"];
        //        NSArray *array = tempdic[@"deviceinfo"];
        if (array.count > 0) {
            // 0.数组 -> 　模型数组
            self.chartArray = array.copy;
            
            [self setupControllers];
            
            [self.collectionView reloadData];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view];
            
            [MBProgressHUD showError:@"データがありません"];
        }
        
    } failure:^(NSError *error) {
      
        [MBProgressHUD hideHUDForView:self.view];
        
        [MBProgressHUD showError:@"後ほど試してください"];
    }];
}




/**
 create page class
 */
- (void)setupControllers
{
    self.controllersArray = [NSMutableArray new];
    
    for (int i = 0; i < self.SumPage; i++) {
        
        UIStoryboard *lifesb = [UIStoryboard storyboardWithName:@"Life" bundle:nil];
        DetailChartViewController *VC = [lifesb instantiateViewControllerWithIdentifier:@"DetailChartView"];
        
        VC.automaticallyAdjustsScrollViewInsets = YES;
        
        VC.nodeId = self.chartModel.nodeid;
        
        VC.dateString = [self.chartArray[i] objectForKey:@"datestring"];
        
        VC.subdeviceinfo = [self.chartArray[i] objectForKey:@"deviceinfo"];
        
        [self addChildViewController:VC];
        
        [self.controllersArray addObject:VC];
    }
    
}



/**
  Init CollectionViewFlowLayout
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
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.collectionView.contentOffset = CGPointMake(6 * NITScreenW, 0);
        
    });
    
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
    
    view.size = cell.size;
    
    [cell.contentView addSubview:view];
    
    return cell;
}



@end
