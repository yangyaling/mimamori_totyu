//
//  NursingNotesTableViewCell.h
//  Mimamori
//
//  Created by totyu3 on 16/6/8.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NursingNotesModel.h"

@interface NursingNotesTableViewCell : UITableViewCell
/**
 *  介护记录时间 Label
 */
@property (weak, nonatomic) IBOutlet UILabel *muniteTime;
/**
 *  介护记录内容 TextView
 */
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
/**
 *  介护记录模型
 */
@property (nonatomic, strong)  NursingNotesModel *CellModel;
/**
 *  cell初始化
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
