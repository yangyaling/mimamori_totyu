//
//  MProfileInfoUpdateParam.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/1.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MProfileInfoUpdateParam : NSObject
/**
 画像url
 */
@property (nonatomic, copy) NSString                               *imageurl;
/**
 スタッフID（見守る人）
 */
@property (nonatomic, copy) NSString                               *staffid;
/**
 入居者ID（見守られる人）
 */
@property (nonatomic, copy) NSString                               *custid;
/**
 入居者名（見守られる人）
 */
@property (nonatomic, copy) NSString                               *user0name;
/**
 *  性别
 */
@property (nonatomic, copy) NSString                               *sex;
/**
 居室階
 *
 */
@property (nonatomic, copy) NSString                               *floorno;
/**
 *  居室番号
 */
@property (nonatomic, copy) NSString                               *roomcd;
/**
 *  誕生日
 */
@property (nonatomic, copy) NSString                               *birthday;

/**
 かかりつけ医
 */
@property (nonatomic, copy) NSString                               *kakaritsuke;
/**
 服薬情報
 */
@property (nonatomic, copy) NSString                               *drug;
/**
 *健康診断結果
 */
@property (nonatomic, copy) NSString                               *health;
/**
 その他お願い事項
 */
@property (nonatomic, copy) NSString                               *other;
/**
 *  更新日付
 */
@property (nonatomic, copy) NSString                               *updatedate;
/**
 *  更新者
 */
@property (nonatomic, copy) NSString                               *updatename;



@end
