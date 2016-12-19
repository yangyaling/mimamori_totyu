//
//  NITMPButton.m
//  Mimamori
//
//  Created by totyu3 on 16/6/12.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "NITMPButton.h"

@implementation NITMPButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addTarget:self action:@selector(TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        
        [self addTarget:self action:@selector(TouchDown) forControlEvents:UIControlEventTouchDown];
        
        [self addTarget:self action:@selector(TouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    }
    return self;
}

-(void)TouchUpInside
{
    [UIView animateWithDuration:0.1 animations:^{

        self.transform = CGAffineTransformMakeScale(1.0, 1.0);

    }];
}

-(void)TouchDown
{
    [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        self.transform = CGAffineTransformMakeScale(2.0, 2.0);
        
    } completion:nil];
}

-(void)TouchUpOutside
{
    [UIView animateWithDuration:0.1 animations:^{
        
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    }];
}


@end
