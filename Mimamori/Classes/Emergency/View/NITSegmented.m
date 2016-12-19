//
//  NITSegmented.m
//  timerTest
//
//  Created by totyu3 on 16/5/31.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "NITSegmented.h"

@interface NITSegmented()

@property (nonatomic,strong) NSMutableArray             *arrButtons;

@property (assign          ) float                       btnWidth;

@property (assign          ) float                       btnHeight;

@property (nonatomic,strong) UIColor *selectedTitleColor;   //选中字体颜色
@property (nonatomic,strong) UIColor *defaultTitleColor;    //默认字体颜色

@property (nonatomic,strong) UIColor *selectedBackgroundColor;   //选中背景颜色
@property (nonatomic,strong) UIColor *defaultBackgroundColor;    //默认背景颜色

@end

@implementation NITSegmented


#pragma mark - 无固定的type
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    _arrButtons = [NSMutableArray new];
    
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _btnWidth = (CGRectGetWidth(self.frame)-3)/3;
        
        _btnHeight = (CGRectGetHeight(self.frame)-13)/2;
        
        _defaultBackgroundColor =  NITColor(211, 211, 211);
        
        _selectedBackgroundColor = NITColor(76, 164, 255);
        
        _selectedTitleColor = [UIColor whiteColor];
        
        _defaultTitleColor = [UIColor blackColor];
        
        
        //根据传过来的数组创建button
        for (int i = 0; i< 5; i++)
        {
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(_btnWidth*i, 1, _btnWidth, _btnHeight)];
            
            btn.backgroundColor = _defaultBackgroundColor;
            
            //设置创建按钮tag
            btn.tag = i;

            //设置按钮点击属性
            [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            NSString *title = [NSString stringWithFormat:@"%dF",i+1];

            //设置个个按钮标题
            [btn setTitle:title forState:UIControlStateNormal];
            
            if (i== 0) {
                btn.selected = YES;
                btn.backgroundColor = _selectedBackgroundColor;
            }
            
            
            if (i > 2) {
                btn.x = (i-3)*_btnWidth;
                btn.y = _btnHeight + 13;
                
                NSString *title = [NSString stringWithFormat:@"%dF",i-2];
                
                //设置个个按钮标题
                [btn setTitle:title forState:UIControlStateNormal];
                
            }
            
            btn.layer.borderWidth = 0.5;
            
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            
//            NSLog(@"_btnWidth%f",btn.width);
            btn.showsTouchWhenHighlighted = YES;
            
            
            //设置选中按钮标题颜色
            [btn setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
            
            
            //设置非选中按钮标题颜色
            [btn setTitleColor:_defaultTitleColor forState:UIControlStateNormal];
            
            //添加按钮
            [self addSubview:btn];
            
            [_arrButtons addObject:btn];
        }
    }
    return self;
}


#pragma mark - 点击事件
- (void)btnPressed:(UIButton *)sender
{
    
        
    UIButton *btnnnn = (UIButton *)sender;
    
    
    for (UIButton *btn in _arrButtons)
    {
        if (btn.tag == btnnnn.tag)
        {
            btn.selected = YES;
            btn.backgroundColor = _selectedBackgroundColor;
        }
        else
        {
            btn.selected = NO;
            btn.backgroundColor = _defaultBackgroundColor;
        }
    }
    [_delegate SelectedButtonIndex:sender.tag];
}


- (void)refreshButtonTag:(int)buttonTag
{
    UIButton *btnnnn = (UIButton *)[self viewWithTag:buttonTag];
    [self btnPressed:btnnnn];
}



@end

