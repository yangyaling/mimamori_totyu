//
//  RecordingStatus.m
//  音声認識test
//
//  Created by totyu3 on 16/12/12.
//  Copyright © 2016年 LGF. All rights reserved.
//

#define SuperView [UIApplication sharedApplication].windows.lastObject.rootViewController.view


#import "RecordingStatus.h"
@interface RecordingStatus()
@property(strong , nonatomic) UIView *rectSuperView;
@property(strong , nonatomic) UIView *cover;
@property(strong , nonatomic) UILabel *titleLabel;
/**
 *  小方块个数
 */
@property(readwrite , nonatomic) NSUInteger numberOfRect;

/**
 *  小方块背景色
 */
@property(strong , nonatomic) UIColor* rectBackgroundColor;

/**
 *  self.frame.size
 */
@property(readwrite , nonatomic) CGSize defaultSize;

/**
 *  小方块之间的间距
 */
@property(readwrite , nonatomic) CGFloat spacing;
@end
@implementation RecordingStatus

+(RecordingStatus *)Status{
    static RecordingStatus*Status = nil;
    
    if (!Status) {
        Status = [[RecordingStatus alloc]init];
        Status.layer.shadowColor = [UIColor blackColor].CGColor;
        Status.layer.shadowOffset = CGSizeMake(1,1);
        Status.layer.shadowOpacity = 0.3;
        Status.layer.shadowRadius = 2;
    }
    return Status;
}

- (void)commonInit{
    [self removeAll];
    
    [self setDefaultAttribute];
}


/**
 *   设置默认属性
 */
-(void)setDefaultAttribute
{
    _cover = [[UIView alloc] initWithFrame:CGRectMake(0, 64, NITScreenW, NITScreenH - 113)];
    _cover.backgroundColor = NITColorAlpha(222, 222, 222, 0.3);
    [SuperView addSubview:_cover];
    self.frame = CGRectMake(SuperView.bounds.size.width/4, SuperView.bounds.size.height/2-50, SuperView.bounds.size.width/2, 50);
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor whiteColor];
    self.numberOfRect =27;
    self.rectBackgroundColor= NITColor(252, 56, 98);
    _spacing = 2;
    _defaultSize = CGSizeMake(SuperView.frame.size.width/2, 20);
    
    
    [SuperView addSubview:self];
    [self addRect];
}

/**
 *  添加矩形
 */
-(void)addRect
{
    
    _rectSuperView = [[UIView alloc]initWithFrame:self.bounds];
    for (int i = 0; i < _numberOfRect; i++) {
        
        UIView* rectView = [[UIView alloc] initWithFrame:CGRectMake(i*(_defaultSize.width/_numberOfRect)+1 , (self.frame.size.height-_defaultSize.height)/2, _defaultSize.width/_numberOfRect-2, _defaultSize.height)];
        [rectView setBackgroundColor:_rectBackgroundColor];
        [rectView.layer addAnimation:[self addAnimateWithDelay:i*0.02] forKey:@"TBRotate"];
        [_rectSuperView addSubview:rectView];
    }
    [self addSubview:_rectSuperView];
}

/**
 *  移除矩形
 */
-(void)stopAnimate{
    
    [_rectSuperView removeFromSuperview];
    [self addTitle];
}
/**
 *  添加标题
 */
-(void)addTitle{
    
    _titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
    _titleLabel.text = @"解析中...";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = NITColor(252, 56, 98);
    _titleLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:20];
    [self addSubview:_titleLabel];
}

-(void)removeAll {
    [_titleLabel removeFromSuperview];
    [_rectSuperView removeFromSuperview];
    [_cover removeFromSuperview];
    [self removeFromSuperview];
}

-(void)hideRecordingStatus:(NSString *)showTitle{


    _titleLabel.text = showTitle;

    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self removeAll];
    });
}

-(CAAnimation*)addAnimateWithDelay:(CGFloat)delay
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = YES;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:M_PI];
    animation.duration = _numberOfRect * 0.02; //第一个翻转一周，最后一个开始翻转
    animation.beginTime = CACurrentMediaTime() + delay;
    
    return animation;
}


@end
