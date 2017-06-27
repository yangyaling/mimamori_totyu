//
//  NITPickerTemp.h
//  Mimamori2
//
//  Created by NISSAY IT on 2017/5/5.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NITPickerTemp;

@protocol MyPickerDelegate <NSObject>

@optional

- (void)PickerDelegateSelectString:(NSString *)sinario withDic:(NSDictionary *)addcell;

@end

@interface NITPickerTemp : UIView

@property (nonatomic, weak) id<MyPickerDelegate>mydelegate;


-(instancetype)initWithFrame:(CGRect)frame superviews:(UIView*)superviews selectbutton:(UIButton*)selectbutton cellNumber:(NSInteger)number isBool:(BOOL)isOn;
@end
