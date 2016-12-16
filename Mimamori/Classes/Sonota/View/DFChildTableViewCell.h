//
//  DFChildTableViewCell.h
//  Mimamori
//
//  Created by totyu3 on 16/8/5.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Device;
@protocol DFChildTableViewCellDelegate <NSObject>

@optional
-(void)checkResult:(BOOL)result;

@end

@interface DFChildTableViewCell : UITableViewCell

/**
 *  是否是编辑模式
 */
@property (nonatomic, assign) BOOL   editType;


@property (nonatomic, strong)  Device *device;

@property (nonatomic,weak) id<DFChildTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
