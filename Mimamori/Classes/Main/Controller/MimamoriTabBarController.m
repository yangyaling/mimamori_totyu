//
//  MimamoriTabBarController.m
//  Mimamori
//
//  Created by NISSAY IT on 16/6/3.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "MimamoriTabBarController.h"

/**
 タブバーコントローラ
 */
@interface MimamoriTabBarController ()

@end

@implementation MimamoriTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupChildControllers];
    
    [self setupTabbarItems];

}


/**
 タブバーコントローラ  ->通知コントローラ , 生活コントローラ , その他コントローラ
 */
-(void)setupChildControllers{

    UIViewController *vc1 = [self tabBarControllerWithStoryboardName:@"Notification" title:@"通知"];
    
    UIViewController *vc2 =[self tabBarControllerWithStoryboardName:@"Life" title:@"生活"];
    
    UIViewController *vc3 =[self tabBarControllerWithStoryboardName:@"Sonota" title:@"その他"];
    
    self.viewControllers = @[vc1,vc2,vc3];
}



/**
 対応のストーリーボードのコントローラを探しています
 */
-(UIViewController *)tabBarControllerWithStoryboardName:(NSString *)storyboardName title:(NSString *)title{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    //vc->UINavigationController
    UIViewController *vc = [sb instantiateInitialViewController];
    vc.title = title;
    return vc;
}


/**
 タブバーコントローラのアイコン
 */
-(void)setupTabbarItems{
    
    [self setupTabbarItemWithIndex:0 imageName:@"notification-0" selectedImageName:@"notification"];
    [self setupTabbarItemWithIndex:1 imageName:@"shenghuo-0" selectedImageName:@"shenghuo"];
    [self setupTabbarItemWithIndex:2 imageName:@"others-0" selectedImageName:@"others"];
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:NITColor(252, 82, 115)} forState:UIControlStateSelected];
    
}


/**
 セット -> アイコン
 */
-(void)setupTabbarItemWithIndex:(int)index imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
     [[self.tabBar.items objectAtIndex:index]setImage:[[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabBar.items objectAtIndex:index]setSelectedImage:[[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}


@end
