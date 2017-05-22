//
//  UpdatePassWordController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/22.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "UpdatePassWordController.h"
#import "AppDelegate.h"

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
- (IBAction)UpdatePassword:(id)sender {
    
    if (!_oldPassword.text.length || !_nowPassword.text.length || !_okPassword.text.length) {
        
        [MBProgressHUD showError:@""];
        return;
    }
    
    if (_nowPassword.text.length < 8 || _okPassword.text.length < 8) {
        
        [MBProgressHUD showError:@""];
        return;
    }
    
    if (![_nowPassword.text isEqualToString:_okPassword.text]) {
        [MBProgressHUD showError:@""];
        return;
    }
    
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
                [CATransaction setCompletionBlock:^{
                    // 4.返回登录页面
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    appDelegate.window.rootViewController = [appDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"LoginIdentifier"];
                    // 5.移除定时器
                    [appDelegate stopTimer];
                }];
            } else {
                
                [MBProgressHUD showError:@""];
            }
            
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NITLog(@"%@",error);
    }];

}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:NO];
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}


@end
