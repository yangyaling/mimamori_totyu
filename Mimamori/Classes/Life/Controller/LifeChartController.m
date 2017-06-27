//
//  LifeChartController.m
//  Mimamori
//
//  Created by NISSAY IT on 2016/12/15.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "LifeChartController.h"

#import "MSensorDataTool.h"

#import "ZworksChartModel.h"

#import "NITRefreshInit.h"

#import "ZworksChartTBVC.h"

#import "MozTopAlertView.h"

#import "SinarioDetailController.h"

#import "AriScenarioController.h"

#define Surplus 364
#define NITVersionKey @"version"



/**
 グラフ クラス
 */
@interface LifeChartController ()<PopUpdateChartDelegate,DropClickDelegate>

@property (strong, nonatomic) IBOutlet UIImageView       *imageIcon;

@property (strong, nonatomic) IBOutlet UIView            *leftbgView;

@property (strong, nonatomic) IBOutlet UIButton          *arautoButton;

@property (strong, nonatomic) IBOutlet UIButton          *sinarioButton;

@property (strong, nonatomic) IBOutlet UISegmentedControl*segmentControl;

@property (strong, nonatomic) UITableView               *myTableView;

@property (strong, nonatomic) IBOutlet UICollectionView *myCollection;

/**
 all chart class
 */
@property (strong, nonatomic) NSMutableArray             *controlarr;

/**
 *  all datas
 */
@property (strong, nonatomic) NSMutableArray             *CLArray;


/**
  selected Segment Index
 */
@property (nonatomic) int                                xnum;

/**
 拡大画像の背景の図
 */
@property (nonatomic,strong) UIView                      *hoverView;



/**
 拡大後の画像
 */
@property (nonatomic,strong) UIImageView                 *bigImg;

@property (strong, nonatomic) IBOutlet DropButton        *facilitiesBtn;

@property (strong, nonatomic) IBOutlet UILabel           *titleLabelC;

@end

@implementation LifeChartController

static NSString * const reuseIdentifier = @"ZworksCLCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageIcon.layer.masksToBounds = YES;   //マスク状態
    self.imageIcon.userInteractionEnabled = YES; //インタラクティブ状態
    
    self.titleLabelC.text = self.viewTitle;
    
    //異常状態
    if ([self.ariresult isEqualToString:@"異常検知あり"]) {
        
        
        self.arautoButton.enabled = YES;
        
    } else {
        
        self.arautoButton.enabled = NO;
        
        [self.arautoButton setTitle:@"なし❌" forState:UIControlStateNormal];
        
    }
    
    // SegmentedControlのフォントを設定
    [self.segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} forState:UIControlStateNormal];
    
    
    
    //キャッシュの写真を取得
    if (self.userid0) {
        NSData *imgdata =  [NITUserDefaults objectForKey:self.userid0];
        
        if (imgdata) {
            self.imageIcon.image = [UIImage imageWithData:imgdata];
        } else {
            self.imageIcon.image = [UIImage imageNamed:@"placeholder"];
        }
    } else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL * url = [NSURL URLWithString:self.picpath];
            
            NSData * data = [[NSData alloc]initWithContentsOfURL:url];
            
            if (data != nil) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.imageIcon.image = [UIImage imageWithData:data];
                    
                });
            }
            
        });
    }
    
    //画像添加手真似
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick)];
    [self.imageIcon addGestureRecognizer:gesture];
    
    //登録 UICollectionViewCell
    [self.myCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self collectionViewsets];
    
//    self.xnum = 0;
    [self getSensorDataInfoWithType:MSensorDataTypeDaily];
    
    
    [self chooesfirst];
}



/**
 更新施設名
 */
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}

/**
  拡大画像
 */
- (void)imageViewClick {
    
    // background  view
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
    
    [self moveToCenterWidth:widthI withHeight:heightI];
    [self.bigImg addTapAction:@selector(moveToOrigin) target:self];
}



/**
 （見守られる人）画面  初めて入って
 */
