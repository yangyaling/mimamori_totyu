//
//  MScenarioListParam.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/1.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MScenarioListParam : NSObject
/**
 スタッフID（見守る人）
 */
@property (nonatomic, copy) NSString                               *staffid;
/**
 入居者ID（見守られる人）
 */
@property (nonatomic, copy) NSString                               *custid;

/**
 場所
 */
@property (nonatomic, copy) NSString                               *place;

/**
 施設コード
 */
@property (nonatomic, copy) NSString                               *facilitycd;

/**
 メインノードID
 */
@property (nonatomic, copy) NSString                               *mainnodeid;

/**
 メインノード名
 */
@property (nonatomic, copy) NSString                               *mainnodename;

/**
 居室階
 */
@property (nonatomic, copy) NSString                               *floorno;

@end
