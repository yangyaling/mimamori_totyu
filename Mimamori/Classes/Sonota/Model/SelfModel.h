//
//  SelfModel.h
//  Mimamori
//
//  Created by totyu3 on 16/6/17.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelfModel : NSObject
/**
 *  userid1
 */
@property (nonatomic, copy) NSString                         *userid1;
/**
 *  groupid
 */
@property (nonatomic, copy) NSString                         *groupid;
/**
 *  usertype
 */
@property (nonatomic, copy) NSString                         *usertype;
/**
 *  username
 */
@property (nonatomic, copy) NSString                         *username;
/**
 *  nickname
 */
@property (nonatomic, copy) NSString                         *nickname;
/**
 *  email
 */
@property (nonatomic, copy) NSString                         *email;
/**
 *  uptatedate
 */
@property (nonatomic, copy) NSString                         *uptatedate;
@end
