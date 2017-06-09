//
//  NITTableViewKeyBoardInherit.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/12.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "NITTableViewKeyBoardInherit.h"

@interface NITTableViewKeyBoardInherit ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextField *editTextField;
@property (nonatomic, strong) UITextView  *editTextView;
@property (nonatomic, strong) UIButton    *bgBtn;

@end

@implementation NITTableViewKeyBoardInherit

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        [self  initviewDidLoad];
    }
    return self;
}



//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    
//    id view = [super hitTest:point withEvent:event];
//    
//    if (![view isKindOfClass:[UITextView class]]) {
//        [self endEditing:YES];
//    }
//    
//    return view;
//}



- (void)initviewDidLoad {
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgBtn setFrame:CGRectMake(0, 0, NITScreenW, NITScreenH)];
    [bgBtn setBackgroundColor:[UIColor clearColor]];
    [bgBtn addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchUpInside];
    _bgBtn = bgBtn;
    [WindowView addSubview:bgBtn];
    [_bgBtn setHidden:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - 键盘躲避
- (void)showKeyboard:(NSNotification *)noti
{
    [_bgBtn setHidden:NO];
    CGRect keyBoardRect=[noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height - 49, 0);
}

-(BOOL)textFieldShouldReturn:(UITextView *)textField{
    
    [self endEditing:YES];
    
    [textField resignFirstResponder];
    
    return YES;
}


- (void)hideKeyboard:(NSNotification *)noti
{
    [_bgBtn removeFromSuperview];
    self.transform = CGAffineTransformIdentity;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
