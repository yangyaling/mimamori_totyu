//
//  EmergencyAController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/1/4.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "EmergencyAController.h"


#import "ABFillButton.h"
#import "NITSegmented.h"

#import "MNoticeTool.h"

@interface EmergencyAController ()<NITSegmentedDelegate>

@property (strong, nonatomic) IBOutlet ABFillButton                  *ABButton;

@property (nonatomic, weak) NSString                                 *MainString;//支援要請タイトル

@property (strong, nonatomic) IBOutlet NITSegmented                  *segmentView;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation EmergencyAController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segmentView.delegate = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.textView.layer.cornerRadius = 6;
    self.textView.layer.borderWidth = 2.5;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    
    [_ABButton setFillPercent:1.0];
    [_ABButton setEmptyButtonPressing:YES];
    [_ABButton configureButtonWithHightlightedShadowAndZoom:YES];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.textView.text = @"";
    
    self.textView.spellCheckingType = UITextSpellCheckingTypeNo;
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.segmentView refreshButtonTag:0];
}


- (IBAction)LongTouchB:(ABFillButton *)sender {
    [_ABButton setFillPercent:1.0];
    [_ABButton setEmptyButtonPressing:YES];
}

/**
 *  发送一条支援要请
 */
-(void)buttonIsEmpty:(ABFillButton *)button{
    
    MNoticeInfoUploadParam *param = [[MNoticeInfoUploadParam alloc]init];
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    param.noticetype = @"2";
    param.registdate = [[NSDate date]needDateStatus:HaveHMSType];
    param.title = self.MainString;
    param.content = self.textView.text;
    
    NITLog(@"userid1-%@\nnoticetype-%@\nregistdate-%@\ntitle-%@\ncontent-%@",param.userid1,param.noticetype,param.registdate,param.title,param.content);
    
    [MNoticeTool noticeInfoUploadWithParam:param success:^(NSString *code) {
        if ([code isEqualToString:@"200"]) {
            [MBProgressHUD  showSuccess:@"送信成功!"];
            //[NITNotificationCenter postNotificationName:@"NITSrue" object:@"selectKey"];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"後ほど試してください"];
    }];
    
    [_ABButton setEmptyButtonPressing:NO];
    
}


-(void)SelectedButtonIndex:(CGFloat)index
{
    
    NSInteger currentIndex = (int)index;
    if (currentIndex == 0) {
        self.MainString = @"メイン棟 1F";
    } else if (currentIndex == 1) {
        self.MainString = @"メイン棟 2F";
    } else if (currentIndex == 2) {
        self.MainString = @"メイン棟 3F";
    } else if (currentIndex == 3) {
        self.MainString = @"サブ棟 1F";
    } else {
        self.MainString = @"サブ棟 2F";
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return  YES;
}


@end
