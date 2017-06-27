//
//  DeviceValue.h
//  Mimamori
//
//  Created by NISSAY IT on 16/9/15.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceValue : NSObject

/**
 時間の設定値
 */
@property (nonatomic, assign) NSNumber *time;

/**
 設定値
 */
@property (nonatomic, assign) NSNumber *value;

/**
 種別
 */
@property (nonatomic, copy) NSString *rpoint;

@end
