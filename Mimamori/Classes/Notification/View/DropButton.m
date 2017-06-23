//
//  DropButton.m
//  FSDropDownMenu
//
//  Created by totyu2 on 2017/4/26.
//  Copyright © 2017年 chx. All rights reserved.
//

#import "DropButton.h"

@interface DropButton ()

@property (nonatomic, assign) BOOL        isShow;

@end

@implementation DropButton

+(instancetype)sharedDropButton {
    DropButton *dropbtn = [[DropButton alloc] init];
    return dropbtn;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        
        [self setinit];
        
    }
    
    return self;
}


-(instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        [self setinit];
        
    }
    
    return self;
}


/**
 初期化ドロップボタン
 */
-(instancetype)setinit {
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6;
        self.frame = CGRectMake(30, 2, [UIScreen mainScreen].bounds.size.width-60, 40);
        self.backgroundColor = [UIColor whiteColor];
        NSString *str = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
        [self setTitle:str forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [self setImage:[UIImage imageNamed:@"drop_icon"] forState:UIControlStateNormal];
        self.imageEdgeInsets = UIEdgeInsetsMake(2, 4, 2, 200);
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.isShow = YES;
        self.showAlert = NO;
        
        [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}


/**
 設置ドロップボタンタイトル
 */
- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;
    [self setTitle:buttonTitle forState:UIControlStateNormal];
}



/**
 facility  button  click  method
 */
-(void)buttonClick:(UIButton *)sender {
    if (self.isShow) {
        self.isShow = NO;
        [self buttonImageViewAnimateStatas:M_PI];
        
        NSMutableArray *tmparr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"FacilityList"]];
        
        NSArray *iconname = [NITUserDefaults objectForKey:@"TempcellImagesName"];
        
        [NITDropDowm configCustomPopViewWithFrame:CGRectMake(30, 80, 140, 180) imagesArr:iconname dataSourceArr:tmparr seletedRowForIndex:^(NSInteger index) {
            
            [self buttonClick:sender];
            
            if (index == 10000) return ;
            
            //警報状態
            if (_showAlert) {
                
                [self isShowAlert:tmparr andIndex:index];
                
            } else {
                
                NSString *str = [tmparr[index] objectForKey:@"facilityname2"];
                
                [self setTitle:str forState:UIControlStateNormal];
                
                [NITUserDefaults setObject:tmparr[index] forKey:@"TempFacilityName"];
                [NITUserDefaults synchronize];
                
                NSMutableArray *tmpimagesname = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"CellImagesName"]];
                
                [tmpimagesname replaceObjectAtIndex:index withObject:@"selectfacitility_icon"];
                [NITUserDefaults setObject:tmpimagesname forKey:@"TempcellImagesName"];
                [NITUserDefaults synchronize];
                
                if ([self.DropClickDelegate respondsToSelector:@selector(SelectedListName:)]) {
                    [self.DropClickDelegate SelectedListName:tmparr[index]];
                }
            }
            
        } animation:YES];
        
    } else {
        self.isShow = YES;
        [self buttonImageViewAnimateStatas:0];
    }
    
}


/**
 マスターコントローラ  編集状態時切替施設
 */
- (void)isShowAlert:(NSArray *)array andIndex:(NSInteger)index {
    
    id control = [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    
    [NITDeleteAlert SharedAlertShowMessage:@"施設を切り替えますか？施設を切り替えますと、現在編集中の内容が保存されません。"  andControl:control withOk:^(BOOL isOk) {
    
        NSString *str = [array[index] objectForKey:@"facilityname2"];
        
        [self setTitle:str forState:UIControlStateNormal];
        
        [NITUserDefaults setObject:array[index] forKey:@"TempFacilityName"];
        [NITUserDefaults synchronize];
        
        NSMutableArray *tmpimagesname = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"CellImagesName"]];
        
        [tmpimagesname replaceObjectAtIndex:index withObject:@"selectfacitility_icon"];
        [NITUserDefaults setObject:tmpimagesname forKey:@"TempcellImagesName"];
        [NITUserDefaults synchronize];
        
        
        if ([self.DropClickDelegate respondsToSelector:@selector(SelectedListName:)]) {
            [self.DropClickDelegate SelectedListName:array[index]];
        }
    
    }];
}


/**
 回転アニメーション
 */
-(void)buttonImageViewAnimateStatas:(double)statas {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.imageView.transform = CGAffineTransformMakeRotation(statas);
    } completion:^(BOOL finished) {
    }];
}


/**
 現在のメインコントローラを探しています
 */
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
