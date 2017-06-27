//
//  IconModel.h
//  Mimamori2
//
//  Created by NISSAY IT on 2016/12/30.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconModel : NSObject

/**
 入居者ID（見守られる人）
 */
@property (nonatomic, copy) NSString                         *custid;
/**
 更新日付
 */
@property (nonatomic, copy) NSString                         *updatedate;
/**
 画像データ
 */
@property (nonatomic, copy) NSString                           *picdata;

@end
