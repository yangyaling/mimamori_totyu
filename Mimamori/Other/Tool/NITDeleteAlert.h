//
//  NITDeleteAlert.h
//  Mimamori2
//
//  Created by NISSAY IT on 2017/5/18.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NITDeleteAlert : NSObject


+(void)SharedAlertShowMessage:(NSString *)message andControl:(id)control withOk:(void (^)(BOOL isOk))isok;


@end
