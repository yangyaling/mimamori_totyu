//
//  WHUCalendarPopView.m
//  TEST_Calendar
//
//  Created by NISSAY IT on 15/11/7.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import "WHUCalendarPopView.h"
#import "WHUCalendarView.h"
#import "WHUCalendarMarcro.h"
@interface WHUCalendarPopView()
@property(nonatomic,strong) UIButton* backBtn;
@property(nonatomic,strong) WHUCalendarView* calView;
@property(nonatomic,assign) CGFloat calHeight;
@end

@implementation WHUCalendarPopView

- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array{
    CGRect screenBounds= frame;
    
    self=[super initWithFrame:screenBounds];
    if(self){
        
        self.backgroundColor = NITColorAlpha(116, 116, 116, 0);
        
        _calView=[[WHUCalendarView alloc] initWithFrame:screenBounds withArray:array];
        
        _calView.translatesAutoresizingMaskIntoConstraints=NO;
        
        _backBtn=[UIButton  buttonWithType:UIButtonTypeCustom];
        
        _backBtn.frame = screenBounds;
        
        [_backBtn addTarget:self action:@selector(hideCalendar) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backBtn];
        
        _backBtn.backgroundColor=[UIColor clearColor];
        
        CGSize s=[_calView sizeThatFits:CGSizeMake(screenBounds.size.width, FLT_MAX)];
        
        _calHeight=s.height;
        
        [self addSubview:_calView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_calView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:1]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_calView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_calView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:s.height + 10]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_calView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self setHidden:YES];
        
        WHUCalendarView_WeakSelf weakself=self;
        _calView.onDateSelectBlk=^(NSDate* date){
            WHUCalendarView_StrongSelf self=weakself;
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [self dismiss];
            });
        };
    }
    return self;

}

-(void)setOnDateSelectBlk:(void (^)(NSDate *))onDateSelectBlk{
    _onDateSelectBlk=onDateSelectBlk;
    
    WHUCalendarView_WeakSelf weakself=self;
    
    if(onDateSelectBlk!=nil){
        
        WHUCalendarView_StrongSelf self=weakself;
        
        self->_calView.onDateSelectBlk=^(NSDate* date){
            
            WHUCalendarView_StrongSelf self=weakself;
            
            onDateSelectBlk(date);
            
            [self dismiss];
        };
    }
}


-(void)show{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.hidden=NO;
    [UIView animateWithDuration:0.6 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:nil];
    
}


-(void)dismiss{
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL b){
        self.hidden=YES;
    }];
}

- (void)hideCalendar
{
    if ([self.calendarDelegate respondsToSelector:@selector(GetCurrentCanlendarStatus:)]) {
        [self.calendarDelegate GetCurrentCanlendarStatus:NO];
    }
    [self dismiss];
}
@end
