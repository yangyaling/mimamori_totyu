//
//  NursingNotesTableViewCell.m
//  Mimamori
//
//  Created by totyu3 on 16/6/8.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "NursingNotesTableViewCell.h"

@implementation NursingNotesTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    NursingNotesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"nursingNotesCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"nursingNotesCell" owner:self options:nil].firstObject;
    }
    return cell;
    
}

-(void)setCellModel:(NursingNotesModel *)CellModel{
    
    _CellModel = CellModel;
    
    _muniteTime.text = CellModel.memotime;
    
    _contentTextView.text = CellModel.content;
}

@end
