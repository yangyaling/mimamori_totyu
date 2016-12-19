//
//  ProfileModel.h
//  Mimamori
//
//  Created by totyu3 on 16/6/17.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileModel : NSObject
/**
 *  user0name
 */
@property (nonatomic, copy) NSString                         *user0name;
/**
 *  sex
 */
@property (nonatomic, copy) NSString                         *sex;
/**
 *  birthday
 */
@property (nonatomic, copy) NSString                         *birthday;
/**
 *  address
 */
@property (nonatomic, copy) NSString                         *address;
/**
 *  kakaritsuke
 */
@property (nonatomic, copy) NSString                         *kakaritsuke;
/**
 *  drug
 */
@property (nonatomic, copy) NSString                         *drug;
/**
 *  health
 */
@property (nonatomic, copy) NSString                         *health;
/**
 *  other
 */
@property (nonatomic, copy) NSString                         *other;
/**
 *  updatedate
 */
@property (nonatomic, copy) NSMutableDictionary               *updatedate;
@property (nonatomic, copy) NSString                          *date;
/**
 *  updatename
 */
@property (nonatomic, copy) NSString                         *updatename;

@end
