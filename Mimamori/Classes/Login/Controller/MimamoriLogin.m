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
//    _userId.text = @"0001";
//    _passWord.text = @"P@ssw0rd";
    //_passWord.text = @"";
}


- (IBAction)saveBtn:(id)sender {
    
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
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    [self loginWithUserId:_userId.text pwd:_passWord.text];
    
}


//ログイン認証

-(void)loginWithUserId:(NSString *)userid pwd:(NSString *)pwd{
    MLoginParam *param = [[MLoginParam alloc]init];
    param.userid = userid;
    param.password = pwd;

    [MLoginTool loginWithParam:param success:^(MLoginResult *result) {
        [MBProgressHUD hideHUDForView:self.view];
        //認証OKの場合(code=200)
        if ([result.code isEqualToString:@"200"]) {
            
            //用户信息保存
            [NITUserDefaults setObject:_userId.text forKey:@"userid1"];
            [NITUserDefaults setObject:result.username forKey:@"userid1name"];
            
            //session idを取得していく
            [self getSessionInfoWithEmail:result.email];
            
            //初回登録の時間を記録
            NSTimeInterval interval=[[NSDate date] timeIntervalSince1970];
            NSString *timeStr = [NSString stringWithFormat:@"%f", interval];
            [NITUserDefaults setObject:timeStr forKey:@"oldtime"];
        }else{
            [MBProgressHUD  showError:@"正しい情報を入力してください"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUD];
//            });
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NITLog(@"登录失败:%@",error);
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
    [MLoginTool sessionInfoWithParam:param success:^(NSArray *array) {
        if (array.count > 0) {
            [MBProgressHUD hideHUD];
            [self performSegueWithIdentifier:@"gotomain" sender:self];
        }
    } failure:^(NSError *error) {
        NITLog(@"请求失败:%@",error);
    }];
 
}


#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}



@end
