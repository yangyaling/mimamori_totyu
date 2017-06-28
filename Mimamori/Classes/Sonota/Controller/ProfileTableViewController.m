//
//  ProfileTableViewController.m
//  Mimamori
//
//  Created by NISSAY IT on 16/6/6.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "ProfileTableViewController.h"

#import "MProfileTool.h"

#import "IconModel.h"

#import "MProfileInfoUpdateParam.h"

#import "GGActionSheet.h"

/**
 その他＞見守り設定>個別入居者＞プロフィール設定画面のコントローラ
 */
@interface ProfileTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,GGActionSheetDelegate>

@property(nonatomic,strong) GGActionSheet                  *actionSheetTitle;
/**
 入居者名（見守られる人）
 */
@property (strong, nonatomic) IBOutlet UITextField         *user0name;
/**
 *  性别
 */
@property (strong, nonatomic) IBOutlet UITextField         *sex;
/**
 居室階
 *
 */
@property (strong, nonatomic) IBOutlet UITextField         *floorNumber;
/**
 *  居室番号
 */
@property (strong, nonatomic) IBOutlet UITextField         *roomNumber;
/**
 *  誕生日
 */
@property (strong, nonatomic) IBOutlet UITextField         *birthday;
/**
 かかりつけ医
 */
@property (strong, nonatomic) IBOutlet UITextField         *kakaritsuke;
/**
 服薬情報
 */
@property (strong, nonatomic) IBOutlet UITextView          *drug;
/**
 *健康診断結果
 */
@property (strong, nonatomic) IBOutlet UITextView          *health;
/**
 その他お願い事項
 */
@property (strong, nonatomic) IBOutlet UITextView          *other;
/**
 *  更新日付
 */
@property (weak, nonatomic) IBOutlet UILabel               *updatedate;
/**
 *  更新者
 */
@property (weak, nonatomic) IBOutlet UILabel               *updatename;

@property (strong, nonatomic) IBOutlet UIImageView         *userIcon;

@property (nonatomic, strong) NSData                       *imagedata; //画像データ

@property (nonatomic,strong) UIView                        *hoverView;

@property (nonatomic,strong) UIImageView                   *bigImg;    //拡大の画像

@property (nonatomic, strong) UIImagePickerController      *imagePicker; //iOSカメラ

@property (weak, nonatomic) IBOutlet UIView              *datePickerView;

@property (strong, nonatomic) IBOutlet DropButton          *facilitiesBtn;

@property (strong, nonatomic) IBOutlet UILabel             *titleLabel;

@property (nonatomic, strong) IBOutlet UIDatePicker        *pickerdate;


@end



@implementation ProfileTableViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.titleLabel.text = self.titleStr;
    
    //キャッシュの写真を取得
    if (self.userid0.length > 0) {
        self.imagedata = [NITUserDefaults objectForKey:self.userid0];
        
        if (self.imagedata) {
            
            self.userIcon.image = [UIImage imageWithData:self.imagedata];
            
        }
    }
    
    //set data
    [self setupData];
    
    _datePickerView.width = NITScreenW;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//  タイムフォーマット
    
    dateFormatter.dateFormat=@"yyyy-MM-dd";
    
    NSDate *date  = [dateFormatter dateFromString:self.birthday.text];
    
    if (date) {
        _pickerdate.date = date;
    } else {
        _pickerdate.date  = [NSDate date];
    }
    
    
}


- (IBAction)cancelDatePicker:(id)sender {
    [_datePickerView removeFromSuperview];
}

- (IBAction)okDatePicker:(id)sender {
    
    self.birthday.text = [_pickerdate.date needDateStatus:NotHaveType];;
    
    [_datePickerView removeFromSuperview];
}


