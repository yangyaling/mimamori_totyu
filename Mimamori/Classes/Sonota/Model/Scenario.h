//
//  Scenario.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/9/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scenario : NSObject

@property (nonatomic, copy) NSString *scenarioid;

@property (nonatomic, copy) NSString *scenarioname;

@property (nonatomic, copy) NSString *updatedate;

@property (nonatomic, assign) NSInteger scopecd;

@property (nonatomic, copy) NSString *starttime;

@property (nonatomic, copy) NSString *endtime;

@end
