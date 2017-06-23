//
//  MLoginResult.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/10/31.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLoginResult : NSObject

/**
 コード
 */
@property (nonatomic, copy) NSString                               *code;


/**
 スタッフ名（見守る人）
 */
@property (nonatomic, copy) NSString                               *staffname;


/**
 email
 */
@property (nonatomic, copy) NSString                               *email;


/**
 パスワード
 */
@property (nonatomic, copy) NSString                               *password;


/**
 ユーザー・タイプ
 */
@property (nonatomic, copy) NSString                               *usertype;

@end
