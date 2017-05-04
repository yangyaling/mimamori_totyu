//
//  MLoginParam.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/10/31.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLoginParam : NSObject
/*
   ホストコード
*/
@property (nonatomic, copy) NSString *hostcd;
/**
 *  ユーザID
 */
@property (nonatomic, copy) NSString *staffid;
/**
 *  パスワード
 */
@property (nonatomic, copy) NSString *password;

@end
