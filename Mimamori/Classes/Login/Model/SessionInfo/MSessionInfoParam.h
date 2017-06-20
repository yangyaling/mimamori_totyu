//
//  MSessionInfoParam.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/10/31.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSessionInfoParam : NSObject



/**
 email
 */
@property (nonatomic, copy) NSString                               *email;



/**
 スタッフID（見守る人）
 */
@property (nonatomic, copy) NSString                               *staffid;




/**
 ホストコード
 */
@property (nonatomic, copy) NSString                               *hostcd;

@end
