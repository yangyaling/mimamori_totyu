//
//  MLoginParam.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/10/31.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLoginParam : NSObject

/**
 *  ユーザID
 */
@property (nonatomic, copy) NSString *userid;
/**
 *  パスワード
 */
@property (nonatomic, copy) NSString *password;

@end
