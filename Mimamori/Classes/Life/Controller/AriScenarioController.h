//
//  AriScenarioController.h
//  Mimamori2
//
//  Created by totyu2 on 2017/1/13.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AriScenarioController : UIViewController


@property (nonatomic, copy) NSString                 *viewTitle;

/**
 usernumber
 */
@property (nonatomic, copy) NSString                 *usernumber;

/**
 type
 */
@property (nonatomic, assign) NSInteger                type;


/**
 username
 */
@property (nonatomic, copy) NSString                 *username;

/**
 subtitle
 */
@property (nonatomic, copy) NSString                 *subtitle;

//

/**
  PushOrPop
 */
@property (nonatomic, assign) BOOL                    isPushOrPop;

@end
