//
//  PatientDetailsTableViewController.h
//  Mimamori
//
//  Created by totyu3 on 16/6/3.
//  Copyright © 2016年 totyu3. All rights reserved.
//  プロフィールとシナリオ表示画面

#import <UIKit/UIKit.h>
@class SickPersonModel;

@interface PatientDetailsTableViewController : UITableViewController

@property (nonatomic, strong) SickPersonModel *person;


@end
