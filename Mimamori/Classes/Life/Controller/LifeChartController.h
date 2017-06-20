//
//  LifeChartController.h
//  Mimamori
//
//  Created by totyu2 on 2016/12/15.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeChartController : UIViewController

@property NSString *userid0;

@property (nonatomic, copy) NSString                      *viewTitle;

/**
 *  ユーザネーム
 */
@property NSString * username;


/**
 *  居室番号
 */
@property (nonatomic, copy) NSString *roomID;


/**
 *  異常  result
 */
@property (nonatomic, copy) NSString *ariresult;

/**
 *  画像path
 */
@property (nonatomic, copy) NSString *picpath;



@end
