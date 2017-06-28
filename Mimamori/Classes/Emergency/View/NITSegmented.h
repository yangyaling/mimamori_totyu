//
//  NITSegmented.h
//  timerTest
//
//  Created by NISSAY IT on 16/5/31.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NITSegmentedDelegate<NSObject>

-(void)SelectedButtonIndex:(CGFloat)index;

@end

@interface NITSegmented : UIView

@property (nonatomic,assign) id<NITSegmentedDelegate> delegate;



- (void)refreshButtonTag:(int)buttonTag;

@end

