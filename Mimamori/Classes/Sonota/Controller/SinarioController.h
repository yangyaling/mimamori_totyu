//
//  SinarioController.h
//  Mimamori
//
//  Created by NISSAY IT on 2016/12/14.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ScenarioVcDelegate <NSObject>

-(void)warningScenarioAddedShow:(NSString *)message;

@end


@interface SinarioController : UIViewController

@property(nonatomic, weak) id<ScenarioVcDelegate>delegate;


/**
 居室ID
 */
@property (nonatomic, copy) NSString                      *roomID;


/**
 シナリオID
 */
@property (nonatomic, copy) NSString                      *scenarioID;



/**
 追加（Y） 、編集（N）
 */
@property (nonatomic, assign) BOOL                        isRefresh;

/**
 シナリオ名称
 */
@property (nonatomic, copy) NSString                      *textname;

/**
 入居者ID（見守られる人）
 */
@property (nonatomic, copy) NSString                      *user0;
/**
 入居者名（見守られる人）
 */
@property (nonatomic, copy) NSString                      *user0name;

/**
 終了時間
 */
@property (nonatomic, copy) NSString                      *endtime;

/**
 開始時間
 */
@property (nonatomic, copy) NSString                      *starttime;

//時間帯
@property (nonatomic, assign) NSInteger                   scopecd;

/**
  一覧 、 編集
 */
@property (nonatomic, assign) BOOL                        hideBarButton;

@end
