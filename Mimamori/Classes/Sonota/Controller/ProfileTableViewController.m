//
//  ProfileTableViewController.m
//  Mimamori
//
//  Created by totyu3 on 16/6/6.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "ProfileTableViewController.h"

#import "MProfileTool.h"

#import "IconModel.h"

#import "MProfileInfoUpdateParam.h"

#import "GGActionSheet.h"

@interface ProfileTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,GGActionSheetDelegate>

@property(nonatomic,strong) GGActionSheet *actionSheetTitle;
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
@property (strong, nonatomic) IBOutlet UIButton          *save;

//@property (nonatomic, strong) NSMutableArray             *profileArray;

@property (strong, nonatomic) IBOutlet UIImageView       *userIcon;

@property (nonatomic, strong) NSData                     *imagedata;

@property (nonatomic,strong) UIView                       *hoverView;

@property (nonatomic,strong) UIImageView                  *bigImg;



@end



@implementation ProfileTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:NITColor(252, 85, 115)];
    self.userIcon.layer.cornerRadius = 6;
    self.userIcon.layer.masksToBounds = YES;
    
    self.imagedata = [NITUserDefaults objectForKey:self.userid0];
    if (self.imagedata) {
        self.userIcon.image = [UIImage imageWithData:self.imagedata];
//        NITLog(@"照片：2 ---%@",self.imagedata);
    }
    
    
    // 缩放手势
//    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
//                                                    initWithTarget:self
//                                                    action:@selector(handlePan:)];
//    [self.bigImg addGestureRecognizer:panGestureRecognizer];
//    [self.bigImg addGestureRecognizer:pinchGestureRecognizer];
    
}

-(void)viewWillAppear:(BOOL)animated{
    //[self.tableView.mj_header beginRefreshing];
    [self setupData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideHUDForView:WindowView];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.actionSheetTitle showGGActionSheet];
        
    }
}

-(GGActionSheet *)actionSheetTitle {
    if (!_actionSheetTitle) {
        _actionSheetTitle = [GGActionSheet ActionSheetWithTitleArray:@[@"写真を撮る",@"写真を拡大する"] andTitleColorArray:@[NITColor(252, 85, 115),[UIColor darkGrayColor]] delegate:self];
        _actionSheetTitle.cancelDefaultColor = [UIColor lightGrayColor];
    }
    return _actionSheetTitle;
}


-(void)setupData{
    
    self.user0name.text = _pmodel.user0name;
    self.sex.text = _pmodel.sex;
    self.birthday.text = _pmodel.birthday;
    self.address.text = _pmodel.address;
    self.kakaritsuke.text = _pmodel.kakaritsuke;
    self.drug.text = _pmodel.drug;
    self.health.text = _pmodel.health;
    self.other.text = _pmodel.other;
    self.updatename.text = _pmodel.updatename;
    self.updatedate.text = _pmodel.date;
}

/**
 * プロフィール情报
 */
//-(void)getProfileInfo{
//    
//    MProfileInfoParam *param = [[MProfileInfoParam alloc]init];
//    
//    param.userid0 = self.userid0;
//    
//    [MProfileTool profileInfoWithParam:param success:^(NSArray *array) {
//        if (array.count > 0){
//            self.profileArray = [ProfileModel mj_objectArrayWithKeyValuesArray:array];
//            [self setupData];
//        } else {
//            [MBProgressHUD hideHUDForView:WindowView];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:WindowView];
//         [MBProgressHUD showError:@"後ほど試してください"];
//    }];
//    
//}

/**
 *  更新プロフィール
 */
-(void)updateProfileInfo{
    [MBProgressHUD showMessage:@"" toView:WindowView];
    NSString *updatedate = [[NSDate date] needDateStatus:HaveHMSType];
    // 请求参数
    MProfileInfoUpdateParam *param = [[MProfileInfoUpdateParam alloc]init];
    IconModel *iconM = [[IconModel alloc] init];
    iconM.userid0 = self.userid0;
    iconM.updatedate = updatedate;
    NSString *imageDataStr = [self.imagedata base64EncodedStringWithOptions:0];
    
    iconM.picdata = imageDataStr;
    
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    param.userid0 = self.userid0;
    param.user0name = self.user0name.text;
    param.sex = self.sex.text;
    param.birthday = self.birthday.text;
    param.address = self.address.text;
    param.kakaritsuke = self.kakaritsuke.text;
    param.drug = self.drug.text;
    param.health = self.health.text;
    param.other = self.other.text;
    param.updatedate = updatedate;
    param.updatename =[NITUserDefaults objectForKey:@"userid1name"];
    
    
//    NITLog(@"%@\n%@\n照片：2 ---%@",self.userid0,updatedate,self.imagedata);
    //
    [MProfileTool profileInfoUpdateImageWithParam:iconM withImageDatas:nil success:^(NSString *path) {
        [MBProgressHUD hideHUDForView:WindowView];
        [NITUserDefaults setObject:self.imagedata forKey:self.userid0];
        NITLog(@"%@",path);
        [MProfileTool profileInfoUpdateWithParam:param success:^(NSString *code) {
            [MBProgressHUD showSuccess:@"更新しました！"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"後ほど試してください"];
            NITLog(@"zwupdatecustinfo请求失败");
        }];
        //http://mimamori2.azurewebsites.net/upload/0002.jpg
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:WindowView];
        NITLog(@"%@",error.localizedDescription);
        [MBProgressHUD showError:@"アップロード失敗"];
    }];
    
    
}

