//
//  ScenarioTableViewController.m
//  Mimamori
//
//  Created by totyu3 on 16/6/6.
//  Copyright © 2016年 totyu3. All rights reserved.
//


#import "ScenarioTableViewController.h"
#import "UIView+Extension.h"

#import "DoorFeelTableViewCell.h"
#import "DFChildTableViewCell.h"

#import "Scenario.h"
#import "Device.h"
#import "DeviceValue.h"
#import "AFNetworking.h"

@interface ScenarioTableViewController (){
    BOOL cancelEdit;    //YES:不可编辑状态   NO:可编辑状态
}


/**
 *  シナリオネーム
 */
@property (weak, nonatomic) IBOutlet UITextField *scenarionametext;
/**
 *  保存ボタン
 */
@property (weak, nonatomic) IBOutlet UIButton *overButton;


@property (nonatomic,strong) AFHTTPSessionManager       *session;

@property (nonatomic, strong) NSArray                   *devicesArray;//device模型数组

@property (nonatomic, strong) NSMutableArray            *editDevicesArray;//device模型数组(编辑过程中)

@property (nonatomic, assign) int                       saveType;//0:追加 1:编辑

@end

@implementation ScenarioTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化session对象
    _session = [AFHTTPSessionManager manager];
    _session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];

    [self getScenariodtlInfo];
    
    
    //setup UI
    if (self.editType == 0) {
        self.scenarionametext.text = @"";
        self.scenarionametext.borderStyle = UITextBorderStyleRoundedRect;
        
        self.saveType = 0;
    }else if (self.editType == 1){
        
        self.scenarionametext.text = self.scenario.scenarioname;
        self.scenarionametext.userInteractionEnabled = NO;
        
        self.editButtonItem.title = @"編集";
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
        self.overButton.alpha = 0.0;
        
        self.saveType = 1;
        cancelEdit = YES;
    }
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

}

-(void)getScenariodtlInfo{
    NSString *url = @"http://mimamori.azurewebsites.net/zwgetscenariodtlinfo.php";
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setValue:self.roomid forKey:@"roomid"];
    [parametersDict setValue:self.scenario.scenarioid forKey:@"scenarioid"];
    
    [self.session POST:url parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *tmpArr = [responseObject objectForKey:@"scenariodtlinfo"];
        if (tmpArr) {
            NSArray *tmpArray = [self setupScenarioItemsWithArray:tmpArr];
            self.devicesArray = tmpArray;
            self.editDevicesArray = [[NSMutableArray alloc]initWithArray:tmpArray];
            //归档
            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:tmpArray];
            [NITUserDefaults setObject:data forKey:@"scenariodtlinfoarr"];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 *  把シナリオ放入一个个模型中，再把模型放入一个数组中
 */
-(NSArray *)setupScenarioItemsWithArray:(NSArray *)array{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<array.count; i++) {
        NSArray *tmpArr = [array objectAtIndex:i];
        NSDictionary *tmpDict = [tmpArr firstObject];
        
        Device *device = [[Device alloc]init];
        device.deviceid = [tmpDict valueForKey:@"deviceid"];
        device.devicename = [tmpDict valueForKey:@"devicename"];
        device.nodename = [tmpDict valueForKey:@"nodename"];
        device.devicetype = [tmpDict valueForKey:@"devicetype"];
        device.pattern = [[tmpDict valueForKey:@"pattern"]intValue];
        device.timeunit = [tmpDict valueForKey:@"timeunit"];
        device.valueunit = [tmpDict valueForKey:@"valueunit"];
        
        DeviceValue *value = [[DeviceValue alloc]init];
        value.time = [tmpDict valueForKey:@"time"];
        value.value = [tmpDict valueForKey:@"value"];
        value.rpoint = [tmpDict valueForKey:@"rpoint"];
        device.deviceValue = value;
        
        [result addObject:device];

    }
    return result;
}


/**
 *   シナリオ上传到服务器
 */
-(void)updateScenarioInfo:(NSArray *)array{
    
    
    NSString *url = @"http://mimamori.azurewebsites.net/zwupdatescenarioinfo.php";
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setValue:[NITUserDefaults objectForKey:@"userid1"] forKey:@"userid1"];
    [parametersDict setValue:self.userid0 forKey:@"userid0"];
    if (self.saveType == 1) {
        [parametersDict setValue:self.scenario.scenarioid forKey:@"scenarioid"];
    }
    [parametersDict setValue:self.scenarionametext.text forKey:@"scenarioname"];
    [parametersDict setValue:[[NSDate date]needDateStatus:HaveHMSType] forKey:@"updatedate"];
    
    //保存detailinfo的数组转换成json数据格式
    NSError *parseError = nil;
    NSData  *json = [NSJSONSerialization dataWithJSONObject:array options: NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    [parametersDict setValue:str forKey:@"scenariodtlinfo"];
    
    
    [self.session POST:url parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NITLog(@"zwupdatescenarioinfo success %@",responseObject);
        //追加成功，显示信息
        if ([[responseObject valueForKey:@"code"]isEqualToString:@"200"]) {
            
            if (self.saveType == 0) {
                [MBProgressHUD showSuccess:@"追加いたしました"];
            }else if (self.saveType == 1){
                [MBProgressHUD showSuccess:@"更新いたしました"];
            }
        //跳转到前页面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
                // 如果刚刚添加的scenario检知到异常
                if ([[responseObject objectForKey:@"result"]intValue] == 0) {
                    if ([self.delegate respondsToSelector:@selector(warningScenarioAdded:)]) {
                        NSString *message = [NSString stringWithFormat:@"<センサー> %@%@",self.user0name,self.scenarionametext.text];
                        [self.delegate warningScenarioAdded:message];
                    }

                }

            });
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NITLog(@"zwupdatescenarioinfo failed");
        [MBProgressHUD showError:@"後ほど試してください"];
    }];
}

