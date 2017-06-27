//
//  NITPicker.h
//  LGFPicker
//
//  Created by NISSAY IT on 16/8/4.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Device;

@protocol MyPickerDelegate <NSObject>

@optional
- (void)PickerDelegateSelectString:(NSString *)sinario withDic:(NSDictionary *)addcell;


@end

@interface NITPicker : UIView

@property (nonatomic, weak) id<MyPickerDelegate>mydelegate;
/**
 *
 *初期化
 *
 */
-(instancetype)initWithFrame:(CGRect)frame superviews:(UIView*)superviews selectbutton:(UIButton*)selectbutton model:(NSArray *)model cellNumber:(NSInteger)number;

@end
