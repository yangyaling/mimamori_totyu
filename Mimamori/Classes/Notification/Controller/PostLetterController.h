//
//  PostLetterController.h
//  Mimamori
//
//  Created by totyu2 on 2016/06/06.
//  Copyright © 2016年 totyu3. All rights reserved.
//  お知らせ作成

#import <UIKit/UIKit.h>

@interface PostLetterController : UITableViewController

@property (nonatomic, assign) BOOL                              isDetailView;

@property (nonatomic, strong) NSString                         *titleS;

@property (nonatomic, strong) NSString                         *contentS;

@property (nonatomic, strong) NSString                         *groupName;

@property (nonatomic, assign) NSInteger                         groupid;//当前是分组id

@end
