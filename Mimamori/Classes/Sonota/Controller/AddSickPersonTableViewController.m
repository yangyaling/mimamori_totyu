//
//  AddSickPersonTableViewController.m
//  Mimamori
//
//  Created by totyu3 on 16/6/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "AddSickPersonTableViewController.h"
#import "SickPersonModel.h"

#import "MCustTool.h"


@interface AddSickPersonTableViewController ()
/**
 *  userid0
 */
@property (weak, nonatomic) IBOutlet UITextField *useridText;
/**
 *  roomid
 */
@property (weak, nonatomic) IBOutlet UITextField *roomidText;
/**
 *  nickname
 */
@property (weak, nonatomic) IBOutlet UITextField       *nicknameText;
 

@end

@implementation AddSickPersonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewWillDisappear:(BOOL)animated{

}

/**
 *  点击保存按钮
 */
- (IBAction)saveButton:(id)sender {
    
    if (!self.useridText.text.length) {
        [MBProgressHUD showError:@"ユーザidを入力してください"];
        return;
    }

    if (!self.roomidText.text.length) {
        [MBProgressHUD showError:@"ルームIDを入力してください"];
        return;
    }
    
    if (!self.nicknameText.text.length) {
        [MBProgressHUD showError:@"表示氏名を入力してください"];
        return;
    }
    
    SickPersonModel *cust = [[SickPersonModel alloc]init];
    cust.userid0 = self.useridText.text;
    cust.roomid = self.roomidText.text;
    cust.dispname = self.nicknameText.text;
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    [self addCust:cust];
    
}

/**
 *  見守り対象者を追加
 */
-(void)addCust:(SickPersonModel *)model{
    // 请求参数
    MCustAddParam *param = [[MCustAddParam alloc]init];
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    param.userid0 =  model.userid0;
    param.nickname =  model.dispname;
    param.roomid =  model.roomid;
    param.updatedate = [[NSDate date] needDateStatus:HaveHMSType];
    
    [MCustTool custAddWithParam:param success:^(NSString *code) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([code intValue]>299) {
            [MBProgressHUD showError:@"ユーザIDまたはルームIDが正しく入力されていません"];
            
        }else{
            [MBProgressHUD showSuccess:@"追加しました!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUD];
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"後ほど試してください"];
        
    }];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

@end
