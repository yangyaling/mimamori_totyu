//
//  MCustAddParam.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/1.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MHttpTool.h"

@interface MCustAddParam : NSObject


/**
 使用者ID（見守る人）
 */
@property (nonatomic, copy) NSString                               *userid1;
/**
 入居者ID（見守られる人）
 */
@property (nonatomic, copy) NSString                               *userid0;



/**
 ニックネーム（見守る人）
 */
@property (nonatomic, copy) NSString                               *nickname;



/**
  居室番号
 */
@property (nonatomic, copy) NSString                               *roomid;



/**
 更新日付
 */
@property (nonatomic, copy) NSString                               *updatedate;

@end
