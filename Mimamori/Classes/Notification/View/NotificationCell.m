//
//  NotificationCell.m
//  Mimamori
//
//  Created by totyu2 on 2016/06/06.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "NotificationCell.h"
#import "NotificationModel.h"
#import "NoticeTimeModel.h"

@interface NotificationCell ()

@property (weak, nonatomic) IBOutlet UILabel                      *notifType;  //cell的种类

@property (weak, nonatomic) IBOutlet UILabel                      *notifEvent; //cell详情事件

@property (strong, nonatomic) IBOutlet UIButton                   *Srue;

@property (strong, nonatomic) IBOutlet UILabel                    *inputTime;

@end


@implementation NotificationCell


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    NotificationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:self options:nil].firstObject;
    }
    return cell;
}


- (IBAction)ButtonClick:(UIButton *)sender {
    // 1.让按钮文字变为“確認済”
    sender.enabled = NO;
    
    [sender setTitle:@"確認済" forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor lightGrayColor];
    // 2.通知代理
    if ([self.delegate respondsToSelector:@selector(notificationCellBtnClicked:)]) {
        [self.delegate notificationCellBtnClicked:self];
    }
    
}


-(void)setNotice:(NotificationModel *)notice{
    _notice = notice;
    
    
    // ステータスボタン
    if (notice.status == 0) {
        [self.Srue setHidden:NO];
        [self.Srue setTitle:@"確認必要" forState:UIControlStateNormal];
        [self.Srue setEnabled:YES];
        self.Srue.backgroundColor = NITColor(76, 164, 255);
        
    } else {
        [self.Srue setHidden:NO];
        [self.Srue setTitle:@"確認済" forState:UIControlStateNormal];
        [self.Srue setEnabled:NO];
        self.Srue.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    // タイトル
//    if (_notice.type == 0) {
//        NSString *string = [NSString stringWithFormat:@"%@%@",@"",_notice.username];
//        self.notifType.text = string;
//        self.notifEvent.text = _notice.title;
//        
    if (notice.type == 1) {
        NSString *string = [NSString stringWithFormat:@"<センサー>%@",notice.groupname];
        self.notifType.text = string;
        self.notifEvent.text = notice.title;
        
    } else  {
        NSString *string = [NSString stringWithFormat:@"<支援要請>%@",notice.username];
        self.notifType.text = string;
        self.notifEvent.text = notice.title;
        self.inputTime.text = notice.registdate;
    }
    
    //最終更新時間
//    id date = [_notice valueForKey:@"registdate"];
//    if ([date isKindOfClass:[NSDictionary class]]) {
//        NSString *dateStr = [date valueForKey:@"date"];
//
//        
//    }
    
    
}


/*
-(void)setCellModel:(NotificationModel *)cellModel{
    
    self.cellModel = cellModel;
    
    id date = [cellModel valueForKey:@"registdate"];
    if ([date isKindOfClass:[NSDictionary class]]) {
        NSString *dateStr = [date valueForKey:@"date"];
        NITLog(@"date---%@",dateStr);
        
        //NoticeTimeModel *timeModel = [NoticeTimeModel mj_objectWithKeyValues:CellModel.registdate];
        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate *tmpdate = [formatter dateFromString:dateStr];
//        NSString *time = [tmpdate needDateStatus:HaveHMSType];
        
        self.inputTime.text = [dateStr substringToIndex:19];
    }
    
    
    NSString * status = cellModel.status;
    
    if ([status isEqualToString:@"0"]) {
        [self.Srue setHidden:NO];
        [self.Srue setTitle:@"確認必要" forState:UIControlStateNormal];
        self.Srue.backgroundColor = NITColor(76, 164, 255);
        
    } else {
        [self.Srue setHidden:NO];
        [self.Srue setTitle:@"確認済" forState:UIControlStateNormal];
        self.Srue.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    if (self.cellModel.type == 0) {
        NSString *string = [NSString stringWithFormat:@"%@%@",@"<支援要請>",self.cellModel.username];
        self.notifType.text = string;
        self.notifEvent.text = self.cellModel.title;
        
    } else if (self.cellModel.type == 1) {
        NSString *string = [NSString stringWithFormat:@"%@%@",@"<センサー>",self.cellModel.groupname];
        self.notifType.text = string;
        self.notifEvent.text = self.cellModel.title;
        
    } else {
        if (self.cellModel.type == 2) {
            NSString *string = [NSString stringWithFormat:@"%@%@->%@",@"<お知らせ>",self.cellModel.username, self.cellModel.groupname];
            //        NITLog(@"ooooooo%@",string);
            self.notifType.text = string;
            [self.Srue setHidden:YES];
            self.notifEvent.text = self.cellModel.title;
        }
        
    }
    

}
 */

@end
