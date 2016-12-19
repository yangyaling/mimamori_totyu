//
//  DoorFeelTableViewCell.h
//  Mimamori
//
//  Created by totyu3 on 16/8/5.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Device;

@interface DoorFeelTableViewCell : UITableViewCell

/**
 *  是否是编辑模式
 */
@property (nonatomic, assign) BOOL   editType;


@property (nonatomic, strong)  Device *device;

//@property (nonatomic, assign)  int reloadFlag; //0:显示  1:保存scenarioitems


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
