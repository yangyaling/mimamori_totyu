//
//  PopButton.m
//  Mimamori2
//
//  Created by totyu2 on 2017/4/27.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "PopButton.h"

@implementation PopButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)select{
    
    [[self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController].navigationController popViewControllerAnimated:NO];
    
}

/**查找当前页面的根控制器*/
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
@end
