//
//  LifeUserListModel.h
//  Mimamori
//
//  Created by totyu3 on 16/6/13.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LifeUserListModel : NSObject
/**
 *  picpath
 */
@property (nonatomic, copy) NSString                         *picpath;
/**
 *  userid0
 */
@property (nonatomic, copy) NSString                         *userid0;
/**
 *  user0name
 */
@property (nonatomic, copy) NSString                         *user0name;
/**
 *  dispname
 */
@property (nonatomic, copy) NSString                         *dispname;
/**
 *  resultname
 */
@property (nonatomic, copy) NSString                         *resultname;
/**
 *  roomid
 */
@property (nonatomic, copy) NSString                         *roomid;
/**
 *  roomname
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
