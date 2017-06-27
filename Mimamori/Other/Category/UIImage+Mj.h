//
//  UIImage+Mj.h
//  Weibo
//
//  Created by NISSAY IT on 16/9/29.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Mj)

/**
 *  加载图片
 *
 *  @param name 图片名
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

@end
