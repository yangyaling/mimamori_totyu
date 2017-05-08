//
//  SinarioController.h
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Device;

@protocol ScenarioVcDelegate <NSObject>

-(void)warningScenarioAddedShow:(NSString *)message;

@end


@interface SinarioController : UIViewController

@property(nonatomic, weak) id<ScenarioVcDelegate>delegate;

@property (nonatomic, copy) Device *device;

@property (nonatomic, copy) NSString                      *roomID;

@property (nonatomic, copy) NSString                      *scenarioID;

@property (nonatomic, assign) BOOL                        isRefresh;

@property (nonatomic, copy) NSString                      *textname;

@property (nonatomic, copy) NSString                      *user0;

@property (nonatomic, copy) NSString                      *user0name;

@property (nonatomic, copy) NSString                      *endtime;

@property (nonatomic, copy) NSString                      *starttime;

@property (nonatomic, assign) NSInteger                   scopecd;

@property (nonatomic, assign) BOOL                        hideBarButton;

@end
