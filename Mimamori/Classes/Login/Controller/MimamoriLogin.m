//
//  MimamoriLogin.m
//  Mimamori
//
//  Created by totyu3 on 16/6/16.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "MimamoriLogin.h"
#import "MLoginTool.h"


/**
    Login
 */
@interface MimamoriLogin ()


/**
 ホストコード
 */
@property (strong, nonatomic) IBOutlet UITextField *hostId;

/**
 ユーザーID
 */
@property (strong, nonatomic) IBOutlet UITextField *userId;

/**
パスワード
 */
@property (strong, nonatomic) IBOutlet UITextField *passWord;

/**
   ログイン   ボタン
 */
@property (strong, nonatomic) IBOutlet UIButton *saveb;

@end

@implementation MimamoriLogin


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _saveb.layer.cornerRadius = 5;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}


/**
 button click
 */
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
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    [self loginWithHostId:_hostId.text withUserId:_userId.text pwd:_passWord.text];
    
}



//ログイン認証
-(void)loginWithHostId:(NSString *)hostId withUserId:(NSString *)userid pwd:(NSString *)pwd{
    
    /*ホストコード保存*/
    [NITUserDefaults setObject:hostId forKey:@"HOSTCDKEY"];
    [NITUserDefaults synchronize];
    
    /**
     *  ユーザID 保存
     */
    [NITUserDefaults setObject:userid forKey:@"STAFFIDKEY"];
    [NITUserDefaults synchronize];
    
    MLoginParam *param = [[MLoginParam alloc]init];
    param.hostcd = hostId;
    param.staffid = userid;
    param.password = pwd;

    [MLoginTool loginWithParam:param success:^(MLoginResult *result) {
        
        //認証OKの場合(code=200)
        if ([result.code isEqualToString:@"200"]) {
            
            /*ホストコード 保存*/
            [NITUserDefaults setObject:hostId forKey:@"HOSTCDKEY"];
            [NITUserDefaults synchronize];
            
            /**
             *  ユーザID 保存
             */
            [NITUserDefaults setObject:userid forKey:@"STAFFIDKEY"];
            [NITUserDefaults synchronize];
            
            //パスワード保存
            [NITUserDefaults setObject:pwd forKey:@"PASSWORDKEY"];
            [NITUserDefaults synchronize];
            
            /*管理者権限保存*/
            [NITUserDefaults setObject:result.usertype forKey:@"MASTER_UERTTYPE"];
            [NITUserDefaults synchronize];
            
            //ユーザー情報 保存
            [NITUserDefaults setObject:_userId.text forKey:@"userid1"];
            [NITUserDefaults synchronize];
            
            //スタッフ名（見守る人） 保存
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
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NITLog(@"登录失败:%@",[error localizedDescription]);
        [MBProgressHUD  showError:@"後ほど試してください"];
    }];
}


//sessioninfo 取得
-(void)getSessionInfoWithEmail:(NSString *)email{
    
    MSessionInfoParam *param = [[MSessionInfoParam alloc]init];
    
    param.email = email;
    
    param.staffid = _userId.text;
    
    param.hostcd = _hostId.text;
    
    [MLoginTool getFacilityInfoWithParam:param success:^(NSArray *array) {
        
        if (array.count > 0) {
            
            NSMutableArray *imags = [NSMutableArray new];
            
            for (int i = 0; i < array.count; i++) {
                [imags addObject:@"space_icon"];
            }
            
            //施設アイコン 保存
            [NITUserDefaults setObject:imags forKey:@"CellImagesName"];
            [NITUserDefaults synchronize];
            
            
            //施設のリスト 保存
            [NITUserDefaults setObject:array forKey:@"FacilityList"];
            [NITUserDefaults synchronize];
            
            
            //デフォルトのアイコン
            [imags replaceObjectAtIndex:0 withObject:@"selectfacitility_icon"];
            [NITUserDefaults setObject:imags forKey:@"TempcellImagesName"];
            [NITUserDefaults synchronize];
            
            
            //デフォルトの施設
            [NITUserDefaults setObject:array[0] forKey:@"TempFacilityName"];
            [NITUserDefaults synchronize];
            
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view];
                
                //push  -> 通知一覧画面
                [self performSegueWithIdentifier:@"gotomain" sender:self];
            });
            
        } else {
            
            [MBProgressHUD showError:@"No facilities found"];
            
            [MBProgressHUD hideHUDForView:self.view];
            
            NITLog(@"facilitylist空");
            
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NITLog(@"facilitylist请求失败%@",error);
    }];
    
    
 
}


#pragma mark - UITextFieldDelegate

/**
  hide Keyboard
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}



@end
