//
//  DoorFeelTableViewCell.m
//  Mimamori
//
//  Created by totyu3 on 16/8/5.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#define checkNull(__X__)   (__X__) == [NSNull null] ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

#import "DoorFeelTableViewCell.h"
#import "Device.h"
#import "NITPicker.h"

#define plistPath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"ScenarioItems.plist"]

@interface DoorFeelTableViewCell ()
/**
 *  デバイスネーム
 */
@property (weak, nonatomic) IBOutlet UILabel *dfname;
/**
 *  h
 */
@property (weak, nonatomic) IBOutlet UIButton *dftime;
/**
 *  使用なし/反応なし
 */
@property (weak, nonatomic) IBOutlet UILabel *dftype;

@property (nonatomic, strong) NITPicker       *picker;

- (IBAction)showPickerView:(id)sender;


@end

@implementation DoorFeelTableViewCell

/**
 *  如果cell是从storyboard 和 xib创建出来的，就会调用这个方法来初始化cell
 *  每个cell刚创建完就调用一次(这时cell高度永远时44)
 */
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    
//
//}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"doorfeelcell";
    DoorFeelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];//从storyboard创建

    return cell;
}


-(void)setDevice:(Device *)device{
    
    _device = device;
    [self setupData];

    [self setupButton];
}

-(void)setupData{
    //self.dfname.text = self.device.devicename;
    self.dfname.text = [NSString stringWithFormat:@"%@(%@)",self.device.devicename,self.device.nodename];
    self.dftype.text = self.device.deviceValue.rpoint;

    
    
    if ([self.device.deviceValue.time intValue] > 0) {
        NSString *tmpStr = [NSString stringWithFormat:@"%@",self.device.deviceValue.time];
        NSString *result = tmpStr;
        
        [self.dftime setTitle:result forState:UIControlStateNormal];
    }else{
        [self.dftime setTitle:@"-" forState:UIControlStateNormal];
    }

}

-(void)setupButton{
    if (self.editType == NO) {
        self.dftime.userInteractionEnabled = YES;
        self.dftime.backgroundColor = NITColor(245, 245, 245);
    }else{
        self.dftime.userInteractionEnabled = NO;
        self.dftime.backgroundColor = [UIColor clearColor];
    }
}


- (IBAction)showPickerView:(id)sender {
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:self.device];
    [WindowView addSubview:_picker];
}
@end
