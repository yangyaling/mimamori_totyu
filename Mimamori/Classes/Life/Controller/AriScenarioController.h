//
//  AriScenarioController.h
//  Mimamori2
//
//  Created by NISSAY IT on 2017/1/13.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AriScenarioController : UIViewController

/**
   ユーザID
 */
@property (nonatomic, copy) NSString                 *usernumber;

/**
タイプ
 */
@property (nonatomic, assign) NSInteger                type;


/**
 ユーザー名
 */
@property (nonatomic, copy) NSString                 *username;

/**
補助タイトル
 */
@property (nonatomic, copy) NSString                 *subtitle;

//

/**
  Push Or Pop
 */
@property (nonatomic, assign) BOOL                    isPushOrPop;

@end
