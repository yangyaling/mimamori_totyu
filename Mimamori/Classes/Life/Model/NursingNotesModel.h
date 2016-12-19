//
//  NursingNotesModel.h
//  Mimamori
//
//  Created by totyu3 on 16/6/8.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NursingNotesModel : NSObject
/**
 *  介护记录日期
 */
@property (nonatomic, copy) NSString                         *memodate;
/**
 *  介护记录时间
 */
@property (nonatomic, copy) NSString                         *memotime;
/**
 *  介护记录id
 */
@property (nonatomic, copy) NSString                         *memoid;
/**
 *  介护记录添加人
 */
@property (nonatomic, copy) NSString                         *user1name;
/**
 *  介护记录添加人id
 */
@property (nonatomic, copy) NSString                         *userid1;
/**
 *  介护记录内容
 */
@property (nonatomic, copy) NSString                         *content;

@end
