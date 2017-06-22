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


/**
 ユーザ情報
 */
@interface SelfViewController ()<DropClickDelegate>
/**
  ニックネーム（見守る人）
 */
@property (weak, nonatomic) IBOutlet UITextField *nickName;


@property (strong, nonatomic) IBOutlet DropButton            *facilitiesBtn;


@end

@implementation SelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getUserInfo];
    
    [MBProgressHUD showMessage:@"" toView:self.navigationController.view];
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [MBProgressHUD hideHUDForView:self.navigationController.view];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:NO];
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}



/**
 POST ->ユーザー情報
 */
-(void)getUserInfo{

    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    
    NSString *userid1 = [NITUserDefaults objectForKey:@"userid1"];
    
    [parametersDict setValue:userid1 forKey:@"staffid"];
    
    [MHttpTool postWithURL:NITGetUserInfo params:parametersDict success:^(id json) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        
        NSArray *userinfo = [json objectForKey:@"userinfo"];
        
        if (userinfo.count >0){
            
            
            self.nickName.text = [userinfo.firstObject objectForKey:@"username"];
            
            
            [self.tableView reloadData];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        
        NITLog(@"zwgetuserinfo请求失败");
    }];
}


/**
 更新 ->ユーザー情報
 */
-(void)updateUserInfo{
    
    [MBProgressHUD showMessage:@"" toView:self.navigationController.view];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    
    NSString *userid1 = [NITUserDefaults objectForKey:@"userid1"];
    
    [parametersDict setValue:userid1 forKey:@"staffid"];
    
    [parametersDict setValue:self.nickName.text forKey:@"username"];
    
    
    //当前时间
    NSString *currentTime = [[NSDate date] needDateStatus:HaveHMSType];
    
    [parametersDict setValue:currentTime forKey:@"updatedate"];

    
    [MHttpTool postWithURL:NITUpdateUserInfo params:parametersDict success:^(id json) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        
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



/**
 Push ->  パスワード変更

 */
- (IBAction)pushPassWordC:(id)sender {
    [self performSegueWithIdentifier:@"pushpasswordC" sender:self];
}



- (IBAction)saveButton:(id)sender {
    
    if (!self.nickName.text.length) {
        [MBProgressHUD showError:@"ニックネームを入力してください"];
        return;
    }
    
    [self updateUserInfo];
    
}


/**
 hide  keyboard

 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

@end
