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
  湿度
 */
@property (strong, nonatomic) IBOutlet UILabel *humidity;

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
    
    NSString *str1 = self.CellModel.user0name = [NSNull null] ? @"" : self.CellModel.user0name;
    NSString *str2 = [self.CellModel.roomid isEqual:[NSNull null]] ? @"" : self.CellModel.roomid;
    NSString *str3 = self.CellModel.dispname = [NSNull null] ? @"" : self.CellModel.dispname;
    NSString *str4 = [self.CellModel.tvalue isEqual:[NSNull null]] ? @"" : self.CellModel.tvalue;
    NSString *str5 = [self.CellModel.tunit isEqual:[NSNull null]] ? @"" : self.CellModel.tunit;
    NSString *str6 = [self.CellModel.hvalue isEqual:[NSNull null]] ? @"" : self.CellModel.hvalue;
    NSString *str7 = [self.CellModel.hunit isEqual:[NSNull null]] ? @"" : self.CellModel.hunit;
    NSString *str8 = [self.CellModel.bd isEqual:[NSNull null]] ? @"" : self.CellModel.bd;
    
//    if (str1 || str2 || str3 || str4 || str5 || str6 || str7 || str8) {
//        
//    }
    
    //　表示名
    NSString *strname = [NSString stringWithFormat:@"%@(%@)",str1,str2];
    
    self.name.text = strname;
    
    NSString *strdipname = [NSString stringWithFormat:@"* %@",str3];
    
    self.dipname.text = strdipname;
    
    //　温度
    
    self.temperature.text = [NSString stringWithFormat:@"%.1f%@",[str4 floatValue],str5];
   
    
    
    self.humidity.text = [NSString stringWithFormat:@"%.1f%@",[str6 floatValue],str7];
   
    
    
    //　明るさ
    self.luminance.text = [NSString stringWithFormat:@"%@",str8];
   

}


- (IBAction)addNursingNotes:(UIButton*)sender {
    
    //通知代理
    if ([self.delegate respondsToSelector:@selector(addBtnClicked:)]) {
        [self.delegate addBtnClicked:self];
    }
    
}

@end
