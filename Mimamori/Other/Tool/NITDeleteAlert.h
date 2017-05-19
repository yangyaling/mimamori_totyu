//
//  NITDeleteAlert.h
//  Mimamori2
//
//  Created by totyu2 on 2017/5/18.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NITDeleteAlert : NSObject


+(void)SharedAlertShowMessage:(NSString *)message andControl:(id)control withOk:(void (^)(BOOL isOk))isok;


@end
