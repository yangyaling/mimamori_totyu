//
//  UpdatePassWordController.m
//  Mimamori2
//
//  Created by NISSAY IT on 2017/5/22.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import "UpdatePassWordController.h"
#import "AppDelegate.h"


/**
 パスワード変更
 */
@interface UpdatePassWordController ()


@property (strong, nonatomic) IBOutlet DropButton  *facilitiesBtn;
@property (strong, nonatomic) IBOutlet UITextField *oldPassword;
@property (strong, nonatomic) IBOutlet UITextField *nowPassword;
@property (strong, nonatomic) IBOutlet UITextField *okPassword;

@end

@implementation UpdatePassWordController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
        
}


/**
 チェック -> パスワード  大文字、小文字、数字のどれかが含まれています。
 */
-(BOOL)checkPassWord:(NSString *)pwd
{
    //
    NSString *regex = @"(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])[0-9A-Za-z-\\W]{8,16}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    BOOL result = [pred evaluateWithObject:pwd];
    
    return result;
}


/**
 変更  method
 */
- (IBAction)UpdatePassword:(id)sender {
    
    NSString *pwd = [NITUserDefaults objectForKey:@"PASSWORDKEY"];
    
    BOOL nowPwd = [self checkPassWord:_nowPassword.text];
    
    BOOL okPwd = [self checkPassWord:_okPassword.text];
    
    if (!_oldPassword.text.length || !_nowPassword.text.length || !_okPassword.text.length) {
        
        [MBProgressHUD showError:@"空いてる項目があります、入力して下さい。"];
        return;
    }
    
    if (![_oldPassword.text isEqualToString:pwd]) {
        [MBProgressHUD showError:@"旧パスワードが違います。"];
        return;
    }
    
    
    if (_nowPassword.text.length < 8 || _okPassword.text.length < 8) {
        
        [MBProgressHUD showError:@"新パスワードは８文字以上に設定して下さい。"];
        return;
    }
    
    if (![_nowPassword.text isEqualToString:_okPassword.text]) {
        [MBProgressHUD showError:@"新パスワードと新パスワード(確認用)が不一致です。"];
        return;
    }
    
    if (!nowPwd || !okPwd) {
        [MBProgressHUD showError:@"大文字、小文字、数字のどれかが含まれていません。"];
        return;
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    NSString *staffid = [NITUserDefaults objectForKey:@"userid1"];
    
    NSDictionary *dic = @{
                          @"staffid":staffid,
                          
                          @"oldpwd":self.oldPassword.text,
                          
                          @"newpwd":self.nowPassword.text,
                          
                          @"confirmpwd":self.okPassword.text
                          
                          };
    
    [MHttpTool postWithURL:NITUpdatePassword params:dic success:^(id json) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (json) {
            
            NSString *code = [json objectForKey:@"code"];
            
            NITLog(@"%@",code);
            
            if ([code isEqualToString:@"200"]) {
                [MBProgressHUD showSuccess:@""];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    appDelegate.window.rootViewController = [appDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"LoginIdentifier"];
                    
                    // タイマー   ストップ
                    [appDelegate stopTimer];
                });
                
                
            } else {
                
                [MBProgressHUD showError:@""];
            }
            
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NITLog(@"%@",error);
    }];

}



/**
編集をチェックして
 */
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    NSString *pwd = [NITUserDefaults objectForKey:@"PASSWORDKEY"];
    
    if (textField == _oldPassword) {
        if (![_oldPassword.text isEqualToString:pwd]) {
            [MBProgressHUD showError:@"旧パスワードが違います。" toView:self.view];
        }
    } else if (textField == _nowPassword) {
        if (_nowPassword.text.length < 8) {
            [MBProgressHUD showError:@"新パスワードは８文字以上に設定して下さい。" toView:self.view];
           
        } else {
            BOOL nowPwd = [self checkPassWord:_nowPassword.text];
            if (!nowPwd) {
                [MBProgressHUD showError:@"大文字、小文字、数字のどれかが含まれていません。" toView:self.view];
            }
        }
    } else {
        if (_okPassword.text.length < 8) {
            [MBProgressHUD showError:@"新パスワード(確認用)は８文字以上に設定して下さい。" toView:self.view];
          
        } else {
            if (![_nowPassword.text isEqualToString:_okPassword.text]) {
                [MBProgressHUD showError:@"新パスワードと新パスワード(確認用)が不一致です。" toView:self.view];
            
            } else {
                BOOL okPwd = [self checkPassWord:_nowPassword.text];
                if (!okPwd) {
                    [MBProgressHUD showError:@"大文字、小文字、数字のどれかが含まれていません。" toView:self.view];
                    
                }
            }
            
        }
    }

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length > 16) {
        [MBProgressHUD showError:@"Not more than 16 characters"];
        return NO;
    } else {
        return YES;
    }
   
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:NO];
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}


@end
