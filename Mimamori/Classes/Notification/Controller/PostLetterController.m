//
//  PostLetterController.m
//  Mimamori
//
//  Created by totyu2 on 2016/06/06.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "PostLetterController.h"
#import "NotificationModel.h"

#import "MNoticeTool.h"

@interface PostLetterController ()

@property (strong, nonatomic) IBOutlet UIPickerView            *typePickerV;

@property (strong, nonatomic) IBOutlet UITextField             *titleText;

@property (strong, nonatomic) IBOutlet UITextView              *contentView;

@property (strong, nonatomic) IBOutlet UIButton                *sendButton;

@property (strong, nonatomic) IBOutlet UILabel                 *PKViewLabel;

@property (nonatomic, strong) NSArray                          *groups;

@property (nonatomic, assign) NSInteger                         selectedGroupID;



@end

@implementation PostLetterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.selectedGroupID = 1;
    
    [self showCurrentPage]; //显示当前是哪个页面
}

/**
 *  上传一条通知
 */
-(void)updateNoticeInfo{
    MNoticeInfoUploadParam *param = [[MNoticeInfoUploadParam alloc]init];
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    param.noticetype =@"2";
    param.registdate = [[NSDate date]needDateStatus:HaveHMSType] ;
    param.groupid = [NSString stringWithFormat:@"%ld",(long)self.selectedGroupID];
    param.title = self.titleText.text;
    param.content = self.contentView.text;
    
    [MNoticeTool noticeInfoUploadWithParam:param success:^(NSString *code) {
        if ([code isEqualToString:@"200"]) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [MBProgressHUD showSuccess:@"送信いたしました"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [MBProgressHUD showError:@"後ほど試してください"];
    }];
}


-(NSArray *)groups{
    if (!_groups) {
        NSArray *array = [NITUserDefaults objectForKey:@"allGroupData"];
        NSArray *tmpArr = [NotificationModel mj_objectArrayWithKeyValuesArray:array];
        self.groups = tmpArr.count > 0 ? [NSArray arrayWithArray:tmpArr] : [NSArray new];
    }
    return _groups;
}


- (void)showCurrentPage {
    self.sendButton.hidden = self.isDetailView;
    self.typePickerV.hidden = self.isDetailView;
    self.PKViewLabel.hidden = !self.isDetailView;
    self.titleText.userInteractionEnabled = !self.isDetailView;
    self.contentView.userInteractionEnabled = !self.isDetailView;
    self.typePickerV.userInteractionEnabled = !self.isDetailView;
    
    if (self.isDetailView) {
        self.navigationItem.title = @"お知らせ詳細";
        self.titleText.text = self.titleS;
        self.contentView.text = self.contentS;
        self.PKViewLabel.text = self.groupName;
        
    }else{
        self.navigationItem.title = @"お知らせ作成";
        self.titleText.borderStyle = UITextBorderStyleRoundedRect;
        self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.contentView.layer.borderWidth = 0.5;
        self.contentView.layer.cornerRadius = 5;
    }
}


/**
 *  送信ボタンが押された時
 */
- (IBAction)SendCurrent:(UIButton *)sender {
    
    if (!self.selectedGroupID) {
        [MBProgressHUD showError:@"宛先を入力してください"];
        return;
    }
    
    if (!self.titleText.text.length) {
        [MBProgressHUD showError:@"タイトルを入力してください"];
        return;
    }
    
    if (!self.contentView.text.length) {
        [MBProgressHUD showError:@"本文を入力してください"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self updateNoticeInfo];
    
}


#pragma mark - Picker view data source and delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.groups.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    NotificationModel *model = self.groups[row];
    if (self.groupid) {
        [self.typePickerV selectRow:self.groupid inComponent:0 animated:NO];
    }
    return model.groupname;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    NotificationModel *model = self.groups[row];
    self.selectedGroupID = [model.groupid intValue];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



@end
