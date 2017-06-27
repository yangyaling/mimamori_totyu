//
//  MLoginParam.h
//  Mimamori
//
//  Created by NISSAY IT on 16/10/31.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
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
