//
//  ProfileTableViewController.h
//  Mimamori
//
//  Created by totyu3 on 16/6/6.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProfileModel.h"

@interface ProfileTableViewController : UITableViewController
/**
 入居者ID（見守られる人）
 */
@property NSString *userid0;

@property (nonatomic, copy) NSString                      *titleStr;

@property (nonatomic, strong) ProfileModel                *pmodel;

@end
