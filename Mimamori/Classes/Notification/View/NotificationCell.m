//
//  NotificationCell.m
//  Mimamori
//
//  Created by NISSAY IT on 2016/06/06.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//
#import "NotificationCell.h"

#import "NotificationModel.h"

#import "NoticeTimeModel.h"

@interface NotificationCell ()

@property (weak, nonatomic) IBOutlet UILabel                      *notifType;  

@property (weak, nonatomic) IBOutlet UILabel                      *notifEvent;

@property (strong, nonatomic) IBOutlet UIButton                   *Srue;

@property (strong, nonatomic) IBOutlet UILabel                    *inputTime;

@end


@implementation NotificationCell


/**
 登録cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    NotificationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:self options:nil].firstObject;
    }
    return cell;
}


- (IBAction)ButtonClick:(UIButton *)sender {
    // “確認済”
    sender.enabled = NO;
    
    [sender setTitle:@"確認済" forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor lightGrayColor];
 
    //デリゲートの転送
    if ([self.delegate respondsToSelector:@selector(notificationCellBtnClicked:)]) {
        [self.delegate notificationCellBtnClicked:self];
    }
    
}


/**
 モデルコピー
 */
-(void)setNotice:(NotificationModel *)notice{
    
    _notice = notice;
    
    // ステータスボタン
    if (notice.status == 0) {
        [self.Srue setHidden:NO];
        [self.Srue setTitle:@"確認必要" forState:UIControlStateNormal];
        [self.Srue setEnabled:YES];
        self.Srue.backgroundColor = NITColor(252, 85, 115);
        
    } else {
        [self.Srue setHidden:NO];
        [self.Srue setTitle:@"確認済" forState:UIControlStateNormal];
        [self.Srue setEnabled:NO];
        self.Srue.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    self.notifEvent.text = notice.title;
    self.inputTime.text = notice.registdate;
    
    NSString *string = [NSString stringWithFormat:@"<アラート>%@",notice.username];
    self.notifType.text = string;
    
    
    
}


@end
