//
//  NotificationModel.h
//  Mimamori
//
//  Created by totyu2 on 2016/06/07.
//  Copyright © 2016年 totyu3. All rights reserved.
//  通知モデル

#import <Foundation/Foundation.h>

@interface NotificationModel : NSObject


@property (nonatomic, strong) NSString                       *registdate;

@property (nonatomic, assign) NSInteger                       noticeid;

@property (nonatomic, assign) NSInteger                       userid1;

@property (nonatomic, assign) NSString                       *groupid;


@property (nonatomic, copy) NSString                         *username;

@property (nonatomic, copy) NSString                         *groupname;

@property (nonatomic, copy) NSString                         *title;



@property (nonatomic, assign) NSInteger                       type;

@property (nonatomic, assign) NSInteger                       status;


@property (nonatomic, copy) NSString                         *staupduser;

@property (nonatomic, copy) NSString                         *content;

@end

