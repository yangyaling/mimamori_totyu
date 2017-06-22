//
//  ProfileModel.h
//  Mimamori
//
//  Created by totyu3 on 16/6/17.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileModel : NSObject
/**
 画像Path
 */
@property (nonatomic, copy) NSString                         *picpath;
/**
 *画像更新日
 */
@property (nonatomic, copy) NSString                         *picupdatedate;

/**
入居者名（見守られる人）
 */
@property (nonatomic, copy) NSString                         *user0name;
/**
 * 性別
 */
@property (nonatomic, copy) NSString                         *sex;
/**
居室階
 */
@property (nonatomic, copy) NSString                         *floorno;
/**
 * 居室番号
 */
@property (nonatomic, copy) NSString                         *roomcd;
/**
 *  誕生日
 */
@property (nonatomic, copy) NSString                         *birthday;
/**
 *住所
 */
@property (nonatomic, copy) NSString                         *address;
/**
かかりつけ医
 */
@property (nonatomic, copy) NSString                         *kakaritsuke;
/**
服薬情報
 */
@property (nonatomic, copy) NSString                         *drug;
/**
 *健康診断結果
 */
@property (nonatomic, copy) NSString                         *health;
/**
 その他お願い事項
 */
@property (nonatomic, copy) NSString                         *other;
/**
 *   更新日付
 */
@property (nonatomic, copy) NSString                         *updatedate;

/**
  日付
 */
@property (nonatomic, copy) NSString                          *date;
/**
 *   更新者
 */
@property (nonatomic, copy) NSString                         *updatename;

@end
