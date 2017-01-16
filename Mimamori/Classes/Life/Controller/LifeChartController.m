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

#import "MozTopAlertView.h"

#import "SinarioDetailController.h"

#import "DetailController.h"

#import "AriScenarioController.h"

#define Surplus 330
#define NITVersionKey @"version"

@interface LifeChartController ()<PopUpdateChartDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageIcon;
@property (strong, nonatomic) IBOutlet UIView      *leftbgView;

@property (strong, nonatomic) IBOutlet UIButton *arautoButton;
@property (strong, nonatomic) IBOutlet UIButton *sinarioButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (strong, nonatomic) UITableView *myTableView;

@property (strong, nonatomic) IBOutlet UICollectionView *myCollection;

/**
 *  总数组
 */
@property (strong, nonatomic) NSMutableArray            *ZworksDataArray;
@property (strong, nonatomic) NSMutableArray            *controlarr;
@property (strong, nonatomic) NSMutableArray            *CLArray;
@property (nonatomic) int                                              xnum;

@property (nonatomic,strong) UIView                       *hoverView;

@property (nonatomic,strong) UIImageView                  *bigImg;

@end

@implementation LifeChartController

static NSString * const reuseIdentifier = @"ZworksCLCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageIcon.layer.cornerRadius = 6;
    self.imageIcon.layer.masksToBounds = YES;
    self.imageIcon.userInteractionEnabled = YES;
    self.leftbgView.layer.cornerRadius = 6;
    self.arautoButton.layer.cornerRadius = 6;
    self.sinarioButton.layer.cornerRadius = 6;
    
    if ([self.ariresult isEqualToString:@"異常検知あり"]) {
        self.arautoButton.enabled = YES;
        
    } else {
         self.arautoButton.enabled = NO;
        [self.arautoButton setTitle:@"なし❌" forState:UIControlStateNormal];
    }
    
    [self.segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} forState:UIControlStateNormal];
    
    NSData *imgdata =  [NITUserDefaults objectForKey:self.userid0];
    if (imgdata) {
        self.imageIcon.image = [UIImage imageWithData:imgdata];
    }
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick)];
    [self.imageIcon addGestureRecognizer:gesture];
    
    [self.myCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self collectionViewsets];
    
//    self.xnum = 0;
    // 取得日单位的数据
    [self getSensorDataInfoWithType:MSensorDataTypeDaily];
    
    
    [self chooesfirst];
}


/**
  放大图片
 */
- (void)imageViewClick {
    self.hoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, NITScreenW, NITScreenH)];
    self.hoverView.backgroundColor = [UIColor blackColor];
    [self.hoverView addTapAction:@selector(moveToOrigin) target:self];
    self.hoverView.alpha = 0.0f;
    [self.navigationController.view addSubview:self.hoverView];
    
    self.bigImg = [[UIImageView alloc]init];
    [self.navigationController.view addSubview:self.bigImg];
    
    self.bigImg.image = self.imageIcon.image;
    CGFloat widthI = self.bigImg.image.size.width;
    CGFloat heightI = self.bigImg.image.size.height;
    CGFloat maxW = NITScreenW;
    CGFloat maxH = NITScreenH - 100;
    if (widthI > NITScreenW) {
        heightI = maxW / widthI * heightI;
        widthI = maxW;
    }
    if (heightI > maxH) {
        heightI = maxH;
    }
    //            ZLLog(@"%f-%f",widthI,heightI);
    [self moveToCenterWidth:widthI withHeight:heightI];
    [self.bigImg addTapAction:@selector(moveToOrigin) target:self];
}


//选择根控制器
- (void)chooesfirst{
// /   获取当前的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
   // //获取上一次的版本号
    NSString *lasteVersion = [NITUserDefaults objectForKey:NITVersionKey];
    ///判断当前是否有新版本
    if (![currentVersion isEqualToString:lasteVersion]) {
//       / //保存当前版本,用偏好设置
        [NITUserDefaults setObject:currentVersion forKey:NITVersionKey];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [MozTopAlertView showWithType:MozAlertTypeWarning text:@"プルしないとデータが更新されない" doText:@" X " doBlock:^{
                
            } parentView:self.view];
        });
    });
    
    }
}



/**
   anato页面的跳转

 */
- (IBAction)ArautoPush:(UIButton *)sender {
    [self performSegueWithIdentifier:@"aratopush" sender:self];
}


/**
   scenario一览页面的跳转
 
 */
- (IBAction)SinarioPush:(UIButton *)sender {
    [self performSegueWithIdentifier:@"sinariopush" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"sinariopush"]){
        
        SinarioDetailController * sdc = segue.destinationViewController;
        
        sdc.user0 = self.userid0;
        
    }else if ([segue.identifier isEqualToString:@"aratopush"]) {
        AriScenarioController * asc = segue.destinationViewController;
        
        asc.usernumber = self.userid0;
        
        asc.username = self.username;
        
        asc.isPushOrPop = YES;
    }
    
}




- (IBAction)selectAction:(UISegmentedControl *)sender {
    
    _xnum = (int)sender.selectedSegmentIndex;
    [self reloadList];
}


/**
 *   サーバよりデータを取得
 */
-(void)getSensorDataInfoWithType:(MSensorDataType)type{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    // 请求参数
    MSensorDataParam *param = [[MSensorDataParam alloc]init];
    
    param.nowdate = [[NSDate date]needDateStatus:HaveHMSType];
    
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    
    param.userid0 = self.userid0;
    //日単位
    if (type == MSensorDataTypeDaily) {
        param.deviceclass = @"1";
    }
    //NSError	NSError	domain: @"NSURLErrorDomain" - code: 18446744073709550615
    
    
    [MSensorDataTool sensorDataWithParam:param type:type success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSArray *tmpArr = [ZworksChartModel mj_objectArrayWithKeyValuesArray:dic[@"deviceinfo"]];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *imagestr = dic[@"picpath"];
            if (imagestr.length) {
                NSData *dataicon = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagestr]];
                if (dataicon) {
                    self.imageIcon.image = [UIImage imageWithData:dataicon];
                    [NITUserDefaults setObject:dataicon forKey:self.userid0];
                }
            } else {
                NITLog(@"图片地址为空");
            }
//        });
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
                ChartC.updatedelegate = self;
                ChartC.superrow = i;
                [self addChildViewController:ChartC];
                [self.controlarr addObject:ChartC]; //viewC放到数组里面
            }
            
            _myCollection.contentSize = self.myCollection.size;
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

- (void)updateCorrentTB:(int)numChart {
    self.xnum = numChart;
    [self reloadList];
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

//显示大图片到屏幕中心
- (void)moveToCenterWidth:(CGFloat)widthI withHeight:(CGFloat)heightI
{
    [UIView animateWithDuration:0.5 animations:^{
        self.hoverView.alpha = 1.0f;
        self.bigImg.frame = CGRectMake((NITScreenW - widthI)/2.0, (NITScreenH - heightI)/2.0 , widthI, heightI);
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}

//移除图
- (void)moveToOrigin
{
    [UIView animateWithDuration:0.5 animations:^{
        self.hoverView.alpha = 0.0f;
        self.bigImg.frame = CGRectMake(NITScreenW/2.0, NITScreenH/2.0, 6, 6);
    } completion:^(BOOL finished) {
        [self.hoverView removeFromSuperview];
        [self.bigImg removeFromSuperview];
        //        self.hoverView = nil;
        self.bigImg = nil;
    }];
}



@end
