//
//  MSessionInfoResult.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/10/31.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 $zsessioninfo[$index] = array(
 'email' => $row[0],
 'password' => $row[1],
 'sessionid' => $row[2],
 'updatetime' => $row[3],
 'sessionstatus' => $row[4],
 'devices' => $devices
 );
 */

@interface MSessionInfoResult : NSObject

@property (nonatomic, copy) NSString                               *email;

@property (nonatomic, copy) NSString                               *password;

@property (nonatomic, copy) NSString                               *sessionid;

@property (nonatomic, copy) NSString                               *updatetime;

@property (nonatomic, copy) NSString                               *sessionstatus;

@property(nonatomic, strong) NSArray                               *devices;

@end
