//
//  AppDelegate.m
//  Mimamori
//
//  Created by NISSAY IT on 16/6/3.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//


#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>


#import "NotificationModel.h"
#import "MNoticeTool.h"

#define MainVC @"MainIdentifier"
#define LoginVC @"LoginIdentifier"

@interface AppDelegate ()

@property (nonatomic, strong) NSMutableArray *alertArr;//全ての通知アイテム(支援要請・センサー・お知らせ)(模型数组)
@property (nonatomic, strong) NSArray *readNoticeIdArr;//既読のお知らせ
@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window.backgroundColor= [UIColor whiteColor];
    
    [[UINavigationBar appearance] setTintColor:NITColor(252, 85, 115)];
    
    NSString *plistPath = [NITDocumentDirectory stringByAppendingPathComponent:@"loginFlgRecord.plist"];
    NSDictionary *vcdic = [NSDictionary dictionaryWithContentsOfFile:plistPath];

    
    // ログインFlag
    NSString *VcID = [vcdic[@"OldloginFlgKey"] isEqualToString:@"mimamori2"] ?  MainVC: LoginVC;

    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:VcID];
    
    
    
    
    
    //登録ローカルの通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // クリックして許す
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                }];
            } else {
                //クリックして許しません
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
        //iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        //iOS8システム以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 登録device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    //================================================================
    //================================================================
    
    // 追加タイマ
    [self addTimer];
    
    
    [self locationNotice];
    
    // バッファを整理する
    [self clearSensorData];
    
    return YES;
}


/**
  ローカルの通知
 */
- (void)locationNotice {
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == true) [[UIApplication sharedApplication]registerForRemoteNotifications];
    }];
    
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"TestMusic" withExtension:@"m4a"];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    
    [_player setVolume:0.0];
    
    [_player setNumberOfLoops:LONG_MAX];
    
    
//プレーヤーを追加
    [[AVAudioSession sharedInstance]setCategory: AVAudioSessionCategoryPlayback error: nil];
    [[AVAudioSession sharedInstance]setActive:YES error: nil];
    
}



/**
   楽屋入りに入ってから放送開始
 */
- (void)applicationDidEnterBackground:(UIApplication *)application{
    
    [_player play];
    
}

// 通知  method
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // プッシュしてくれたお願い
    UNNotificationContent *content = request.content; // プッシュしてくれたメッセージの内容
    NSNumber *badge = content.badge;  //プッシュのニュースを見る
    NSString *body = content.body;    // プッシュ情報体
    UNNotificationSound *sound = content.sound;  // メッセージの音をする
    NSString *subtitle = content.subtitle;
    NSString *title = content.title;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        
    }
    else {
      
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    completionHandler(UIBackgroundFetchResultNewData);
}


-(void)applicationWillEnterForeground:(UIApplication *)application{
    
    [_player pause];
    
    [_player stop];
    // メッセージ数は0に帰する
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    // すべての通知を取り消す
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}


//180 秒ごとに1度呼び出す
-(void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:180.0 target:self selector:@selector(getNoticeInfo) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//停止タイマ
-(void)stopTimer{
    [self.timer setFireDate:[NSDate distantFuture]];
}

//アクティブ・タイマ
-(void)startTimer{
    [self.timer  setFireDate:[NSDate distantPast]];
}

//通知を手配する
-(void)scheduleNotifications{
    
    // 3.取出缓存过的通知(お知らせ)
    NSArray *readArr = [NITUserDefaults objectForKey:@"readnotice"];
    if (readArr) {
        
     
        NSArray *noticeArray = [NotificationModel mj_keyValuesArrayWithObjectArray:self.alertArr];
        
        // 読みのお知らせを除く
        NSMutableArray *types = [NSMutableArray array];
        for (int i = 0; i<readArr.count ;i++) {
            NSString *noticeid = readArr[i];
            [types addObject:[NSPredicate predicateWithFormat:@"noticeid != %ld",(long)[noticeid integerValue]]];
        }
        NSPredicate *thePredicate = [NSCompoundPredicate andPredicateWithSubpredicates:types];
        NSArray *resultArr = [noticeArray filteredArrayUsingPredicate:thePredicate];
        
    
        self.alertArr = [NotificationModel mj_objectArrayWithKeyValuesArray:resultArr];
    }
    
    
    // 4.整理してお知らせを発送する
    
    NSMutableArray *contentArray = [[NSMutableArray alloc]init];
   
    for (int i = 0; i<self.alertArr.count; i++) {
        NotificationModel *notice = [self.alertArr objectAtIndex:i];
        NSString *typeStr =@"";
        if (notice.type == 1){
            typeStr = @"<センサー>";
        }else{
            typeStr = @"<支援要請>";
        }
        NSString *contentStr = [NSString stringWithFormat:@"%@%@ %@%@",typeStr,notice.username,notice.title,@"\n"];
        [contentArray addObject:contentStr];
    }
 
    if (contentArray.count>0) {
        NSString *sampleContent = [contentArray objectAtIndex:0];
        NSString *alertstring = @"";
        
        for (NSString *str in contentArray) {
            alertstring = [alertstring stringByAppendingString:str];
        }
        
        //ApplicationState Active
        if(!([UIApplication sharedApplication].applicationState == UIApplicationStateActive)){
           
            if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
                UILocalNotification *notification=[[UILocalNotification alloc]init];
                notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:0];
                notification.timeZone=[NSTimeZone defaultTimeZone];
                notification.alertTitle = @"アラート";
                notification.alertBody=[NSString stringWithFormat:@"%@等%luアラートがあります",sampleContent,(unsigned long)contentArray.count];
                notification.applicationIconBadgeNumber=contentArray.count;
                notification.alertAction=@"OPEN";
                notification.soundName=UILocalNotificationDefaultSoundName;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            } else {
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
                UNNotificationAction * actionone = [UNNotificationAction actionWithIdentifier:@"actionone" title:@"アラート" options:UNNotificationActionOptionNone];
                UNNotificationCategory * category = [UNNotificationCategory categoryWithIdentifier:@"myNotificationCategoryBtn" actions:@[actionone] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                //内容
                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                content.title = @"アラート";
                content.subtitle = [NSString stringWithFormat:@"%@等%luアラートがあります",sampleContent,(unsigned long)contentArray.count];
                content.body = alertstring;
                
                content.badge = @(contentArray.count);
                content.categoryIdentifier = @"myNotificationCategoryBtn";
                content.sound = [UNNotificationSound defaultSound];
                
                NSString *requestIdentifier = @"sampleRequest";
                
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier
                                                                                      content:content
                                                                                      trigger:trigger];
                [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category, nil]];
                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    if (!error) {
                        NSLog(@"推送已添加成功 %@", requestIdentifier);
                    }
                }];

            }
            
        } else {
            
            [self showAlertWithContents:alertstring];
        }
    
        
        
        
    }
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    
    if(!([UIApplication sharedApplication].applicationState == UIApplicationStateActive)){
        completionHandler(UNNotificationPresentationOptionBadge);
    }
    completionHandler(UNNotificationPresentationOptionSound |UNNotificationPresentationOptionAlert);
    
}



