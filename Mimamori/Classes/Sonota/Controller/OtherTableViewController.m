//
//  OtherTableViewController.m
//  Mimamori
//
//  Created by totyu3 on 16/6/3.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "OtherTableViewController.h"
#import "AppDelegate.h"

@interface OtherTableViewController ()<UIApplicationDelegate>

@end

@implementation OtherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //　見守り設定
    if (indexPath.row == 0) {
        
        [self performSegueWithIdentifier:@"sickPersonPush" sender:tableView];
        
    //　マイプロフィール
    }else if (indexPath.row ==1){
        
        [self performSegueWithIdentifier:@"selfPush" sender:self];
    //　ログアウト
    }else if (indexPath.row ==2){

        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:nil message:@"ログアウトします。よろしいですか。" preferredStyle: UIAlertControllerStyleAlert];
        [alert2 addAction:[UIAlertAction actionWithTitle:@"はい" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            // 1. ログインFlag -> 1(未登録)
            [NITUserDefaults setObject:@"1" forKey:@"loginFlg"];
            // 2. 删除缓存数据(data)
            NSFileManager *manager = [NSFileManager defaultManager];
            
            [manager removeItemAtPath:NITDataPath error:nil];
            
            // 3 删除缓存数据(既読のお知らせアラート)
            [NITUserDefaults removeObjectForKey:@"readnotice"];
            
            // 4.返回登录页面
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.window.rootViewController = [appDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"LoginIdentifier"];
            
            // 5.移除定时器
            [appDelegate removeTimer];
            
        }]];
        
        [alert2 addAction:[UIAlertAction actionWithTitle:@"いいえ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        }]];
        [self presentViewController:alert2 animated:true completion:nil];
        
    }

}


@end
