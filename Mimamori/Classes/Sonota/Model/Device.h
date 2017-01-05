//
//  Device.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/9/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceValue.h"

@interface Device : NSObject

@property (nonatomic, copy) NSString *deviceid;

@property (nonatomic, copy) NSString *devicename;

@property (nonatomic, copy) NSString *devicetype;

@property (nonatomic, copy) NSString *nodename;

@property (nonatomic, copy) NSString *nodeid;

@property (nonatomic, copy) NSString *displayname;

@property (nonatomic, copy) NSString *place;

/**
 *  h
 */
@property (nonatomic, copy) NSString *timeunit;
/**
 *  ℃・%　等
 */
@property (nonatomic, copy) NSString *valueunit;
/**
 *  1:使用なし　2:反応なし  3:以上・以下
 */
@property (nonatomic, assign) int       pattern;

@property (nonatomic, strong) DeviceValue *deviceValue;

@end
