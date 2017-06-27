//
//  MSessionInfoResult.h
//  Mimamori
//
//  Created by NISSAY IT on 16/10/31.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 */

@interface MSessionInfoResult : NSObject

/**
 email
 */
@property (nonatomic, copy) NSString                               *email;


/**
 パスワード
 */
@property (nonatomic, copy) NSString                               *password;


/**
 セッションID
 */
@property (nonatomic, copy) NSString                               *sessionid;


/**
 更新時間
 */
@property (nonatomic, copy) NSString                               *updatetime;

/**
 セッションステータス
 */
@property (nonatomic, copy) NSString                               *sessionstatus;

/**
 デバイス
 */
@property(nonatomic, strong) NSArray                               *devices;

@end
