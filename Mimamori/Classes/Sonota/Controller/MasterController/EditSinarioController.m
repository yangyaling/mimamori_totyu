//
//  EditSinarioController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "EditSinarioController.h"
#import "NITPicker.h"
@interface EditSinarioController ()<MyPickerDelegate>
@property (strong, nonatomic) IBOutlet DropButton          *facilityBtn;

@property (strong, nonatomic) IBOutlet UILabel             *titleView;

@property (strong, nonatomic) IBOutlet UIButton            *editButton;

@property (strong, nonatomic) IBOutlet UIView              *footerView;

@property (strong, nonatomic) IBOutlet UIView              *settingBGView;

@property (strong, nonatomic) IBOutlet UILabel             *signLabel;

@property (nonatomic, strong) NITPicker                    *picker;

@property (strong, nonatomic) IBOutlet UISegmentedControl  *mySegment;

@property (nonatomic, assign) BOOL                         isOpen;

@property (strong, nonatomic) IBOutlet UIButton            *leftTimeButton;
@property (strong, nonatomic) IBOutlet UIButton            *rightTimeButton;

//温度-湿度-照明-人感
@property (strong, nonatomic) IBOutlet UIButton            *wdButton1;
@property (strong, nonatomic) IBOutlet UIButton            *wdButton2;
@property (strong, nonatomic) IBOutlet UIButton            *sdButton1;
@property (strong, nonatomic) IBOutlet UIButton            *sdButton2;
@property (strong, nonatomic) IBOutlet UIButton            *zmButton1;
@property (strong, nonatomic) IBOutlet UIButton            *zmButton2;
@property (strong, nonatomic) IBOutlet UIButton            *rgButton1;
@property (strong, nonatomic) IBOutlet UIButton            *rgButton2;

@property (strong, nonatomic) IBOutlet UILabel             *cxID;

@property (strong, nonatomic) IBOutlet UITextField         *sinarioName;

@property (strong, nonatomic) IBOutlet UITextField         *ariText;


@end

@implementation EditSinarioController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cxID.text = self.maxid;
    
    self.titleView.text = self.labelTitle;
    self.leftTimeButton.layer.borderWidth = 0.6;
    self.rightTimeButton.layer.borderWidth = 0.6;
    self.leftTimeButton.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.rightTimeButton.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.leftTimeButton.backgroundColor = NITColorAlpha(244, 244, 244, 0.5);
    self.rightTimeButton.backgroundColor = NITColorAlpha(244, 244, 244, 0.5);
    
    
    if (self.isEdit) {
        self.isOpen = NO;
        [self.settingBGView setHidden:YES];
        [self.footerView setHidden:YES];
        [self.signLabel setHidden:NO];
        
        [self buttonStatus:NO withColor:NITColor(235, 235, 241)];
    } else {
        self.isOpen = YES;
        [self.signLabel setHidden:YES];
        [self.editButton setHidden:YES];
        [self buttonStatus:YES withColor:[UIColor whiteColor]];
    }
    
    [self getnlInfo];
}


