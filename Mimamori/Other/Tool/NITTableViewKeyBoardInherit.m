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
@property (nonatomic, strong) UITextView *editTextView;

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
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - 键盘躲避
- (void)showKeyboard:(NSNotification *)noti
{
    CGRect keyBoardRect=[noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height - 49, 0);
}

- (void)hideKeyboard:(NSNotification *)noti
{          
    self.transform = CGAffineTransformIdentity;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