//　点击保存按钮
- (IBAction)saveProfile:(id)sender {
    
    if (!self.imagedata) {
        [MBProgressHUD showError:@"写真をアップロード下さい"];
        return;
    }
    
    if (!self.user0name.text.length) {
        [MBProgressHUD showError:@"氏名を入力して下さい"];
        return;
    }
    if (!self.sex.text.length) {
        [MBProgressHUD showError:@"性别を入力して下さい"];
        return;
    }
    if (!self.birthday.text.length) {
        [MBProgressHUD showError:@"誕生日を入力して下さい"];
        return;
    }
    if (!self.address.text.length) {
        [MBProgressHUD showError:@"現住所を入力して下さい"];
        return;
    }
    if (!self.kakaritsuke.text.length) {
        [MBProgressHUD showError:@"かかりつけ医を入力して下さい"];
        return;
    }
    if (!self.drug.text.length) {
        [MBProgressHUD showError:@"服薬情報を入力して下さい"];
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

//移动图片
//- (void) handlePan:(UIPanGestureRecognizer*) recognizer
//{
//    CGPoint translation = [recognizer translationInView:self.view];
//    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
//                                         recognizer.view.center.y + translation.y);
//    [recognizer setTranslation:CGPointZero inView:self.view];
//    
//}
////手势方法缩小图片
//- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer   {
//    UIView *view = pinchGestureRecognizer.view;
//    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
//        pinchGestureRecognizer.scale = 1;
//    }
//}

//显示大图片到屏幕中心
- (void)moveToCenterWidth:(CGFloat)widthI withHeight:(CGFloat)heightI
{
    [UIView animateWithDuration:0.5 animations:^{
        self.hoverView.alpha = 1.0f;
        self.bigImg.frame = CGRectMake((NITScreenW - widthI)/2.0, (NITScreenH - heightI)/2.0 , widthI, heightI);
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}

//移除图
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
-(void)GGActionSheetClickWithIndex:(int)index{
    if (index == 0) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else if (index == 1) {
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
    } else {
        
    }
}



-(UIImage *)watermarkImage:(UIImage *)img withName:(NSString *)name

{
    
    NSString* mark = name;
    
    int w = img.size.width;
    
    int h = img.size.height;
    
    UIGraphicsBeginImageContext(img.size);
    
    [img drawInRect:CGRectMake(0, 0, w, h)];
    
    NSDictionary *attr = @{
                           NSFontAttributeName: [UIFont systemFontOfSize:36],  //设置字体
                           
                           NSForegroundColorAttributeName : [UIColor whiteColor]   //设置字体颜色
                           };
    
    
    [mark drawInRect:CGRectMake(10 , h - 50 , w, 50) withAttributes:attr];  //右下角
    
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return aimg;
    
}


#pragma mark --  imagePicker delegate Action
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (picker.allowsEditing) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSString *updatedate = [[NSDate date] needDateStatus:HaveHMSType];
        
        UIImage *scaleImage = [self scaleImage:image toScale:0.3];
        
        UIImage *updateimg =  [self watermarkImage:scaleImage withName:updatedate];
        
        //图片压缩，因为原图都是很大的，不必要传原图
        NSData *imageData = UIImageJPEGRepresentation(updateimg, 0.5);
        
        
//        NITLog(@"照片：1 ---%@",imageData);
        self.imagedata = imageData;
//
        //UIImagePickerControllerMediaType
        //UIImagePickerControllerCropRect
        //UIImagePickerControllerEditedImage
        //UIImagePickerControllerOriginalImage
        self.userIcon.image = [UIImage imageWithData:imageData];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
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
