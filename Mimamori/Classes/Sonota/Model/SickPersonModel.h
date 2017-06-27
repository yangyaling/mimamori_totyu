//
//  SickPersonModel.h
//  Mimamori
//
//  Created by NISSAY IT on 16/6/13.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SickPersonModel : NSObject
/**
 入居者ID（見守られる人）
 */
@property (nonatomic, copy) NSString                         *userid0;
/**
 入居者名（見守られる人）
 */
@property (nonatomic, copy) NSString                         *user0name;
/**
 *  設置情報1
 */
@property (nonatomic, copy) NSString                         *dispname;
/**
 居室ID
 */
@property (nonatomic, copy) NSString                         *roomid;
/**
 居室名
 */
@property (nonatomic, copy) NSString                         *roomname;

/**
 センサ・カウント
 */
@property (nonatomic, copy) NSString                         *sensorcount;

/**
 居室階
 */
@property (nonatomic, copy) NSString                         *floorno;




@end
