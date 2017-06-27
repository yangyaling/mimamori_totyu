//
//  NoticeTimeModel.h
//  Mimamori
//
//  Created by NISSAY IT on 2016/06/30.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeTimeModel : NSObject

/**
 日付
 */
@property (nonatomic, copy) NSString                    *date;

/**
 タイムゾーン
 */
@property (nonatomic, copy) NSString                    *timezone;


/**
 タイムゾーンのタイプ
 */
@property (nonatomic, copy) NSString                    *timezone_type;

@end
