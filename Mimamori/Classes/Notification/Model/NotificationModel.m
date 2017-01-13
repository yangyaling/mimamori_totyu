//
//  NotificationModel.m
//  Mimamori
//
//  Created by totyu2 on 2016/06/07.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "NotificationModel.h"


@implementation NotificationModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"groupid" : @"id",
             @"groupname" : @"name"
             };
}


@end
