//
//  LifeUserListModel.h
//  Mimamori
//
//  Created by NISSAY IT on 16/6/13.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LifeUserListModel : NSObject
/**
画像Path
 */
@property (nonatomic, copy) NSString                         *picpath;
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
 *  result name
 */
@property (nonatomic, copy) NSString                         *resultname;
/**
 居室ID
 */
@property (nonatomic, copy) NSString                         *roomid;
/**
居室番号
 */
@property (nonatomic, copy) NSString                         *roomcd;
/**
 *  温度
 */
@property (nonatomic, copy) NSString                         *tvalue;
/**
 *  温度単位
 */
@property (nonatomic, copy) NSString                         *tunit;
/**
 *  湿度
 */
@property (nonatomic, copy) NSString                         *hvalue;
/**
 *  湿度単位
 */
@property (nonatomic, copy) NSString                         *hunit;
/**
 *  明るさ
 */
@property (nonatomic, copy) NSString                         *bvalue;
/**
 *  明るさ単位
 */
@property (nonatomic, copy) NSString                         *bunit;
/**
 *  明るさ（明・暗）
 */
@property (nonatomic, copy) NSString                         *bd;
/**
 *  image
 */
@property (nonatomic, copy) NSString                         *image;


@end
