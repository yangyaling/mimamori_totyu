//
//  AnimationView.h
//  继承view动画
//
//  Created by NISSAY IT on 2017/5/26.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationView : UIView


/**
 マスター画面  アニメを編集する
 */

-(void)StartAnimationXLayoutConstraint:(NSLayoutConstraint *)constraint;

-(void)FinishAnimationZoneLayoutConstraint:(NSLayoutConstraint *)constraint;

@end
