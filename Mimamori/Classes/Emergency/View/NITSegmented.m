//
//  NITSegmented.m
//  timerTest
//
//  Created by NISSAY IT on 16/5/31.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "NITSegmented.h"

@interface NITSegmented()

@property (nonatomic,strong) NSMutableArray             *arrButtons;

@property (assign          ) float                       btnWidth;

@property (assign          ) float                       btnHeight;

@property (nonatomic,strong) UIColor *selectedTitleColor;
@property (nonatomic,strong) UIColor *defaultTitleColor;

@property (nonatomic,strong) UIColor *selectedBackgroundColor;
@property (nonatomic,strong) UIColor *defaultBackgroundColor;

@end

@implementation NITSegmented


#pragma mark - 
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    _arrButtons = [NSMutableArray new];
    
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _btnWidth = (CGRectGetWidth(self.frame)-3)/3;
        
        _btnHeight = (CGRectGetHeight(self.frame)-13)/2;
        
        _defaultBackgroundColor =  NITColor(211, 211, 211);
        
        _selectedBackgroundColor = NITColor(252, 85, 115);
        
        _selectedTitleColor = [UIColor whiteColor];
        
        _defaultTitleColor = [UIColor blackColor];
        
        

        for (int i = 0; i< 5; i++)
        {
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(_btnWidth*i, 1, _btnWidth, _btnHeight)];
            
            btn.backgroundColor = _defaultBackgroundColor;
            
         
            btn.tag = i;

         
            [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            NSString *title = [NSString stringWithFormat:@"%dF",i+1];

  
            [btn setTitle:title forState:UIControlStateNormal];
            
            if (i== 0) {
                btn.selected = YES;
                btn.backgroundColor = _selectedBackgroundColor;
            }
            
            
            if (i > 2) {
                btn.x = (i-3)*_btnWidth;
                btn.y = _btnHeight + 13;
                
                NSString *title = [NSString stringWithFormat:@"%dF",i-2];
                
            
                [btn setTitle:title forState:UIControlStateNormal];
                
            }
            
            btn.layer.borderWidth = 0.5;
            
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            
//            NSLog(@"_btnWidth%f",btn.width);
            btn.showsTouchWhenHighlighted = YES;
            
            

            [btn setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
            
            

            [btn setTitleColor:_defaultTitleColor forState:UIControlStateNormal];
            

            [self addSubview:btn];
            
            [_arrButtons addObject:btn];
        }
    }
    return self;
}


#pragma mark -
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

