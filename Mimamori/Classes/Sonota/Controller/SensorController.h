//
//  SensorController.h
//  Mimamori
//
//  Created by NISSAY IT on 2016/12/14.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SickPersonModel;

@interface SensorController : UIViewController
/**
 入居者ID（見守られる人）
 */
@property (nonatomic, copy) NSString                   *profileUser0;
/**
 入居者名（見守られる人）
 */
@property (nonatomic, copy) NSString                   *profileUser0name;
/**
 居室ID
 */
@property (nonatomic, copy) NSString                   *roomID;

/**
 クラスのタイトル名
 */
@property (nonatomic, copy) NSString                   *titleStr;

/**
 居室階
 */
@property (nonatomic, copy) NSString                   *floorno;

@end
