//
//  LifesTableViewCell.h
//  Mimamori
//
//  Created by totyu3 on 16/6/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LifeUserListModel,LifesTableViewCell;

@protocol LifesTableViewCellDelegate <NSObject>
@optional

-(void)addBtnClicked:(LifesTableViewCell*)lifesCell;

@end


@interface LifesTableViewCell : UITableViewCell


@property (nonatomic, strong)  LifeUserListModel *CellModel;

@property (nonatomic, assign) int                 segmentIndex;


@property (nonatomic,weak) id<LifesTableViewCellDelegate> delegate;



+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
