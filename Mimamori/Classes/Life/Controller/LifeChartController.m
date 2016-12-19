//
//  LifeChartController.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/15.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "LifeChartController.h"

#import "MSensorDataTool.h"

#import "ZworksChartModel.h"

#import "NITRefreshInit.h"

#import "ZworksChartTBVC.h"
#define Surplus 345

@interface LifeChartController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageIcon;
@property (strong, nonatomic) IBOutlet UIView *leftbgView;

@property (strong, nonatomic) IBOutlet UIButton *arautoButton;
@property (strong, nonatomic) IBOutlet UIButton *sinarioButton;

@property (strong, nonatomic) UITableView *myTableView;

@property (strong, nonatomic) IBOutlet UICollectionView *myCollection;

/**
 *  总数组
 */
@property (strong, nonatomic) NSMutableArray            *ZworksDataArray;
@property (strong, nonatomic) NSMutableArray            *controlarr;
@property (strong, nonatomic) NSMutableArray            *CLArray;
@property (nonatomic) int                                              xnum;


@end

@implementation LifeChartController

static NSString * const reuseIdentifier = @"ZworksCLCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageIcon.layer.cornerRadius = 6;
    self.imageIcon.layer.masksToBounds = YES;
    self.leftbgView.layer.cornerRadius = 6;
    self.arautoButton.layer.cornerRadius = 6;
    self.sinarioButton.layer.cornerRadius = 6;
    
    NSData *imgdata =  [NITUserDefaults objectForKey:@"usericon"];
    
    if (imgdata)  self.imageIcon.image = [UIImage imageWithData:imgdata];
    
    [self.myCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self collectionViewsets];
    
    // 取得日单位的数据
    [self getSensorDataInfoWithType:MSensorDataTypeDaily];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    
}
- (IBAction)ArautoPush:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"aripush" sender:self];
}

- (IBAction)SinarioPush:(UIButton *)sender {
    [self performSegueWithIdentifier:@"sinariopush" sender:self];
}




- (IBAction)selectAction:(UISegmentedControl *)sender {
    
    _xnum = (int)sender.selectedSegmentIndex;
    [self reloadList];
}


/**
 *   サーバよりデータを取得
 */
-(void)getSensorDataInfoWithType:(MSensorDataType)type{
    
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    // 请求参数
    MSensorDataParam *param = [[MSensorDataParam alloc]init];
    
    param.nowdate = [[NSDate date]needDateStatus:HaveHMSType];
    
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    
    param.userid0 = self.userid0;
    //日単位
    if (type == MSensorDataTypeDaily) {
        param.deviceclass = @"0";
        param.nodeid = self.roomID;
    }
    //NSError	NSError	domain: @"NSURLErrorDomain" - code: 18446744073709550615
    
    
    [MSensorDataTool sensorDataWithParam:param type:type success:^(NSArray *array) {
        [MBProgressHUD hideHUDForView:self.view];
        [_myTableView.mj_header endRefreshing];
        
        NSArray *tmpArr = [ZworksChartModel mj_objectArrayWithKeyValuesArray:array];
        if (tmpArr.count == 0) {
            [_ZworksDataArray removeAllObjects];
            [MBProgressHUD showError:@"データがありません"];
        }else{
            _ZworksDataArray = [NSMutableArray arrayWithArray:tmpArr];
            ZworksChartModel *model = _ZworksDataArray[0];
            _CLArray = [NSMutableArray arrayWithArray:model.devicevalues];
            
            self.controlarr = [NSMutableArray new];
            for (int i = 0; i < _CLArray.count; i++) {
                UIStoryboard *lifesb = [UIStoryboard storyboardWithName:@"Life" bundle:nil];
                ZworksChartTBVC *ChartC = [lifesb instantiateViewControllerWithIdentifier:@"charttbcellview"];
                
                ChartC.zarray = _ZworksDataArray;
                ChartC.xnum = _xnum;
                ChartC.userid0 = _userid0;
                ChartC.superrow = i;
                [self addChildViewController:ChartC];
                [self.controlarr addObject:ChartC]; //viewC放到数组里面
            }
            
            _myCollection.contentSize = CGSizeMake(NITScreenW,NITScreenH-Surplus);
            _myCollection.contentOffset = CGPointMake((NITScreenW)*_CLArray.count-1, 0);
            [_myCollection reloadData];
        }
        
    } failure:^(NSError *error) {
        NSString *str = [error localizedDescription];
        NITLog(@"%@",str);
        [MBProgressHUD hideHUDForView:self.view];
        
        [MBProgressHUD showError:@"後ほど試してください"];
    }];
    
}


-(void)reloadList{
    
    if (_xnum==0) {
        self.myTableView.allowsSelection = YES;
        [self getSensorDataInfoWithType:MSensorDataTypeDaily];
        
    }else if(_xnum==1){
        self.myTableView.allowsSelection = NO;
        [self getSensorDataInfoWithType:MSensorDataTypeWeekly];
        
        
    }else if(_xnum==2){
        self.myTableView.allowsSelection = NO;
        [self getSensorDataInfoWithType:MSensorDataTypeMontyly];
    }
}

-(void)collectionViewsets{
    
    _myCollection.showsHorizontalScrollIndicator = NO;
    
    _myCollection.pagingEnabled =YES;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumLineSpacing = 0;
    
    //    flowLayout.minimumInteritemSpacing = 0;
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    flowLayout.itemSize = CGSizeMake(NITScreenW, NITScreenH - Surplus);
    
    
    _myCollection.collectionViewLayout = flowLayout;
    
    _myCollection.backgroundColor = [UIColor clearColor];
    
    //    _ZworksCV.alwaysBounceVertical = YES;
    
}

#pragma mark ----------UICollectionViewDataSource-------------
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _controlarr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *view = [_controlarr[indexPath.item]view];
    view.size = cell.size;
    [cell.contentView addSubview:view];
    
    return cell;
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    if (_ZworksTB) {
//        [NITUserDefaults setInteger:_ZworksTB.contentOffset.x forKey:@"offsetX"];
//        [NITUserDefaults setInteger:_ZworksTB.contentOffset.y forKey:@"offsetY"];
//    }
//}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO ;  //cell无法被点击
}



@end
