//
//  Scenario.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/9/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scenario : NSObject

/**
 シナリオID
 */
@property (nonatomic, copy) NSString *scenarioid;

/**
 シナリオネーム
 */
@property (nonatomic, copy) NSString *scenarioname;


/**
 更新時間
 */
@property (nonatomic, copy) NSString *updatedate;

/**
 スコープ
 */
@property (nonatomic, assign) NSInteger scopecd;

/**
 有効開始日
 */
@property (nonatomic, copy) NSString *starttime;

/**
 有効終了日
 */
@property (nonatomic, copy) NSString *endtime;

@end
