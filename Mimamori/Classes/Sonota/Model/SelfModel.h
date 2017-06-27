//
//  SelfModel.h
//  Mimamori
//
//  Created by NISSAY IT on 16/6/17.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelfModel : NSObject

/**
 使用者ID（見守る人）
 */
@property (nonatomic, copy) NSString                         *userid1;

/**
 使用者 種別
 */
@property (nonatomic, copy) NSString                         *usertype;

/**
 ユーザ名
 */
@property (nonatomic, copy) NSString                         *username;


/**
 ニックネーム（見守る人）
 */
@property (nonatomic, copy) NSString                         *nickname;

/**
 email
 */
@property (nonatomic, copy) NSString                         *email;


/**
  更新日付
 */
@property (nonatomic, copy) NSString                         *uptatedate;
@end
