//
//  AppDelegate.m
//  Mimamori
//
//  Created by totyu3 on 16/6/3.
//  Copyright © 2016年 totyu3. All rights reserved.
//


#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>


#import "NotificationModel.h"
#import "MNoticeTool.h"
#import "MGroupTool.h"

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
//    NSString *vcstr = [NITUserDefaults objectForKey:@"OldloginFlgKey"];
    // ログインFlag
    NSString *VcID = [vcdic[@"OldloginFlgKey"] isEqualToString:@"mimamori2"] ?  MainVC: LoginVC;
//    NSString *VcID = [vcstr isEqualToString:@"mimamori2"] ?  MainVC: LoginVC;
    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:VcID];
    
    
    
    //串行队列 异步任务 (非常非常有用！！！!!!!)
    dispatch_async(dispatch_queue_create("SERIAL", DISPATCH_QUEUE_SERIAL), ^{
        [self getGroupInfo];
    });
    
    
    
    //注册本地通知
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"本地通知注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//                    NSLog(@"%@", settings);
                }];
            } else {
                // 点击不允许
                NSLog(@"本地通知注册失败");
                [MBProgressHUD showError:@""];
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
        //iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        //iOS8系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    //================================================================
    //[self redirectNSlogToDocumentFolder];
    //================================================================
    
    // 添加定时器
    [self addTimer];
    
    
    [self locationNotice];
    
    // 整理缓存
    [self clearSensorData];
    
    return YES;
}


/**
  本地后台通知
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
    
    
//
    [[AVAudioSession sharedInstance]setCategory: AVAudioSessionCategoryPlayback error: nil];
    [[AVAudioSession sharedInstance]setActive:YES error: nil];
    
}



/**
   进入后台开始播放
 */
- (void)applicationDidEnterBackground:(UIApplication *)application{
    
    [_player play];
    
}

// 通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    // Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler();  // 系统要求执行这个方法
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"iOS7及以上系统，收到通知");
    completionHandler(UIBackgroundFetchResultNewData);
}


-(void)applicationWillEnterForeground:(UIApplication *)application{
    [_player pause];
    [_player stop];
    // 消息数归0
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    // 取消所有的通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}


//添加定时器(每隔n秒调用一次)
-(void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(getNoticeInfo) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//移除定时器
-(void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

//安排通知
-(void)scheduleNotifications{
    
    // 3.取出缓存过的通知(お知らせ)
    NSArray *readArr = [NITUserDefaults objectForKey:@"readnotice"];
    if (readArr) {
        
        // 3.1 alertArr模型数组 -> 字典数组
        NSArray *noticeArray = [NotificationModel mj_keyValuesArrayWithObjectArray:self.alertArr];
        // 3.2 字典数组中(用noticeid)除去已读的通知
        NSMutableArray *types = [NSMutableArray array];
        for (int i = 0; i<readArr.count ;i++) {
            NSString *noticeid = readArr[i];
            [types addObject:[NSPredicate predicateWithFormat:@"noticeid != %ld",(long)[noticeid integerValue]]];
        }
        NSPredicate *thePredicate = [NSCompoundPredicate andPredicateWithSubpredicates:types];
        NSArray *resultArr = [noticeArray filteredArrayUsingPredicate:thePredicate];
        
        // 3.3 字典数组－>alertArr模型数组
        self.alertArr = [NotificationModel mj_objectArrayWithKeyValuesArray:resultArr];
    }
    
    
    // 4.整理并发送通知
    
    NSMutableArray *contentArray = [[NSMutableArray alloc]init];
    
    // 4.1 整理通知显示用内容
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
    
    // 4.2 设置、安排通知
    if (contentArray.count>0) {
        NSString *sampleContent = [contentArray objectAtIndex:0];
        NSString *alertstring = @"";
        
        for (NSString *str in contentArray) {
            alertstring = [alertstring stringByAppendingString:str];
        }
        
        if([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0){
            //创建通知
            
            
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
            
        } else {
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:0];
            //notification.repeatInterval=1;
            //notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            notification.timeZone=[NSTimeZone defaultTimeZone];
            notification.alertTitle = @"アラート";
            notification.alertBody=[NSString stringWithFormat:@"%@等%luアラートがあります",sampleContent,(unsigned long)contentArray.count]; //通知主体
            notification.applicationIconBadgeNumber=contentArray.count;//应用程序图标右上角显示的消息数
            notification.alertAction=@"OPEN"; //待机界面的滑动动作提示
            //notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图
            notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            //notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
            //notification.userInfo=@{@"id":@1,@"content":contentArray};//绑定到通知上的其他附加信息
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];//调用通知
            // 5 发送AlertController
            [self showAlertWithContents:alertstring];
        }
        
        
    }
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    //如果App不在前台，需要Badge
    if(!([UIApplication sharedApplication].applicationState == UIApplicationStateActive)){
        completionHandler(UNNotificationPresentationOptionBadge);
    }
    completionHandler(UNNotificationPresentationOptionSound |UNNotificationPresentationOptionAlert);
}



-(void)showAlertWithContents:(NSString *)titles{
    AudioServicesPlaySystemSound(1007);
    
    //NSArray *contentArr = [notification.userInfo valueForKey:@"content"];
    
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"アラート" message:titles preferredStyle:UIAlertControllerStyleAlert];
    
    //点击OK按钮
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // 1.bandge消息数归0
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        // 2.取消所有的通知
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        // 3.缓存已经显示过的(已读)的通知
        if (self.readNoticeIdArr.count>0) {
            [NITUserDefaults setObject:self.readNoticeIdArr forKey:@"readnotice"];
        }
        // 4.如果现在在别的页面，点击查看可以跳转到通知页面
        
    }];
    
    [alert addAction:OKAction];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];

}