//数据请求
- (void)getnlInfo {
    
    NSDictionary *dic = @{@"protoid":self.maxid};
    
    [MHttpTool postWithURL:NITGetSPInfo params:dic success:^(id json) {
        
        [self.tableView.mj_header endRefreshing];
        
        if (self.isEdit) {
            if (json) {
                NSArray *tmpArr = [json objectForKey:@"splist"];
                
                NSDictionary *dicOne = tmpArr.firstObject;
                
                NSDictionary *dicTwo = [tmpArr objectAtIndex:1];
                
                NSDictionary *dicThree = [tmpArr objectAtIndex:2];
                
                NSDictionary *dicFour = tmpArr.lastObject;
                
                self.sinarioName.text = [json objectForKey:@"protoname"];
                
                
                //温度
                NSString *strT1 = [NSString stringWithFormat:@"%@H",dicOne[@"time"]];
                NSString *strV1 = [NSString stringWithFormat:@"%@%@%@",dicOne[@"value"],@"℃",dicOne[@"rpoint"]];
                [self.wdButton1 setTitle:strT1 forState:UIControlStateNormal];
                [self.wdButton2 setTitle:strV1 forState:UIControlStateNormal];
                
                
                //湿度
                NSString *strT2 = [NSString stringWithFormat:@"%@H",dicTwo[@"time"]];
                NSString *strV2 = [NSString stringWithFormat:@"%@%@%@",dicTwo[@"value"],@"%",dicTwo[@"rpoint"]];
                [self.sdButton1 setTitle:strT2 forState:UIControlStateNormal];
                [self.sdButton2 setTitle:strV2 forState:UIControlStateNormal];
                
                //照明
                NSString *strT3 = [NSString stringWithFormat:@"%@H",dicThree[@"time"]];
                NSString *strV3 = [NSString stringWithFormat:@"%@%@%@",dicThree[@"value"],@"%",dicThree[@"rpoint"]];
                [self.zmButton1 setTitle:strT3 forState:UIControlStateNormal];
                [self.zmButton2 setTitle:strV3 forState:UIControlStateNormal];
                
                //门 - 人感
                NSString *strT4 = [NSString stringWithFormat:@"%@H",dicFour[@"time"]];
                NSString *strV4 = [NSString stringWithFormat:@"%@%@%@",dicFour[@"value"],@"-",dicFour[@"rpoint"]];
                [self.rgButton1 setTitle:strT4 forState:UIControlStateNormal];
                [self.rgButton2 setTitle:strV4 forState:UIControlStateNormal];
            }
            [self.tableView reloadData];
            
        } else {
            
            
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        NITLog(@"%@",error);
    }];
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}

//时间段的选择
- (IBAction)selectedTimeButton:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex != 4) {
        [self.leftTimeButton setEnabled:NO];
        [self.rightTimeButton setEnabled:NO];
        self.leftTimeButton.backgroundColor = NITColorAlpha(244, 244, 244, 0.5);
        self.rightTimeButton.backgroundColor = NITColorAlpha(244, 244, 244, 0.5);
    }
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.leftTimeButton setTitle:@"- -" forState:UIControlStateNormal];
            [self.rightTimeButton setTitle:@"- -" forState:UIControlStateNormal];
            break;
        case 1:
            [self.leftTimeButton setTitle:@"04  ： 00" forState:UIControlStateNormal];
            [self.rightTimeButton setTitle:@"09  ： 00" forState:UIControlStateNormal];
            break;
        case 2:
            [self.leftTimeButton setTitle:@"09  ： 00" forState:UIControlStateNormal];
            [self.rightTimeButton setTitle:@"18  ： 00" forState:UIControlStateNormal];
            break;
        case 3:
            [self.leftTimeButton setTitle:@"18  ： 00" forState:UIControlStateNormal];
            [self.rightTimeButton setTitle:@"04  ： 00" forState:UIControlStateNormal];
            break;
        case 4:
            [self.leftTimeButton setEnabled:YES];
            [self.rightTimeButton setEnabled:YES];
            self.leftTimeButton.backgroundColor = [UIColor whiteColor];
            self.rightTimeButton.backgroundColor = [UIColor whiteColor];
            break;
            
        default:
            break;
    }
    
}

//其他时间的点击弹窗
- (IBAction)timeButtonClick:(UIButton *)sender {
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:nil cellNumber:0];
    
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
}

- (IBAction)editCell:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"編集"]) {
        [sender setTitle:@"完了" forState:UIControlStateNormal];
    
        self.isOpen = YES;
        [self.signLabel setHidden:YES];
        [self.settingBGView setHidden:NO];
        [self.footerView setHidden:NO];
        
        
        [self.leftTimeButton setEnabled:YES];
        [self.rightTimeButton setEnabled:YES];
        
        [self buttonStatus:YES withColor:[UIColor whiteColor]];
        //进入编辑状态
        //        [self.tableView setEditing:YES animated:YES];///////////
    }else{
        [sender setTitle:@"編集" forState:UIControlStateNormal];
        self.isOpen = NO;
        [self.signLabel setHidden:NO];
        [self.footerView setHidden:YES];
        [self.settingBGView setHidden:YES];
        [self buttonStatus:NO withColor:NITColor(235, 235, 241)];
        
        [self saveInfo:nil]; //
        
        //取消编辑状态
        //        [self.tableView setEditing:NO animated:YES];/
        
    }
    
    [CATransaction setCompletionBlock:^{
        [self.tableView reloadData];
    }];
}

- (IBAction)saveInfo:(UIButton *)sender {
    
    
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen) {
        if (indexPath.row == 2) {
            return 90;
        } else {
            return 40;
        }
    } else {
        return 40;
    }
    
}
- (IBAction)showScrollView:(UIButton *)sender {
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:nil cellNumber:0];
    
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return  YES;
}

-(void)buttonStatus:(BOOL)noOp withColor:(UIColor *)color {
    
    [self.wdButton1 setEnabled:noOp];
    [self.wdButton1 setBackgroundColor:color];
    [self.wdButton2 setEnabled:noOp];
    [self.wdButton2 setBackgroundColor:color];
    
    [self.sdButton1 setEnabled:noOp];
    [self.sdButton1 setBackgroundColor:color];
    [self.sdButton2 setEnabled:noOp];
    [self.sdButton2 setBackgroundColor:color];
    
    [self.zmButton1 setEnabled:noOp];
    [self.zmButton1 setBackgroundColor:color];
    [self.zmButton2 setEnabled:noOp];
    [self.zmButton2 setBackgroundColor:color];
    
    [self.rgButton1 setEnabled:noOp];
    [self.rgButton1 setBackgroundColor:color];
    [self.rgButton2 setEnabled:noOp];
    [self.rgButton2 setBackgroundColor:color];
}


@end
