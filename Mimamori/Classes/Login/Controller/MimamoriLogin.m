//
//  MimamoriLogin.m
//  Mimamori
//
//  Created by totyu3 on 16/6/16.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "MimamoriLogin.h"
#import "MLoginTool.h"

@interface MimamoriLogin ()
@property (strong, nonatomic) IBOutlet UITextField *hostId;

@property (strong, nonatomic) IBOutlet UITextField *userId;
@property (strong, nonatomic) IBOutlet UITextField *passWord;
@property (strong, nonatomic) IBOutlet UIButton *saveb;

@end

@implementation MimamoriLogin


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _saveb.layer.cornerRadius = 5;
    
}

-(void)viewWillAppear:(BOOL)animated{
     
//    _hostId.text = @"host01";
//    _userId.text = @"sw00001";
//    _passWord.text = @"P@ssw0rd";
    //_passWord.text = @"";
}


- (IBAction)saveBtn:(id)sender {
    
    if (!_hostId.text.length) {
        [MBProgressHUD showError:@"ホストコードを入力してください"];
        return;
    }
    
    if (!_userId.text.length) {
        [MBProgressHUD showError:@"ユーザIDを入力してください"];
        return;
    }
    if(!_passWord.text.length){
        [MBProgressHUD showError:@"パスワードを入力してください"];
        return;
    }
    
    [_userId resignFirstResponder];
    [_passWord resignFirstResponder];
    
    
//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [MBProgressHUD showMessage:@"" toView:self.view];
    [self loginWithHostId:_hostId.text withUserId:_userId.text pwd:_passWord.text];
}




//ログイン認証
-(void)loginWithHostId:(NSString *)hostId withUserId:(NSString *)userid pwd:(NSString *)pwd{
    MLoginParam *param = [[MLoginParam alloc]init];
    param.hostcd = hostId;
    param.staffid = userid;
    param.password = pwd;

    [MLoginTool loginWithParam:param success:^(MLoginResult *result) {
        
        //認証OKの場合(code=200)
        if ([result.code isEqualToString:@"200"]) {
            
            /*管理者权限*/
            [NITUserDefaults setObject:result.usertype forKey:@"MASTER_UERTTYPE"];
            [NITUserDefaults synchronize];
            
            //用户信息保存
            [NITUserDefaults setObject:_userId.text forKey:@"userid1"];
            [NITUserDefaults synchronize];
            
            
            [NITUserDefaults setObject:result.staffname forKey:@"userid1name"];
            [NITUserDefaults synchronize];
            
            //session idを取得していく
            [self getSessionInfoWithEmail:result.email];
            
            //初回登録の時間を記録
            NSTimeInterval interval=[[NSDate date] timeIntervalSince1970];
            NSString *timeStr = [NSString stringWithFormat:@"%f", interval];
            [NITUserDefaults setObject:timeStr forKey:@"oldtime"];
        }else{
            [MBProgressHUD hideHUDForView:self.view];
            NITLog(@"%@",result.code);
            [MBProgressHUD  showError:@"正しい情報を入力してください"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUD];
//            });
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NITLog(@"登录失败:%@",[error localizedDescription]);
        [MBProgressHUD  showError:@"後ほど試してください"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUD];
//        });
    }];
}


//sessioninfo 取得
-(void)getSessionInfoWithEmail:(NSString *)email{
    
    MSessionInfoParam *param = [[MSessionInfoParam alloc]init];
    param.email = email;
    param.staffid = _userId.text;
    param.hostcd = _hostId.text;
    
    [MLoginTool getFacilityInfoWithParam:param success:^(NSArray *array) {
        if (array) {
//            NSMutableArray *arr = [NSMutableArray new];
            NSMutableArray *imags = [NSMutableArray new];
            
            for (int i = 0; i < array.count; i++) {
                [imags addObject:@"space_icon"];
            }
            [NITUserDefaults setObject:imags forKey:@"CellImagesName"];
            [NITUserDefaults synchronize];
            
            [NITUserDefaults setObject:array forKey:@"FacilityList"];
            [NITUserDefaults synchronize];
            
            
            [imags replaceObjectAtIndex:0 withObject:@"selectfacitility_icon"];
            [NITUserDefaults setObject:imags forKey:@"TempcellImagesName"];
            [NITUserDefaults synchronize];
            
            [NITUserDefaults setObject:array[0] forKey:@"TempFacilityName"];
            [NITUserDefaults synchronize];
            
            
            [MLoginTool sessionInfoWithParam:param success:^(NSArray *array) {
                [MBProgressHUD hideHUDForView:self.view];
                if (array.count > 0) {
                    [MBProgressHUD hideHUD];
                    [self performSegueWithIdentifier:@"gotomain" sender:self];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view];
                NITLog(@"请求失败:%@",error);
            }];
            
        } else {
            [MBProgressHUD hideHUDForView:self.view];
            NITLog(@"facilitylist空");
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NITLog(@"facilitylist请求失败%@",error);
    }];
    
    
 
}


#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}



@end
