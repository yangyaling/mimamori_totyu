//
//  MNoticeInfoParam.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/1.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNoticeInfoParam : NSObject


/**
 スタッフID（見守る人）
 */
@property (nonatomic, copy) NSString                               *staffid;


/**
 入居者ID（見守られる人）
 */
@property (nonatomic, copy) NSString                               *custid;



/**
 開始時間
 */
@property (nonatomic, copy) NSString                               *startdate;



/**
 選択時間
 */
@property (nonatomic, copy) NSString                               *selectdate;



/**
 履歴フラグ
 */
@property (nonatomic, copy) NSString                               *historyflg;



/**
 通知の種類
 */
@property (nonatomic, copy) NSString                               *noticetype;



/**
 施設コード
 */
@property (nonatomic, copy) NSString                               *facilitycd;

@end
