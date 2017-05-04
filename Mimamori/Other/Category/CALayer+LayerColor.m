//
//  CALayer+LayerColor.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "CALayer+LayerColor.h"
#import <objc/runtime.h>

@implementation CALayer (LayerColor)



//- (UIColor *)borderColorFromUIColor {
//    
//    return objc_getAssociatedObject(self, @selector(borderColorFromUIColor));
//    
//}

- (void)setBorderColorFromUIColor:(UIColor *)color {
    
     self.borderColor = color.CGColor;
    
}

@end
