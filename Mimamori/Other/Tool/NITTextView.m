//
//  NITTextView.m
//  Mimamori
//
//  Created by NISSAY IT on 16/6/6.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "NITTextView.h"

@implementation NITTextView



/**
set CornerRadius
 */
-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0?true:false;
}



/**
 set Border Width
 */
-(void)setBorderWidth:(CGFloat)borderWidth{
    
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = borderWidth > 0?true:false;
}



/**
 set Border Color

 */
-(void)setBorderColor:(UIColor *)borderColor{
    
    self.layer.borderColor = borderColor.CGColor;
}

@end