-(void)viewWillAppear:(BOOL)animated{
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [_datePickerView removeFromSuperview];
    [MBProgressHUD hideHUDForView:self.navigationController.view];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //画像をクリック -> セレクタ
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.actionSheetTitle showGGActionSheet];
    }
    //画像をクリック -> 日付けの選択
    if (indexPath.section == 5 && indexPath.row == 0) {
        [self.navigationController.view addSubview:_datePickerView];
        
    }
}

-(GGActionSheet *)actionSheetTitle {
    if (!_actionSheetTitle) {
        _actionSheetTitle = [GGActionSheet ActionSheetWithTitleArray:@[@"写真を撮る",@"アルバムから取得",@"写真を拡大する"] andTitleColorArray:@[NITColor(252, 85, 115),[UIColor darkGrayColor],[UIColor darkGrayColor]] delegate:self];
        _actionSheetTitle.cancelDefaultColor = [UIColor lightGrayColor];
    }
    return _actionSheetTitle;
}


-(void)setupData{
    
    self.user0name.text = _pmodel.user0name;
    self.sex.text = _pmodel.sex;
    self.floorNumber.text = _pmodel.floorno;
    self.roomNumber.text = _pmodel.roomcd;
    
    self.birthday.text = _pmodel.birthday;
    
    self.kakaritsuke.text = _pmodel.kakaritsuke;
    self.drug.text = _pmodel.drug;
    self.health.text = _pmodel.health;
    self.other.text = _pmodel.other;
    self.updatename.text = _pmodel.updatename;
    self.updatedate.text = _pmodel.updatedate;
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}


/**
 *  更新プロフィール
 */

- (IBAction)saveProfile:(id)sender {
    [MBProgressHUD showMessage:@"" toView:self.navigationController.view];
    
    NSString *updatedate = [[NSDate date] needDateStatus:HaveHMSType];
    
    MProfileInfoUpdateParam *param = [[MProfileInfoUpdateParam alloc]init];
    IconModel *iconM = [[IconModel alloc] init];
    iconM.custid = self.userid0;
    iconM.updatedate = updatedate;
    
    
    if (!self.imagedata) {
        UIImage *tmpimage =self.userIcon.image;
        self.imagedata = UIImageJPEGRepresentation(tmpimage, 1.0);
    }
    
    NSString *imageDataStr = [self.imagedata base64EncodedStringWithOptions:0];
    iconM.picdata = imageDataStr;
    
    param.staffid = [NITUserDefaults objectForKey:@"userid1"];
    param.custid = self.userid0;
    param.user0name = self.user0name.text;
    param.sex = self.sex.text;
    param.floorno = self.floorNumber.text;
    param.roomcd = self.roomNumber.text;
    param.birthday = self.birthday.text;
    param.kakaritsuke = self.kakaritsuke.text;
    param.drug = self.drug.text;
    param.health = self.health.text;
    param.other = self.other.text;
    param.updatedate = updatedate;
    param.updatename =[NITUserDefaults objectForKey:@"userid1name"];
    
    
    //更新データ
    [MProfileTool profileInfoUpdateImageWithParam:iconM withImageDatas:nil success:^(NSString *path) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        [NITUserDefaults setObject:self.imagedata forKey:self.userid0];
        NITLog(@"%@",path);
        [MProfileTool profileInfoUpdateWithParam:param success:^(NSString *code) {
            if ([code isEqualToString:@"200"]) {
                [MBProgressHUD showSuccess:@"更新しました！" toView:self.navigationController.view];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                
                [MBProgressHUD showError:@"" toView:self.navigationController.view];
                
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"後ほど試してください" toView:self.navigationController.view];
            NITLog(@"zwupdatecustinfo请求失败");
        }];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        NITLog(@"%@",error.localizedDescription);
        [MBProgressHUD showError:@"アップロード失敗" toView:self.navigationController.view];
    }];
    
}


/**
 画像移動はスクリーンの中間に移動する
 */
