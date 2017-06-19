//
//  NITPicker.h
//  LGFPicker
//
//  Created by totyu3 on 16/8/4.
//  Copyright © 2016年 totyu3. All rights reserved.
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
 *  初始化
 *
 *  @param superviews superview
 *  @param tag        父视图button 的 tag
 *  @param stype      0:1～72     1:1～100    2:以上 以下
 *
 */
-(instancetype)initWithFrame:(CGRect)frame superviews:(UIView*)superviews selectbutton:(UIButton*)selectbutton model:(NSArray *)model cellNumber:(NSInteger)number;

@end
