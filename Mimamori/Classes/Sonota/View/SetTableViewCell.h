//
//  SetTableViewCell.h
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userinfolabel;

@property (strong, nonatomic) IBOutlet UILabel *sensernumber;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