- (void)moveToCenterWidth:(CGFloat)widthI withHeight:(CGFloat)heightI
{
    [UIView animateWithDuration:0.5 animations:^{
        self.hoverView.alpha = 1.0f;
        self.bigImg.frame = CGRectMake((NITScreenW - widthI)/2.0, (NITScreenH - heightI)/2.0 , widthI, heightI);
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}


/**
 画像を取り除く
 */
- (void)moveToOrigin
{
    [UIView animateWithDuration:0.5 animations:^{
        self.hoverView.alpha = 0.0f;
        self.bigImg.frame = CGRectMake(NITScreenW/2.0, NITScreenH/2.0, 6, 6);
    } completion:^(BOOL finished) {
        [self.hoverView removeFromSuperview];
        [self.bigImg removeFromSuperview];
        //        self.hoverView = nil;
        self.bigImg = nil;
    }];
}



#pragma mark - GGActionSheet代理方法

/**
 選択 ->(写真を撮る) (アルバムから取得) (写真を拡大する)
 */
-(void)GGActionSheetClickWithIndex:(int)index{
    
    if (index == 0) {
        [MBProgressHUD showMessage:@"" toView:self.navigationController.view];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePicker animated:YES completion:nil];
        
    } else if (index == 1) {
        [MBProgressHUD showMessage:@"" toView:self.navigationController.view];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:_imagePicker animated:YES completion:nil];
        
    } else {
        self.hoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, NITScreenW, NITScreenH)];
        self.hoverView.backgroundColor = [UIColor blackColor];
        [self.hoverView addTapAction:@selector(moveToOrigin) target:self];
        self.hoverView.alpha = 0.0f;
        [self.navigationController.view addSubview:self.hoverView];
        
        self.bigImg = [[UIImageView alloc]init];
        [self.navigationController.view addSubview:self.bigImg];
        
        self.bigImg.image = self.userIcon.image;
        CGFloat widthI = self.bigImg.image.size.width;
        CGFloat heightI = self.bigImg.image.size.height;
        CGFloat maxW = NITScreenW;
        CGFloat maxH = NITScreenH - 100;
        if (widthI > NITScreenW) {
            heightI = maxW / widthI * heightI;
            widthI = maxW;
        }
        if (heightI > maxH) {
            heightI = maxH;
        }
        //            ZLLog(@"%f-%f",widthI,heightI);
        [self moveToCenterWidth:widthI withHeight:heightI];
        [self.bigImg addTapAction:@selector(moveToOrigin) target:self];
    }
}



/**
 画像を作成
 */
-(UIImage *)watermarkImage:(UIImage *)img withName:(NSString *)name

{
    
    NSString* mark = name;
    
    CGFloat w = img.size.width;
    
    CGFloat h = img.size.height;
    
    UIGraphicsBeginImageContext(img.size);
    
    [img drawInRect:CGRectMake(0, 0, w, h)];
    
    NSDictionary *attr = @{
                           NSFontAttributeName: [UIFont systemFontOfSize:36],  //フォントを設定
                           
                           NSForegroundColorAttributeName : [UIColor whiteColor]   //フォントの色を設定して
                           };
    
    
    [mark drawInRect:CGRectMake(10 ,h - 50 , w, 50) withAttributes:attr];  //画像左上角に表示されている
    
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return aimg;
    
}


#pragma mark --  imagePicker delegate Action

/**
 ローカルカメラを起動する
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [MBProgressHUD hideHUDForView:self.navigationController.view];
    
    if (picker.allowsEditing) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSString *updatedate = [[NSDate date] needDateStatus:HaveHMSType];//yyyy-MM-dd HH:mm:ss
        
        
        UIImage *updateimg =  [self watermarkImage:image withName:updatedate];
        
        NSData *imageData = UIImageJPEGRepresentation(updateimg, 0.5);  //サムネイルアップロード
        
        
        self.imagedata = imageData;
//
        self.userIcon.image = [UIImage imageWithData:imageData];
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


/**
 ローカルカメラをキャンセル
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [MBProgressHUD hideHUDForView:self.navigationController.view];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextView *)textField{
    
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
