//
//  ZworksChartModel.h
//  Mimamori
//
//  Created by totyu3 on 16/6/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZworksChartModel : NSObject<NSCoding>
/**
 *  picpath
 */
@property (nonatomic, copy) NSString                               *picpath;
/**
 *  Node Id
 */
@property (nonatomic, copy) NSString                               *nodeid;
/**
 *  デバイスID
 */
@property (nonatomic, copy) NSString                               *deviceid;
/**
 *  デバイスネーム
 */
@property (nonatomic, copy) NSString                               *devicename;

/**
 ノードネーム
 */
@property (nonatomic, copy) NSString                               *nodename;
/**
 *  単位
 */
@property (nonatomic, copy) NSString                               *deviceunit;
/**
 *  最後のレコード
 */
@property (nonatomic, copy) NSString                              *latestvalue;
/**
 *  デバイスネーム
 */
@property (nonatomic, strong) NSMutableArray                       *devicevalues;

/**
 *  バッテリーステータス 1:正常2:电量不足 3:没电 4:检索error
 */
@property (nonatomic, copy) NSString                               *batterystatus;



/**
 日付
 */
@property (nonatomic, copy) NSString                               *datestring;


/**
 設置情報1
 */
@property (nonatomic, copy) NSString                               *displayname;


@property (nonatomic, strong) NSArray                              *deviceinfo;


@end
