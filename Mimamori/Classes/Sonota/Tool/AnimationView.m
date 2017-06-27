//
//  AnimationView.m
//  继承view动画
//
//  Created by NISSAY IT on 2017/5/26.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import "AnimationView.h"

@implementation AnimationView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}



-(void)StartAnimationXLayoutConstraint:(NSLayoutConstraint *)constraint {
    
    [self animationAction:YES andLayoutConstraint:constraint];
    
}

-(void)FinishAnimationZoneLayoutConstraint:(NSLayoutConstraint *)constraint {
    
    [self animationAction:NO andLayoutConstraint:constraint];
    
}



/**
 右移動アニメーション
 */
- (void)animationAction:(BOOL)isOp andLayoutConstraint:(NSLayoutConstraint *)constraint {
    
    if (isOp) {
        
        constraint.constant = 45;
        
    } else {
        
        constraint.constant = 5;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
