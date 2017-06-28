//
//  LifesTableViewCell.h
//  Mimamori
//
//  Created by NISSAY IT on 16/6/7.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LifeUserListModel,LifesTableViewCell;

@protocol LifesTableViewCellDelegate <NSObject>
@optional

-(void)addBtnClicked:(LifesTableViewCell*)lifesCell;

@end


@interface LifesTableViewCell : UITableViewCell


/**
セル モデル
 */
@property (nonatomic, strong)  LifeUserListModel *CellModel;

@property (nonatomic, assign) int                 segmentIndex;


@property (nonatomic,weak) id<LifesTableViewCellDelegate> delegate;



+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
