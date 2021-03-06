//
//  MimamoriTabBarController.m
//  Mimamori
//
//  Created by totyu3 on 16/6/3.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "MimamoriTabBarController.h"

@interface MimamoriTabBarController ()

@end

@implementation MimamoriTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabBarControllers];
    
    [self setupTabbarItems];

}


-(void)setupTabBarControllers{

    UIViewController *vc1 = [self tabBarControllerWithStoryboardName:@"Notification" title:@"通知"];
    UIViewController *vc2 =[self tabBarControllerWithStoryboardName:@"Emergency" title:@"支援要請"];
    UIViewController *vc3 =[self tabBarControllerWithStoryboardName:@"Life" title:@"生活"];
    UIViewController *vc4 =[self tabBarControllerWithStoryboardName:@"Sonota" title:@"その他"];
    self.viewControllers = @[vc1,vc2,vc3,vc4];
}

-(UIViewController *)tabBarControllerWithStoryboardName:(NSString *)storyboardName title:(NSString *)title{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    vc.title = title;
    
    return vc;
}

-(void)setupTabbarItems{
    
    [self setupTabbarItemWithIndex:0 imageName:@"notification-0" selectedImageName:@"notification"];
    [self setupTabbarItemWithIndex:1 imageName:@"zhiyuan-0" selectedImageName:@"zhiyuan"];
    [self setupTabbarItemWithIndex:2 imageName:@"shenghuo-0" selectedImageName:@"shenghuo"];
    [self setupTabbarItemWithIndex:3 imageName:@"others-0" selectedImageName:@"others"];
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:86.0/255.0 green:171.0/255.0 blue:228.0/255.0 alpha:1.0f]} forState:UIControlStateSelected];
    
    
}

-(void)setupTabbarItemWithIndex:(int)index imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
     [[self.tabBar.items objectAtIndex:index]setImage:[[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabBar.items objectAtIndex:index]setSelectedImage:[[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}


@end
