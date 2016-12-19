//
//  NotificationCell.h
//  Mimamori
//
//  Created by totyu2 on 2016/06/06.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotificationModel,NotificationCell;

@protocol NotificationCellDelegate <NSObject>

@optional
-(void)notificationCellBtnClicked:(NotificationCell *)notificationCell;

@end



@interface NotificationCell : UITableViewCell

@property (nonatomic, strong)  NotificationModel *notice;

@property (nonatomic, weak) id<NotificationCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;





@end
