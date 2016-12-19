//
//  NITTextView.h
//  Mimamori
//
//  Created by totyu3 on 16/6/6.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface NITTextView : UITextView

@property (nonatomic) IBInspectable CGFloat cornerRadius;

@property (nonatomic) IBInspectable CGFloat borderWidth;

@property (nonatomic) IBInspectable UIColor *borderColor;

@end
