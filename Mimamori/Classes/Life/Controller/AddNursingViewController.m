//
//  AddNursingViewController.m
//  Mimamori
//
//  Created by totyu3 on 16/6/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "AddNursingViewController.h"
#import "NITMPButton.h"
#import "NursingNotesTableViewController.h"

#import "AFNetworking.h"

@interface AddNursingViewController ()
/**
 *  当前时间
 */
@property (weak, nonatomic) IBOutlet UILabel *nowTime;
/**
 *  记录名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nurseName;
/**
 *  文本记录框
 */
@property (weak, nonatomic) IBOutlet UITextView *notesText;
/**
 *  录音按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *microphone;

@property (nonatomic,strong) AFHTTPSessionManager       *session;

@end

@implementation AddNursingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化session对象
    _session = [AFHTTPSessionManager manager];
    // 设置请求接口回来时支持什么类型的数组
    _session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"戻る" style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButtonItem)];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    self.nowTime.text = [[NSDate date]needDateStatus:HaveHMType];
    self.nurseName.text = self.dispname;
}

-(void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideHUD];

}

-(void)updateCareMemoInfo{
    NSString *url = @"http://mimamori.azurewebsites.net/zwupdatecarememoinfo.php";
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setValue:[NITUserDefaults objectForKey:@"userid1"] forKey:@"userid1"];
    [parametersDict setValue:self.userid0 forKey:@"userid0"];
    [parametersDict setValue:[[NSDate date]needDateStatus:HaveHMType] forKey:@"registdate"];
    [parametersDict setValue:self.notesText.text forKey:@"content"];
    
    [self.session POST:url parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            
            [MBProgressHUD  showSuccess:@"追加しました!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"nursingsPush" sender:self];
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD  showError:@"後ほど試してください"];
    }];
}

/**
 *  完了ボタンを押した
 */
- (IBAction)overButton:(id)sender {
    
    if (!self.notesText.text.length) {
        [MBProgressHUD showError:@"本文を入力してください"];
        return;
    }
    [self updateCareMemoInfo];
}

-(void)clickLeftBarButtonItem{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"nursingsPush"]) {
        
        NursingNotesTableViewController * vc = segue.destinationViewController;
        vc.userid0 = self.userid0;
        
        //        nnvc.ursingNotesName = _ursingNotesName;
        //
        //        nnvc.ursingNotesUserid0 = _ursingNotesUserid0;
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return  YES;
}



@end
