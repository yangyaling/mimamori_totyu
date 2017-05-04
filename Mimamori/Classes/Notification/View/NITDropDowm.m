//
//  PopViewLikeQQView.m
//  PopViewLikeQQView2
//
//  Created by ****** on 16/1/22.
//  Copyright © 2016年 *******. All rights reserved.
//
#import "NITDropDowm.h"
@interface NITDropDowm () <UITableViewDataSource, UITableViewDelegate>
/**选中的回调*/
@property (nonatomic, copy) void(^action)(NSInteger index);
@property (nonatomic, strong) NSArray *imagesArr;
@property (nonatomic, strong) NSArray *dataSourceArr;
@property (nonatomic, assign) BOOL animation;
@end
static NITDropDowm *backgroundView;

static UITableView *tableViewQ;
static CGRect frameQ;

@implementation NITDropDowm
/*
 * frame               设定tableView的位置
 * imagesArr           图片数组
 * dataSourceArr       文字信息数组
 * action              通过block回调 确定菜单中 被选中的cell
 * animation           是否有动画效果
 */
+ (void)configCustomPopViewWithFrame:(CGRect)frame imagesArr:(NSArray *)imagesArr dataSourceArr:(NSArray *)dataourceArr  seletedRowForIndex:(void(^)(NSInteger index))action animation:(BOOL)animation {
  
    frameQ = frame;
    if (backgroundView) {
        [ NITDropDowm removed];
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景色
    backgroundView = [[NITDropDowm  alloc] initWithFrame:window.bounds];
    backgroundView.action = action;
    backgroundView.imagesArr = imagesArr;
    
    backgroundView.dataSourceArr = dataourceArr;
    
    
    backgroundView.animation = animation;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.1;
    //添加手势 点击背景能够回收菜单
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:backgroundView action:@selector(handleRemoved)];
    [backgroundView addGestureRecognizer:tap];
    [window addSubview:backgroundView];
    
    //tableView
    tableViewQ = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableViewQ.delegate = backgroundView;
    tableViewQ.dataSource = backgroundView;
    

    
    tableViewQ.layer.cornerRadius = 10;
    tableViewQ.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
            tableViewQ.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
//    tableViewQ.layer.anchorPoint = anchorPointQ;
    
    [window addSubview:tableViewQ];
}

+ (void)removed {
    if (backgroundView.animation) {
        backgroundView.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            tableViewQ.alpha = 0;
            tableViewQ.transform = CGAffineTransformMakeScale(1, 0.0001);
//            CGAffineTransformMakeScale(0.25, 0.25);
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
            backgroundView = nil;
            [tableViewQ removeFromSuperview];
            tableViewQ = nil;
        }];
    }
}
- (void)handleRemoved {
    if (backgroundView) {
        _action(10000);
        [NITDropDowm removed];
    }
}
#pragma mark ---- UITableViewDelegateAndDatasource --
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifile = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifile];
    if (!cell) {
        //选择普通的tableviewCell 左边是图片 右边是文字
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifile];
    }
    
    NSString *textstr = [_dataSourceArr[indexPath.row] objectForKey:@"facilityname2"];
    
    UIImage *icon = [UIImage imageNamed:_imagesArr[indexPath.row]];
    
    CGSize itemSize = CGSizeMake(20, 20);
    
    UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
    
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    
    [icon drawInRect:imageRect];
    
    cell.imageView.contentMode=UIViewContentModeScaleToFill;
//    UIViewContentModeScaleAspectFit;
    
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
//    cell.imageView.image = [UIImage imageNamed:_imagesArr[indexPath.row]]; 
//    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.text = textstr;
    
    
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellH = tableViewQ.frame.size.height / _dataSourceArr.count;
    CGFloat maxH = tableViewQ.frame.size.height / 6.0;
    if (cellH < maxH) {
        return 30;
    } else {
        return cellH;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (backgroundView.action) {
        //利用block回调 确定选中的row
        _action(indexPath.row);
        NSMutableArray *tmpimagesname = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"CellImagesName"]];
        [tmpimagesname replaceObjectAtIndex:indexPath.row withObject:@"selectfacitility_icon"];
        [NITUserDefaults setObject:tmpimagesname forKey:@"TempcellImagesName"];
        [NITUserDefaults synchronize];
        [NITDropDowm removed];
    }
}

- (void)drawRect:(CGRect)rect {
//    NSLog(@"123-%f,456-%f",rect.origin.x,rect.origin.y);
    // 设置背景色
    [[UIColor whiteColor] set];
    //拿到当前视图准备好的画板
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    
    CGContextBeginPath(context);//标记
    CGFloat location = 95;
    CGContextMoveToPoint(context,
                         location -  10 , 80);//设置起点
    
    CGContextAddLineToPoint(context,
                            location - 2*10 ,  70);
    
    CGContextAddLineToPoint(context,
                            location - 10 * 3, 80);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [[UIColor whiteColor] setFill];  //设置填充色
    
    [[UIColor whiteColor] setStroke]; //设置边框颜色
    
    CGContextDrawPath(context,
                      kCGPathFillStroke);//绘制路径path

}

@end
