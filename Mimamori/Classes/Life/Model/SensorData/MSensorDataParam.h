//
//  MSensorDataParam.h
//  Mimamori
//
//  Created by NISSAY IT on 16/11/2.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSensorDataParam : NSObject


/**
 今の時間
 */
@property (nonatomic, copy) NSString                               *nowdate;
/**
 スタッフID（見守る人）
 */
@property (nonatomic, copy) NSString                               *staffid;
/**
 入居者ID（見守られる人）
 */
@property (nonatomic, copy) NSString                               *custid;

/**
 デバイスクラス
 */
@property (nonatomic, copy) NSString                               *deviceclass;


/**
 ノードID
 */
@property (nonatomic, copy) NSString                               *nodeid;

@end
