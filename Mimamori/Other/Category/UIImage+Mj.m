//
//  UIImage+Mj.m
//  Weibo
//
//  Created by NISSAY IT on 16/9/29.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "UIImage+Mj.h"

@implementation UIImage (Mj)

+ (UIImage *)imageWithName:(NSString *)name
{
    if (iOS7) {
        NSString *newName = [name stringByAppendingString:@"_os7"];
        UIImage *image = [UIImage imageNamed:newName];
        if (image == nil) {
            image = [UIImage imageNamed:name];
        }
        return image;
    }
    
 
    return [UIImage imageNamed:name];
}

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

@end
