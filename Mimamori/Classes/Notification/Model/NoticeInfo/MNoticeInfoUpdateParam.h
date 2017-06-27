//
//  MNoticeInfoUpdateParam.h
//  Mimamori
//
//  Created by NISSAY IT on 16/11/1.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MNoticeInfoUpdateParam : NSObject

/**
 使用者ID（見守る人）
 */
@property (nonatomic, copy) NSString                               *userid1;


/**
 通知ID
 */
@property (nonatomic, copy) NSString                               *noticeid;

/**
 通知種別
 */
@property (nonatomic, copy) NSString                               *noticetype;

/**
 発生日
 */
@property (nonatomic, copy) NSString                               *registdate;

/**
 通知元
 */
@property (nonatomic, copy) NSString                               *staupduser;


@end