/**
 *  完了保存
 */
- (IBAction)saveScenarioButton:(id)sender {
   
    
    int scenariosuccess = 1;
    
    NSMutableArray *scenarioarray = [NSMutableArray array];
    NSData * data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
    NSMutableArray * scenarioarr= [NSKeyedUnarchiver unarchiveObjectWithData:data];
    for (Device *model in scenarioarr) {
        NSString *timeStr = [NSString stringWithFormat:@"%@",model.deviceValue.time];
        NSString *valueStr = [NSString stringWithFormat:@"%@",model.deviceValue.value];
        if (model.pattern==3) {
            if (![timeStr isEqualToString:@"-"]&&![valueStr isEqualToString:@"-"]&&![model.deviceValue.rpoint isEqualToString:@"-"]) {
                [scenarioarray addObject:[self scenarioDictionary:model type:1]];
            }else{
                if (![timeStr isEqualToString:@"-"]||![valueStr isEqualToString:@"-"]||![model.deviceValue.rpoint isEqualToString:@"-"]) {
                    scenariosuccess = 0;
                }
            }
        }else{
            if (![timeStr isEqualToString:@"-"]){
                [scenarioarray addObject:[self scenarioDictionary:model type:0]];
            }
        }
    }
    
    if (!_scenarionametext.text.length) {
        [MBProgressHUD showError:@"シナリオネームを入力してください"];
    }else{
        if (scenariosuccess==1 && scenarioarray.count > 0) {
            // 网络请求，追加或更新
            [self updateScenarioInfo:scenarioarray];
        }else{
            [MBProgressHUD  showError:@"入力項目をチェックしてください!"];
        }
    }

    
}

-(NSMutableDictionary*)scenarioDictionary:(Device *)model type:(int)type{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:model.deviceid forKey:@"deviceid"];
    [dict setValue:model.deviceValue.time forKey:@"time"];
    [dict setValue:model.deviceValue.value forKey:@"value"];
    [dict setValue:model.deviceValue.rpoint forKey:@"rpoint"];
    [dict setValue:type==0 ? @"0" : @"1" forKey:@"pattern"];
    return dict;
}


#pragma mark -UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.devicesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return self.tableView.size.height/12.5;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 不可编辑情况下，取消所有的编辑结果
    if (cancelEdit == YES) {
        self.editDevicesArray = [[NSMutableArray alloc]initWithArray:self.devicesArray];
    // 可编辑情况下，取实时保存的编辑结果
    }else{
        NSData * data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
        NSMutableArray * tmpArray= [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.editDevicesArray = tmpArray;
    }

    
    Device *device = self.editDevicesArray[indexPath.row];
    
    int pattern = device.pattern;
    
    // 使用なし/反応なし
    if (pattern == 1||pattern == 2) {
        DoorFeelTableViewCell *cell = [DoorFeelTableViewCell cellWithTableView:tableView];
        cell.editType = cancelEdit;
        cell.device = device;
        
        return cell;
    }
    //以上・以下
    else if(pattern == 3){
        DFChildTableViewCell *cell = [DFChildTableViewCell cellWithTableView:tableView];
        cell.editType = cancelEdit;
        cell.device = device;

        return cell;
    }
    return nil;
}



#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -编辑模式转换

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];

    if (self.editing) {
        [self nametextset:@"キャンセル" borderStyle:UITextBorderStyleRoundedRect enabled:YES];
        
        cancelEdit = NO;
    } else {
        _scenarionametext.text = self.scenario.scenarioname;
        [self nametextset:@"編集" borderStyle:UITextBorderStyleNone enabled:NO];
        
        cancelEdit = YES;
        
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.devicesArray];
        [NITUserDefaults setObject:data forKey:@"scenariodtlinfoarr"];
    }

    [self.tableView reloadData];
}

-(void)nametextset:(NSString*)title borderStyle:(UITextBorderStyle)borderStyle enabled:(BOOL)enabled{
    self.editButtonItem.title = title;
    _scenarionametext.userInteractionEnabled = enabled;
    _scenarionametext.borderStyle = borderStyle;
    [UIView animateWithDuration:0.2 animations:^{
        _overButton.alpha = enabled ? 1.0 : 0.0;
    }];
}



@end
