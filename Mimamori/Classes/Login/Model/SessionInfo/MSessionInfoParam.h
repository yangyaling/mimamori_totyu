//
//  MSessionInfoParam.h
//  Mimamori
//
//  Created by NISSAY IT on 16/10/31.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
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