/**
 *   清理缓存(7天前的缓存数据清除)
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
    param.startdate = [NSDate SharedToday];
    param.historyflg = @"0";
    param.noticetype = @"1";
    
    
    [MNoticeTool noticeInfoWithParam:param success:^(NSArray *array) {
        [MBProgressHUD hideHUD];
        if (array.count>0) {
            NSArray *noticeArr = [NotificationModel mj_objectArrayWithKeyValuesArray:array];
            
            self.alertArr = [[NSMutableArray alloc]init];
//            NSMutableArray *noticeIdArr = [[NSMutableArray alloc]init];
            for (NotificationModel *notice in noticeArr) {
                
                // 0. 把お知らせ(type->2)的noticeid保存起来用来过滤(点击ok按钮后缓存)
//                if (notice.type == 2) {
//                    [noticeIdArr addObject:[NSString stringWithFormat:@"%ld",(long)notice.noticeid]];            }
                
                // 1.把statues->0（確認必要）的拎出来
                if (notice.status == 0) {
                    [self.alertArr addObject:notice];
                }
            }
            
//            self.readNoticeIdArr = [NSArray arrayWithArray:noticeIdArr];
            
            
            // 2.过滤数据，安排发送通知
            [self scheduleNotifications];
        } else {
            NITLog(@"h后台notice请求数据空");
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NITLog(@"h后台notice请求fail");
    }];
    

}

/**
 *  GruopInfoを取得
 */
-(void)getGroupInfo{
    [MGroupTool groupInfoWithsuccess:^(NSArray *array) {
        [MBProgressHUD hideHUD];
        //缓存groupinfo
        if (array.count > 0) {
            [NITUserDefaults setObject:[array copy] forKey:@"allGroupData"];
            [NITUserDefaults synchronize];
        } else {
            NITLog(@"zwgetgroupinfo请求数据空");
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NITLog(@"zwgetgroupinfo请求失败");
    }];
}


// 将NSlog打印信息保存到Document目录下的文件中
- (void)redirectNSlogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"dr.log"];// 注意不是NSData!
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    // 先删除已经存在的文件
    // 将log输入到文件
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