- (void)chooesfirst{

    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];

    NSString *lasteVersion = [NITUserDefaults objectForKey:NITVersionKey];

    if (![currentVersion isEqualToString:lasteVersion]) {

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
 Push アラート一覧
 */
- (IBAction)ArautoPush:(UIButton *)sender {
    [self performSegueWithIdentifier:@"aratopush" sender:self];
}


/**
 Push シナリオ一覧
 */
- (IBAction)SinarioPush:(UIButton *)sender {
    [self performSegueWithIdentifier:@"sinariopush" sender:self];
}


/**
 Push action KVC値渡す
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"sinariopush"]){
        
        SinarioDetailController * sdc = segue.destinationViewController;
        [sdc.navigationItem setHidesBackButton:YES];
        sdc.roomId = self.roomID;
        sdc.user0 = self.userid0;
        
    }else if ([segue.identifier isEqualToString:@"aratopush"]) {
        AriScenarioController * asc = segue.destinationViewController;
        [asc.navigationItem setHidesBackButton:YES];
        asc.usernumber = self.userid0;
        
        asc.username = self.username;
        
        asc.isPushOrPop = YES;
    }
    
}




/**
 現在のオプションを記録して
 */
- (IBAction)selectAction:(UISegmentedControl *)sender {
    
    _xnum = (int)sender.selectedSegmentIndex;
    
    [self reloadList]; //リクエスト
    
}


/**
 *   サーバよりデータを取得
 */
-(void)getSensorDataInfoWithType:(MSensorDataType)type{
    
    [MBProgressHUD showMessage:@"" toView:self.myCollection];
    // 请求参数
    MSensorDataParam *param = [[MSensorDataParam alloc]init];
    
    param.nowdate = [[NSDate date]needDateStatus:HaveHMSType];
    
    param.staffid = [NITUserDefaults objectForKey:@"userid1"];
    
    param.custid = self.userid0;
    //日単位
    if (type == MSensorDataTypeDaily) {
        param.deviceclass = @"1";
    }
    //NSError	NSError	domain: @"NSURLErrorDomain" - code: 18446744073709550615
    
    
    [MSensorDataTool sensorDataWithParam:param type:type success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.myCollection];
        
        NSString *chartType = [NSString stringWithFormat:@"%@", dic[@"type"]];
        
        NSArray *tmpArr = dic[@"deviceinfo"];
        
        NSString *str = NSNullJudge(dic[@"picpath"]);
            if (str.length) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSURL * url = [NSURL URLWithString:str];
                    
                    NSData * data = [[NSData alloc]initWithContentsOfURL:url];
                    
                    if (data != nil) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{  
                            
                            self.imageIcon.image = [UIImage imageWithData:data];
                            [NITUserDefaults setObject:data forKey:self.userid0];
                            
                        });
                    }  
                    
                });
                
            } else {
                
            }
        if (tmpArr.count == 0) {
            [MBProgressHUD showError:@"データがありません"];
        }else{
            
            if (!chartType.length) return ;
            
            if ([chartType integerValue] == _xnum) {
                
                _CLArray = [NSMutableArray arrayWithArray:tmpArr];
                
                self.controlarr = [NSMutableArray new];
                
                for (int i = 0; i < _CLArray.count; i++) {
                    UIStoryboard *lifesb = [UIStoryboard storyboardWithName:@"Life" bundle:nil];
                    ZworksChartTBVC *ChartC = [lifesb instantiateViewControllerWithIdentifier:@"charttbcellview"];
                    ChartC.automaticallyAdjustsScrollViewInsets = YES;
                    ChartC.zarray = [tmpArr mutableCopy];
                    ChartC.xnum = _xnum;
                    ChartC.userid0 = _userid0;
                    ChartC.updatedelegate = self;
                    ChartC.superrow = i;
                    [self addChildViewController:ChartC];
                    [self.controlarr addObject:ChartC];
                }
                
                _myCollection.contentSize = self.myCollection.size;
                _myCollection.contentOffset = CGPointMake((NITScreenW)*_CLArray.count-1, 0);
                [_myCollection reloadData];

            }
            
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.myCollection];
        
        [MBProgressHUD showError:@"後ほど試してください"];
    }];
}


/**
 日 週 月  ボタンの切り替え
 */
- (void)updateCorrentTB:(int)numChart {
    self.xnum = numChart;
    [self reloadList];
}


/**
 //TableView 選択状態のこと
 */
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



/**
 初期化 collectionView
 */
-(void)collectionViewsets{
    
    _myCollection.showsHorizontalScrollIndicator = NO;
    
    _myCollection.pagingEnabled =YES;
    
    //初期化 UICollectionViewFlowLayout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumLineSpacing = 0;
        
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
   
    flowLayout.itemSize = CGSizeMake(NITScreenW, NITScreenH - Surplus);
    
    _myCollection.collectionViewLayout = flowLayout;
    
    _myCollection.backgroundColor = [UIColor clearColor];
    
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


/**
 応答できない
 */
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO ;
}

//画像表示
- (void)moveToCenterWidth:(CGFloat)widthI withHeight:(CGFloat)heightI
{
    [UIView animateWithDuration:0.5 animations:^{
        self.hoverView.alpha = 1.0f;
        self.bigImg.frame = CGRectMake((NITScreenW - widthI)/2.0, (NITScreenH - heightI)/2.0 , widthI, heightI);
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}



/**
画像を削除
 */
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
