//
//  XHQZuiSaoYiSaoView.h
//  
//
//  Created by qianfeng on 16/3/25.
//
//

#import <UIKit/UIKit.h>

@interface NITDropDowm : UIView
+ (void)configCustomPopViewWithFrame:(CGRect)frame imagesArr:(NSArray *)imagesArr dataSourceArr:(NSArray *)dataourceArr  seletedRowForIndex:(void(^)(NSInteger index))action animation:(BOOL)animation;

+ (void)removed;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