-(void)showAlertWithContents:(NSString *)titles{
    AudioServicesPlaySystemSound(1007);
    
    
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"アラート" message:titles preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
      
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;

        [[UIApplication sharedApplication] cancelAllLocalNotifications];

        if (self.readNoticeIdArr.count>0) {
            [NITUserDefaults setObject:self.readNoticeIdArr forKey:@"readnotice"];
        }
      
        
    }];
    
    [alert addAction:OKAction];
    
    [[self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController] presentViewController:alert animated:YES completion:nil];

}


/**現在のページを検索する*/
- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

/**
 *バッファを整理する
 */
-(void)clearSensorData{

    NSFileManager *manager = [NSFileManager defaultManager];
    
    /* Today (yyyyMMdd) */
    NSString *todayStr  = [[[NSDate otherDay:[NSDate date] symbols:LGFMinus dayNum:7]substringToIndex:10]stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSFileManager *fileManager=[[NSFileManager alloc] init];
    NSError *error = nil;
    /* 全てのファイル名 */
    NSArray *tmpFileName = [fileManager contentsOfDirectoryAtPath:NITDataPath error:&error];
    NSMutableArray *allFileName = [[NSMutableArray alloc] init];
    for (NSString *fileName in tmpFileName) {
        /* 拡張子が一致するか */
        if ([[fileName pathExtension] isEqualToString:@"data"]) {
            [allFileName addObject:fileName];
        }
    }
    
    if (allFileName.count > 0) {
        for (int i = 0; i < allFileName.count; i ++) {
            NSString *fileName = [allFileName objectAtIndex:i];
            NSString *tmp = [fileName substringWithRange:NSMakeRange([fileName rangeOfString:@"_"].location+1, 10)];
            NSString *tmp2 = [tmp stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            if ([todayStr intValue] >= [tmp2 intValue]) {
                [manager removeItemAtPath:[NITDataPath stringByAppendingPathComponent:fileName] error:nil];
            }
            
        }
    }

    
}


-(void)getNoticeInfo{
    MNoticeInfoParam *param = [[MNoticeInfoParam alloc]init];
    param.staffid = [NITUserDefaults objectForKey:@"userid1"];
    param.facilitycd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    param.startdate = @"2017-5-5";
//    [NSDate SharedToday];
    param.historyflg = @"0";
    param.noticetype = @"1";
    
    
    [MNoticeTool noticeInfoWithParam:param success:^(NSArray *array) {
        [MBProgressHUD hideHUD];
        if (array.count>0) {
            NSArray *noticeArr = [NotificationModel mj_objectArrayWithKeyValuesArray:array];
            
            self.alertArr = [[NSMutableArray alloc]init];
            for (NotificationModel *notice in noticeArr) {
                
                
                // 1.statues->0（確認必要）
                if (notice.status == 0) {
                    [self.alertArr addObject:notice];
                }
            }
            
            
            [self scheduleNotifications];
        } else {
            NITLog(@"h后台notice请求数据空");
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NITLog(@"h后台notice请求fail");
    }];

}




- (void)redirectNSlogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"dr.log"];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
   
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}




- (void)applicationWillTerminate:(UIApplication *)application {
 
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "wu.Mimamori" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Mimamori" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Mimamori.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}




@end
