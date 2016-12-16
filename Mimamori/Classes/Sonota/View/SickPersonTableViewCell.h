//
//  SickPersonTableViewCell.h
//  Mimamori
//
//  Created by totyu3 on 16/6/3.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SickPersonModel.h"

@interface SickPersonTableViewCell : UITableViewCell

/**
 *  病人名字
 */
@property (weak, nonatomic) IBOutlet UILabel *sickPersonLabel;
/**
 *  介护人模型
 */
@property (nonatomic, strong)  SickPersonModel *CellModel;
/**
 *  cell初始化
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
