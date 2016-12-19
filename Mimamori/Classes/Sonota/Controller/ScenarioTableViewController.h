//
//  ScenarioTableViewController.h
//  Mimamori
//
//  Created by totyu3 on 16/6/6.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Scenario;
@protocol ScenarioVcDelegate <NSObject>

@optional
-(void)warningScenarioAdded:(NSString *)message;

@end

@interface ScenarioTableViewController : UITableViewController

@property(nonatomic, weak) id<ScenarioVcDelegate> delegate;

@property(nonatomic, strong) Scenario *scenario;

@property(nonatomic, strong) NSString *roomid;

@property(nonatomic, strong) NSString *userid0;

@property(nonatomic, strong) NSString *user0name;

@property(nonatomic, assign) int  editType;//0:追加 1:展示


@end
