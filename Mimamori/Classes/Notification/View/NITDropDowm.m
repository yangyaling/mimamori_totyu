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
 * frame               設定tableView位置
 * imagesAr            画像配列
 * dataSourceArr       文字情報
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
    
    //手真似を追加   背景をクリックしてメニューを取り除く
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


/**
 除去
 */
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


/**
  method（removed）
 */
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
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.text = textstr;
    
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArr.count;
}


/**
 数量計算高度に計算されて
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellH = tableViewQ.frame.size.height / _dataSourceArr.count;
    CGFloat maxH = tableViewQ.frame.size.height / 6.0;
    if (cellH < maxH) {
        return 30;
    } else {
        return cellH;
    }
    
    
}


/**
//block 転送
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (backgroundView.action) {
        
        _action(indexPath.row);
        
        [NITDropDowm removed];
    }
}



/**
 絵を描く
 */
- (void)drawRect:(CGRect)rect {
    // 背景色の設定
    [[UIColor whiteColor] set];
    
    //現在のビューを準備したパネル
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    //
    CGContextBeginPath(context);//マーク
    CGFloat location = 95;
    CGContextMoveToPoint(context,
                         location -  10 , 80);//スタートを設定して
    
    CGContextAddLineToPoint(context,
                            location - 2*10 ,  70);
    
    CGContextAddLineToPoint(context,
                            location - 10 * 3, 80);
    
    CGContextClosePath(context);//
    
    [[UIColor whiteColor] setFill];  //充填色を設定する
    
    [[UIColor whiteColor] setStroke]; //フレームの色を設定して
    
    CGContextDrawPath(context,
                      kCGPathFillStroke);//

}

@end
