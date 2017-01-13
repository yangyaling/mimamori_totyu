//
//  LifesTableViewCell.m
//  Mimamori
//
//  Created by totyu3 on 16/6/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "LifesTableViewCell.h"

#import "LifeUserListModel.h"

@interface LifesTableViewCell ()
/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *name;
/**
 *  温度
 */
@property (weak, nonatomic) IBOutlet UILabel *temperature;
/**
 *  亮度
 */
@property (weak, nonatomic) IBOutlet UILabel *luminance;
/**
 *  状态图片
 */
@property (weak, nonatomic) IBOutlet UIButton *stateImage;
/**
 *  状态文字
 */
@property (weak, nonatomic) IBOutlet UILabel *stateText;

@property (strong, nonatomic) IBOutlet UILabel *dipname;


@end

@implementation LifesTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    LifesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"lifeCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"lifeCell" owner:self options:nil].firstObject;
    }
    
    return cell;
    
}

-(void)setCellModel:(LifeUserListModel *)CellModel{
    
    _CellModel = CellModel;
    
    // 1.表示名、温度、明るさ
    [self settingData];
    
    
    //　2.0 シナリオ結果　(センサーデータ)
    if (self.segmentIndex == 0) {
        
        //　ボタンクリックを無効させる
        self.stateImage.enabled = NO;
        
        NSString *result = self.CellModel.resultname;
        if (result.length) {
            self.stateText.text = result;
            if ([result isEqualToString:@"設定なし"]) {
                [self.stateImage setBackgroundImage:[UIImage imageNamed:@"un"] forState:UIControlStateNormal];
            }else if ([result isEqualToString:@"異常検知なし"]){
                [self.stateImage setBackgroundImage:[UIImage imageNamed:@"smilingface"] forState:UIControlStateNormal];
            }else if ([result isEqualToString:@"異常検知あり"]){
                [self.stateImage setBackgroundImage:[UIImage imageNamed:@"cryingface"] forState:UIControlStateNormal];
            }
        }

    }
    
    
    // 2.1 メモの新規追加ボタン　(介護メモ)
    if (self.segmentIndex == 1){
        
        self.stateImage.enabled = YES;
        [self.stateImage setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
        self.stateText.textColor = [UIColor darkGrayColor];
        self.stateText.text = @"新規追加";
    }
    
}

-(void)settingData{
    
    //　表示名
    NSString *strname = [NSString stringWithFormat:@"%@(%@)",self.CellModel.user0name,self.CellModel.roomname];
    
    self.name.text = strname;
    
    NSString *strdipname = [NSString stringWithFormat:@"* %@",self.CellModel.dispname];
    self.dipname.text = strdipname;
    //　温度
    NSString *tvalue = self.CellModel.tvalue;
    if (tvalue.length) {
        self.temperature.text = [NSString stringWithFormat:@"%@%@",tvalue,self.CellModel.tunit];
    }else{
        self.temperature.text = @"";
    }
    
    //　明るさ
    NSString *luminance = self.CellModel.bd;
    if (luminance) {
        self.luminance.text = [NSString stringWithFormat:@"%@",luminance];
    }else{
        self.luminance.text = @"";
    }

}


- (IBAction)addNursingNotes:(UIButton*)sender {
    
    //通知代理
    if ([self.delegate respondsToSelector:@selector(addBtnClicked:)]) {
        [self.delegate addBtnClicked:self];
    }
    
}

@end
