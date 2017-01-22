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
    
    NSData *strdata = [CellModel.content dataUsingEncoding:NSUTF8StringEncoding];
    NSError *parseError = nil;
//    id strdic
    NSArray *strarr = [NSJSONSerialization JSONObjectWithData:strdata options:NSJSONReadingMutableLeaves error:&parseError];
//    NITLog(@"%@\n%@",[strdic objectForKey:@"excretion"],[strdic objectForKey:@"temperature"]);
    NSDictionary *strdic  = [strarr.firstObject copy];
    NSString *newcontent = [NSString stringWithFormat:@" 体温:%@; \n 血压:%@; \n 排泄:%@; \n 食事:%@; \n その他:%@",strdic[@"temperature"],strdic[@"bloodpressure"],strdic[@"excretion"],strdic[@"eat"],strdic[@"other"]];
    
    _contentTextView.text = newcontent;
}

@end
