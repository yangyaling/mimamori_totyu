//
//  NoticeTimeModel.m
//  Mimamori
//
//  Created by totyu2 on 2016/06/30.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "NoticeTimeModel.h"

@implementation NoticeTimeModel

-(void)setDate:(NSString *)date
{
    NSString *tempdate = date;
    NSString *newdate = [tempdate substringToIndex:19];
    _date = newdate;
}

@end
