//
//  GGActionSheet.h
//  cicada
//
//  Created by iOSer on 2017/1/9.
//  Copyright © 2017年 iOSer. All rights reserved.
//

/*
 
 **/
#import <UIKit/UIKit.h>
@protocol GGActionSheetDelegate<NSObject>
-(void)GGActionSheetClickWithIndex:(int)index;
@end
@interface GGActionSheet : UIView
@property(nonatomic,weak) id <GGActionSheetDelegate> delegate;
//キャンセルボタン色
@property(nonatomic,strong) UIColor *cancelDefaultColor;
//オプションボタン色
@property(nonatomic,strong) UIColor *optionDefaultColor;




//タイトル形式を作成 -> ActionSheet
+(instancetype)ActionSheetWithTitleArray:(NSArray *)titleArray  andTitleColorArray:(NSArray *)colors delegate:(id<GGActionSheetDelegate>)delegate;

//画像を作成する -> ActionSheet
+(instancetype)ActionSheetWithImageArray:(NSArray *)imgArray delegate:(id<GGActionSheetDelegate>)delegate;

//表示ActionSheet
-(void)showGGActionSheet;



@end
