//
//  PNChartLabel.m
//  PNChart
//
//  Created by NISSAY IT.
//  Copyright (c) 2014年 NISSAY IT.
//

#import "UUChartLabel.h"
#import "UUColor.h"

@implementation UUChartLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setLineBreakMode:NSLineBreakByWordWrapping];
        [self setMinimumScaleFactor:5.0f];
        [self setNumberOfLines:1];
        [self setFont:[UIFont boldSystemFontOfSize:7.0f]];
        [self setTextColor: UUWhite];
        self.backgroundColor = [UIColor clearColor];
        [self setTextAlignment:NSTextAlignmentCenter];
        self.userInteractionEnabled = YES;
    }
    return self;
}


@end
