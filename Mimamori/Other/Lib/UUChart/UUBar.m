//
//  UUBar.m
//  UUChartDemo
//
//  Created by NISSAY IT.
//  Copyright (c) 2014年 NISSAY IT.
//

#import "UUBar.h"
#import "UUColor.h"

@implementation UUBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
		_chartLine = [CAShapeLayer layer];
        
		_chartLine.lineCap = kCALineCapSquare;
        
		_chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        
		_chartLine.lineWidth   = self.frame.size.width;
        
		_chartLine.strokeEnd   = 0.0;
        
		self.clipsToBounds = YES;
        
		[self.layer addSublayer:_chartLine];

    }
    return self;
}

-(void)setGrade:(float)grade
{
    if (isnan(grade))
    return;
    
    
    if (grade==0)
    return;
    
	_grade = grade;
	UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height+30)];
	[progressline addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1 - grade) * self.frame.size.height+3.5)];
	
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
	_chartLine.path = progressline.CGPath;
    

	if (_barColor) {
		_chartLine.strokeColor = [_barColor CGColor];
	}else{
        _chartLine.strokeColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:0.7f] CGColor];
	}
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _chartLine.strokeEnd = 2.0;
    
}

@end
