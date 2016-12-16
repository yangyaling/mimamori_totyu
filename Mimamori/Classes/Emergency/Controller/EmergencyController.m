//
//  EmergencyController.m
//  Mimamori
//
//  Created by totyu2 on 2016/06/07.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "EmergencyController.h"
#import "ABFillButton.h"
#import "NITSegmented.h"

#import "MNoticeTool.h"

@interface EmergencyController ()<NITSegmentedDelegate>

@property (strong, nonatomic) IBOutlet ABFillButton                  *ABButton;

@property (nonatomic, weak) NSString                                 *MainString;//支援要請タイトル

@property (strong, nonatomic) IBOutlet NITSegmented                  *segmentView;

@end

@implementation EmergencyController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//区切り線を非表示にする
    self.segmentView.delegate = self;
    
    [_ABButton setFillPercent:1.0];
    [_ABButton setEmptyButtonPressing:YES];
    [_ABButton configureButtonWithHightlightedShadowAndZoom:YES];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
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
    param.noticetype = @"0";
    param.registdate = [[NSDate date]needDateStatus:HaveHMSType];
    param.title = self.MainString;
    
    [MNoticeTool noticeInfoUploadWithParam:param success:^(NSString *code) {
        if ([code isEqualToString:@"200"]) {
            [MBProgressHUD  showSuccess:@"送信成功!"];
            //[NITNotificationCenter postNotificationName:@"NITSrue" object:@"selectKey"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
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

@end
