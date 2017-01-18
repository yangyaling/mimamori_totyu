//
//  RecordingStatus.h
//  音声認識test
//
//  Created by totyu3 on 16/12/12.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordingStatus : UIView
+(RecordingStatus *)Status;
- (void)commonInit;
- (void)stopAnimate;
-(void)hideRecordingStatus:(NSString *)showTitle;

@end
