//
//  NITDeleteAlert.m
//  Mimamori2
//
//  Created by NISSAY IT on 2017/5/18.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import "NITDeleteAlert.h"

@implementation NITDeleteAlert



/**
 警报ビュー
 */
+(void)SharedAlertShowMessage:(NSString *)message andControl:(id)control withOk:(void (^)(BOOL isOk))isok {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"はい" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        isok(YES);
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"いいえ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NITLog(@"alert取消了");
    }];
    
    //デザインとフォントの色
    
    [cancel setValue:OtherEnabledCellBGColor forKey:@"_titleTextColor"];
    [okAction setValue:[UIColor grayColor] forKey:@"_titleTextColor"];
    
    [alert addAction:cancel];
    
    [alert addAction:okAction];
    [control presentViewController:alert animated:YES completion:nil];
    
}

@end
