//
//  DropButton.h
//  FSDropDownMenu
//
//  Created by totyu2 on 2017/4/26.
//  Copyright © 2017年 chx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropButton;
@protocol DropClickDelegate <NSObject>
@optional
-(void)SelectedListName:(NSDictionary *)clickDic;

@end

@interface DropButton : UIButton<DropClickDelegate>

@property (assign) IBOutlet id<DropClickDelegate>DropClickDelegate;


@property (nonatomic, strong) NSString                    *buttonTitle;

@property (nonatomic, assign) BOOL                         showAlert;


+(instancetype)sharedDropButton;

-(void)buttonClick:(UIButton *)sender;

@end
