//
//  DetailChartViewController.m
//  Mimamori
//
//  Created by 楊亜玲 on 16/9/26.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "DetailChartViewController.h"
#import "DetailChartCell.h"
#import "ZworksChartModel.h"

#import "MSensorDataTool.h"

@interface DetailChartViewController ()
@property (nonatomic,strong) NSArray                    *chartArray;//模型数组

@end

@implementation DetailChartViewController

-(NSArray *)chartArray{
    if (_chartArray == nil) {
        _chartArray = [NSArray array];
    }
    return _chartArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // 判断这个nodeID的所有deviceID的这一天的data是否缓存过，如果缓存过
    NSString *dateStr = [self.dateString substringToIndex:10];
    
    BOOL result = [self existData:self.subdeviceinfo date:dateStr];
    
    // 如果存在缓存，读取缓存
    if (result == YES) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (int i = 0; i < self.subdeviceinfo.count; i++) {
            NSString *deviceid = [self.subdeviceinfo objectAtIndex:i];
            NSString *path =[NITDataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.data",deviceid,dateStr]];
            //读档
            ZworksChartModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            [array addObject:model];
        }
        self.chartArray = array;

    }else{
    // 如果没有缓存，进行请求
        [MBProgressHUD showMessage:@"" toView:self.view];
        
        
        
        [self getSensorDataInfoWithDate:self.dateString];
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/**
 *  サーバより指定日のセンサーデータを取得
 *
 *  @param date 指定日(yyyy-MM-dd HH:mm:ss)
 */
-(void)getSensorDataInfoWithDate:(NSString *)date{
    
    MSensorDataParam *param = [[MSensorDataParam alloc]init];
    param.nowdate = date;
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    param.userid0 = self.userid0;
    param.deviceclass = @"2";
    param.nodeid = self.nodeId;
    
    [MSensorDataTool sensorDataWithParam:param type:MSensorDataTypeDaily success:^(NSArray *array) {
        if (array.count > 0) {
            // 0.数组 -> 　模型数组
            NSArray *tmpArr = [ZworksChartModel mj_objectArrayWithKeyValuesArray:array];
            self.chartArray = tmpArr;
            // 1.刷新tableView
            [self.tableView reloadData];
            // 2.缓存数据 (当天的数据不缓存)
            NSString *todayStr = [NSDate SharedToday];
            if (![todayStr isEqualToString:[date substringToIndex:10]]) {
                [self saveDataWithModelArray:tmpArr date:self.dateString];
            }
            
            [MBProgressHUD hideHUDForView:self.view];
            
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
 *  判断是否有缓存
 *
 *  @param array   deviceid 数组
 *  @param dateStr 指定日期 (yyyy-MM-dd)
 */
-(BOOL)existData:(NSArray *)array date:(NSString *)dateStr{
    BOOL result = YES;
    
    for (int i = 0; i < array.count; i++) {
        NSString *deviceid = [array objectAtIndex:i];
        NSString *path =[NITDataPath
            stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.data",deviceid,dateStr]];
        //读档（反归档）
        ZworksChartModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!model) {
            return NO;
        }
    }
    return result;
}

/**
 *  缓存模型
 *
 *  @param models  模型数组
 *  @param dateStr 日期(yyyy-MM-dd HH:mm:ss)
 */
-(void)saveDataWithModelArray:(NSArray *)models date:(NSString *)dateStr{
    NSString *date = [dateStr substringToIndex:10];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDir = FALSE;
    BOOL isDirExist = [manager fileExistsAtPath:NITDataPath isDirectory:&isDir];
    if (!(isDirExist && isDir)) {
        BOOL bCreateDir = [manager createDirectoryAtPath:NITDataPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!bCreateDir) {
            NITLog(@"文件夹创建失败");
        }
        NITLog(@"文件夹创建成功");
    }
    
    for (int i = 0 ; i < models.count; i++) {
        ZworksChartModel *model = [models objectAtIndex:i];
        NSString *path =[NITDataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.data",model.deviceid,date]];
        //归档
        [NSKeyedArchiver archiveRootObject:model toFile:path];
    }
    NITLog(@"path --- %@",NITDataPath);
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chartArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailChartCell *cell = [DetailChartCell cellWithTableView:tableView];
    cell.dateStr = [self.dateString substringToIndex:10];
    cell.nodeID = self.nodeId;
    cell.chartModel = self.chartArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
    
}


@end
