//
//  MLoginResult.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/10/31.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLoginResult : NSObject

@property (nonatomic, copy) NSString                               *code;

@property (nonatomic, copy) NSString                               *username;

@property (nonatomic, copy) NSString                               *groupid;

@property (nonatomic, copy) NSString                               *email;

@property (nonatomic, copy) NSString                               *password;

@property (nonatomic, copy) NSString                               *usertype;

@end
