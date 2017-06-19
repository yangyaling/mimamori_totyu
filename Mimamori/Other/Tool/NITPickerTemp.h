//
//  NITPickerTemp.h
//  Mimamori2
//
//  Created by totyu2 on 2017/5/5.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NITPickerTemp;

@protocol MyPickerDelegate <NSObject>

@optional

- (void)PickerDelegateSelectString:(NSString *)sinario withDic:(NSDictionary *)addcell;

@end

@interface NITPickerTemp : UIView

@property (nonatomic, weak) id<MyPickerDelegate>mydelegate;
/**
 *  初始化
 *
 *  @param superviews superview
 *  @param tag        父视图button 的 tag
 */
-(instancetype)initWithFrame:(CGRect)frame superviews:(UIView*)superviews selectbutton:(UIButton*)selectbutton cellNumber:(NSInteger)number isBool:(BOOL)isOn;
@end
