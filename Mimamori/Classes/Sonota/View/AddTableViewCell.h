//
//  AddTableViewCell.h
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titlename;
@property (strong, nonatomic) IBOutlet UILabel *sendtime;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
