//
//  Device.h
//  Mimamori
//
//  Created by NISSAY IT on 16/9/14.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceValue.h"

@interface Device : NSObject

/**
 デバイスID
 */
@property (nonatomic, copy) NSString *deviceid;

/**
 デバイス名
 */
@property (nonatomic, copy) NSString *devicename;

/**
 指定デバイスタイプ
 */
@property (nonatomic, copy) NSString *devicetype;


/**
 ノード名
 */
@property (nonatomic, copy) NSString *nodename;


/**
 ノードID
 */
@property (nonatomic, copy) NSString *nodeid;

/**
 設置情報1
 */
@property (nonatomic, copy) NSString *displayname;

/**
 設置情報3
 */
@property (nonatomic, copy) NSString *memo;

/**
 メインノードID
 */
@property (nonatomic, copy) NSString *mainnodeid;

/**
 設置情報2
 */
@property (nonatomic, copy) NSString *place;


/**
 model datas
 */
@property (nonatomic, copy) NSArray           *modelArr;


/**
 *  h 単位
 */
@property (nonatomic, copy) NSString          *timeunit;


/**
 *  ℃・%　等
 */
@property (nonatomic, copy) NSString *valueunit;


/**
 *  1:使用なし　2:反応なし  3:以上・以下
 */
@property (nonatomic, assign) int       pattern;



@property (nonatomic, strong) DeviceValue      *deviceValue;


@end
