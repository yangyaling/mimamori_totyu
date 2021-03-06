//
//  NotificationModel.h
//  Mimamori
//
//  Created by NISSAY IT on 2016/06/07.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//  通知モデル

#import <Foundation/Foundation.h>

@interface NotificationModel : NSObject


/**
 記入日
 */
@property (nonatomic, strong) NSString                       *registdate;

/**
 通知ID
 */
@property (nonatomic, assign) NSInteger                       noticeid;

/**
 使用者ID（見守る人）
 */
@property (nonatomic, copy) NSString                         *userid1;


/**
 ユーザー名
 */
@property (nonatomic, copy) NSString                         *username;


/**
 タイトル
 */
@property (nonatomic, copy) NSString                         *title;


/**
 スタッフID（見守る人）
 */
@property (nonatomic, copy) NSString                         *staffid;


/**
 補助タイトル
 */
@property (nonatomic, copy) NSString                         *subtitle;



/**
 タイプ
 */
@property (nonatomic, assign) NSInteger                       type;

/**
 ステータス
 */
@property (nonatomic, assign) NSInteger                       status;


/**
 通知元
 */
@property (nonatomic, copy) NSString                         *staupduser;

/**
 内容
 */
@property (nonatomic, copy) NSString                         *content;

@end

