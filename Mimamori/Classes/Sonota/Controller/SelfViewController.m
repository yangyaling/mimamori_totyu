//
//  SelfViewController.m
//  Mimamori
//
//  Created by totyu3 on 16/6/13.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "SelfViewController.h"
#import "NotificationModel.h"
#import "SelfModel.h"

#import "AFNetworking.h"

@interface SelfViewController ()<DropClickDelegate>
/**
 *  nikeName
 */
@property (weak, nonatomic) IBOutlet UITextField *nickName;
/**
 *  email
 */
@property (weak, nonatomic) IBOutlet UITextField *email;
/**
 *  groupPicker
 */
@property (weak, nonatomic) IBOutlet UIPickerView *groupPicker;


@property (nonatomic, strong) NSMutableArray *allGroupData;


@property (nonatomic, assign) NSString  *groupid;//当前是分组id


@property (nonatomic, strong) AFHTTPSessionManager *session;


@property (nonatomic, strong) SelfModel *user;
@property (strong, nonatomic) IBOutlet DropButton            *facilitiesBtn;


@end

@implementation SelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSArray *tmpArr = [NotificationModel mj_objectArrayWithKeyValuesArray:[NITUserDefaults objectForKey:@"allGroupData"]];
//    self.allGroupData = tmpArr.count > 0 ? [NSMutableArray arrayWithArray:tmpArr] : [NSMutableArray new];
    
    [self getUserInfo];
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getUserInfo)];
//    
//    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
//    //UserInfo
    
    [MBProgressHUD showMessage:@"" toView:self.navigationController.view];
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [MBProgressHUD hideHUDForView:self.navigationController.view];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:NO];
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}

//- (void)GetGroupInfo {
//    [MHttpTool postWithURL:NITGetGroupInfo params:nil success:^(id json) {
//        [MBProgressHUD hideHUDForView:self.navigationController.view];
//        if (json) {
//            NSArray *dateArray = [json objectForKey:@"groupinfo"];
//            self.allGroupData = dateArray.count > 0 ? [NSMutableArray arrayWithArray:dateArray] : [NSMutableArray new];
//            [self.groupPicker reloadAllComponents];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.navigationController.view];
//        NITLog(@"groupinfo为空");
//    }];
//}


-(void)getUserInfo{

    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    NSString *userid1 = [NITUserDefaults objectForKey:@"userid1"];
    [parametersDict setValue:userid1 forKey:@"staffid"];
    
    [MHttpTool postWithURL:NITGetUserInfo params:parametersDict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
//        [self GetGroupInfo];
        
        NSArray *userinfo = [json objectForKey:@"userinfo"];
        if (userinfo){
            NSArray *tmpArr = [SelfModel mj_objectArrayWithKeyValuesArray:userinfo];
            
            SelfModel *smodel = tmpArr.firstObject;
            self.user = smodel;
            
            self.nickName.text = self.user.nickname;
            
            self.email.text = self.user.email;
            
            self.groupid = self.user.groupid;
            
            //setup PickerView
//            if (self.groupid.length) {
//                NSInteger row = [self.groupid intValue];
//                [self.groupPicker selectRow:row inComponent:0 animated:NO];
//            }
            [self.tableView reloadData];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
//        [self GetGroupInfo];
        
        NITLog(@"zwgetuserinfo请求失败");
    }];
    
}


-(void)updateUserInfo{
    [MBProgressHUD showMessage:@"" toView:self.navigationController.view];
    
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    
    NSString *userid1 = [NITUserDefaults objectForKey:@"userid1"];
    
    [parametersDict setValue:userid1 forKey:@"staffid"];
    
    [parametersDict setValue:self.nickName.text forKey:@"nickname"];
    
    [parametersDict setValue:self.groupid forKey:@"groupid"];
    
    [parametersDict setValue:self.email.text forKey:@"email"];
    
    //当前时间
    NSString *currentTime = [[NSDate date] needDateStatus:HaveHMSType];
    [parametersDict setValue:currentTime forKey:@"updatedate"];

    
    [MHttpTool postWithURL:NITUpdateUserInfo params:parametersDict success:^(id json) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        //更新模型
        self.user.nickname = self.nickName.text;
        self.user.email = self.email.text;
        self.user.groupid = self.groupid;
        
        [MBProgressHUD showSuccess:@"更新成功しました"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        NITLog(@"zwupdateuserinfo请求失败");
        
        [MBProgressHUD showError:@"後ほど試してください"];
    }];
    
    
    
    

}

- (IBAction)pushPassWordC:(id)sender {
    [self performSegueWithIdentifier:@"pushpasswordC" sender:self];
}

//保存个人信息
- (IBAction)saveButton:(id)sender {
    
    if (!self.nickName.text.length) {
        [MBProgressHUD showError:@"ニックネームを入力してください"];
        return;
    }
    
    [self updateUserInfo];
    
}

#pragma mark - PickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.allGroupData.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
//    NotificationModel *model = self.allGroupData[row];
//    if (model) {
//        return model.groupname;
//    }
    
    NSDictionary *dic = self.allGroupData[row];
    return dic[@"name"];
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
//    NotificationModel *model = self.allGroupData[row];
    
    self.groupid = [NSString stringWithFormat:@"%ld",row];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

@end
