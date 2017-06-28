//
//  UIFont+FontAwesome.m
//  FontAwesome-iOS Demo
//
//  Created by NISSAY IT. on 1/16/13.
//  Copyright (c) 2013 NISSAY IT. All rights reserved.
//

#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"

@implementation UIFont (FontAwesome)

#pragma mark - Public API
+ (UIFont*)fontAwesomeFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:kFontAwesomeFamilyName size:size];
}

@end
