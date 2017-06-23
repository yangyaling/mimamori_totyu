//
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
