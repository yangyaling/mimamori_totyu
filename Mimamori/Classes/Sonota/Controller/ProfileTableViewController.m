//
//  ProfileTableViewController.m
//  Mimamori
//
//  Created by totyu3 on 16/6/6.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "ProfileTableViewController.h"

#import "ProfileModel.h"

#import "MProfileTool.h"

@interface ProfileTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/**
 *  姓名
 */
@property (strong, nonatomic) IBOutlet UITextField *user0name;
/**
 *  性别
 */
@property (strong, nonatomic) IBOutlet UITextField *sex;
/**
 *  生日
 */
@property (strong, nonatomic) IBOutlet UITextField *birthday;
/**
 *  地址
 */
@property (strong, nonatomic) IBOutlet UITextField *address;
/**
 *  经常就诊的医生
 */
@property (strong, nonatomic) IBOutlet UITextField *kakaritsuke;
/**
 *  服药情况
 */
@property (strong, nonatomic) IBOutlet UITextView *drug;
/**
 *  诊断结果
 */
@property (strong, nonatomic) IBOutlet UITextView *health;
/**
 *  其它注意事项
 */
@property (strong, nonatomic) IBOutlet UITextView *other;
/**
 *  最终更新日期
 */
@property (weak, nonatomic) IBOutlet UILabel *updatedate;
/**
 *  最终更新者名
 */
@property (weak, nonatomic) IBOutlet UILabel *updatename;
/**
 *  保存按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *save;

@property (nonatomic, strong) NSMutableArray      *profileArray;
@property (strong, nonatomic) IBOutlet UIImageView *userIcon;


@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userIcon.layer.cornerRadius = 6;
    self.userIcon.layer.masksToBounds = YES;
    
    NSData *imgdata = [NITUserDefaults objectForKey:@"usericon"];
    if (imgdata) {
        self.userIcon.image = [UIImage imageWithData:imgdata];
    }
    [self getProfileInfo];
    
}

-(void)viewWillAppear:(BOOL)animated{
    //[self.tableView.mj_header beginRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideHUD];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [MBProgressHUD showMessage:@"後ほど..." toView:self.tableView];
        [self tapClick];
    }
}


-(void)setupData{
    
    ProfileModel *pmodel = self.profileArray.firstObject;
    
    self.user0name.text = pmodel.user0name;
    self.sex.text = pmodel.sex;
    self.birthday.text = pmodel.birthday;
    self.address.text = pmodel.address;
    self.kakaritsuke.text = pmodel.kakaritsuke;
    self.drug.text = pmodel.drug;
    self.health.text = pmodel.health;
    self.other.text = pmodel.other;
    self.updatename.text = pmodel.updatename;
    self.updatedate.text = pmodel.date;
}

/**
 * プロフィール情报
 */
-(void)getProfileInfo{
    MProfileInfoParam *param = [[MProfileInfoParam alloc]init];
    param.userid0 = self.userid0;
    
    [MProfileTool profileInfoWithParam:param success:^(NSArray *array) {
        if (array.count > 0){
            self.profileArray = [ProfileModel mj_objectArrayWithKeyValuesArray:array];
            [self setupData];
        }
    } failure:^(NSError *error) {
         [MBProgressHUD showError:@"後ほど試してください"];
    }];
    
}

/**
 *  更新プロフィール
 */
-(void)updateProfileInfo{
    // 请求参数
    MProfileInfoUpdateParam *param = [[MProfileInfoUpdateParam alloc]init];
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    param.userid0 = self.userid0;
    param.user0name = self.self.user0name.text;
    param.sex = self.sex.text;
    param.birthday = self.birthday.text;
    param.address = self.address.text;
    param.kakaritsuke = self.kakaritsuke.text;
    param.drug = self.drug.text;
    param.health = self.health.text;
    param.other = self.other.text;
    param.updatedate = [[NSDate date] needDateStatus:HaveHMSType];
    param.updatename =[NITUserDefaults objectForKey:@"userid1name"];
    
    [MProfileTool profileInfoUpdateWithParam:param success:^(NSString *code) {
        [MBProgressHUD showSuccess:@"更新しました！"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });

    } failure:^(NSError *error) {
            [MBProgressHUD showError:@"後ほど試してください"];
            NITLog(@"zwupdatecustinfo请求失败");
    }];
}

//　点击保存按钮
- (IBAction)saveProfile:(id)sender {
    
    if (!self.user0name.text.length) {
        [MBProgressHUD showError:@"氏名を入力してください"];
        return;
    }
    if (!self.sex.text.length) {
        [MBProgressHUD showError:@"性别を入力してください"];
        return;
    }
    if (!self.birthday.text.length) {
        [MBProgressHUD showError:@"誕生日を入力してください"];
        return;
    }
    if (!self.address.text.length) {
        [MBProgressHUD showError:@"現住所を入力してください"];
        return;
    }
    if (!self.kakaritsuke.text.length) {
        [MBProgressHUD showError:@"かかりつけ医を入力してください"];
        return;
    }
    if (!self.drug.text.length) {
        [MBProgressHUD showError:@"服薬情報を入力してください"];
        return;
    }
    if (!self.health.text.length) {
        [MBProgressHUD showError:@"健康診断結果を入力してください"];
        return;
    }
    if (!self.other.text.length) {
        [MBProgressHUD showError:@"その他お願い事項を入力してください"];
        return;
    }
    
    [self updateProfileInfo];
    
}

//进入本地相册
/*选择拍照/本地相册*/
- (void)tapClick {
    [MBProgressHUD hideHUDForView:self.tableView];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cc = [UIAlertAction actionWithTitle:@"写真を撮る" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
//    UIAlertAction *aa = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        
//        [self presentViewController:imagePicker animated:YES completion:nil];
//    }];
    UIAlertAction *ua = [UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:cc];
//    [ac addAction:aa];
    [ac addAction:ua];
    [self presentViewController:ac animated:YES completion:nil];
    
}

#pragma mark --  imagePicker delegate Action
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (picker.allowsEditing) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        
        [NITUserDefaults setObject:imageData forKey:@"usericon"];
        //UIImagePickerControllerCropRect
        //UIImagePickerControllerEditedImage
        //UIImagePickerControllerOriginalImage
        self.userIcon.image = [UIImage imageWithData:imageData];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextFieldDelegate

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
