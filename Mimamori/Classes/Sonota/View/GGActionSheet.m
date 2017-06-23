//
//  GGActionSheet.m
//  cicada
//
//  Created by iOSer on 2017/1/9.
//  Copyright © 2017年 iOSer. All rights reserved.
//
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#define TTRealValue(value) ((value)/375.0f*[UIScreen mainScreen].bounds.size.width)

#define HEXColor(hexValue,alphaValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue]

#define setIMG(name) [UIImage imageNamed:name]

#import "GGActionSheet.h"
typedef NS_ENUM(NSInteger,GGActionSheetType) {
    GGActionSheetTypeWithImg,
    GGActionSheetTypeWithTitle,
};

@interface GGActionSheet()
@property(nonatomic,assign) GGActionSheetType actionSheetType;
@property(nonatomic,strong) UIWindow          *backWindow;
@property(nonatomic,copy) NSArray             *imgArray; //画像配列
@property(nonatomic,copy) NSArray             *titles;     //タイトル配列
@property(nonatomic,copy) NSArray             *colors;
@property(nonatomic,strong) UIButton          *cancelBtn;   //キャンセルボタン
@property(nonatomic,strong) UIView            *optionsBgView;
@property(nonatomic,strong) UIView            *bgView;
@property(nonatomic,strong) NSMutableArray    *optionBtnArrayM;
@property(nonatomic,assign) float              bgViewHeigh;   //背景ビューの高さ
@end
@implementation GGActionSheet

+(instancetype)ActionSheetWithTitleArray:(NSArray<NSString *> *)titleArray andTitleColorArray:(NSArray *)colors delegate:(id<GGActionSheetDelegate>)delegate{
    return [[self alloc] initSheetWithTitles:titleArray andTitleColors:colors andDelegate:delegate];
}

+(instancetype)ActionSheetWithImageArray:(NSArray *)imgArray delegate:(id<GGActionSheetDelegate>)delegate{
    return [[self alloc] initSheetWithImgs:imgArray andDelegate:delegate];
}

-(instancetype)initSheetWithTitles:(NSArray *)titleArray andTitleColors:(NSArray *)colors andDelegate:(id<GGActionSheetDelegate>)delegate{
    self.titles = titleArray;
    self.colors = colors;
    self.actionSheetType = GGActionSheetTypeWithTitle;
    _delegate = delegate;
    return [self initActionSheet];
}
-(instancetype)initSheetWithImgs:(NSArray *)imgArray andDelegate:(id<GGActionSheetDelegate>)delegate{
    self.actionSheetType = GGActionSheetTypeWithImg;
    self.imgArray = imgArray;
    _delegate = delegate;
    return [self initActionSheet];
}



/**
 初期化
 */
-(instancetype)initActionSheet{
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        [self setBackgroundColor:HEXColor(0x000000, 0)];
        [self addSubview:self.bgView];
        
        //タッチの手真似
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlertView)];
        [self addGestureRecognizer:tap];
        [self.bgView addSubview:self.cancelBtn];
        [self.bgView addSubview:self.optionsBgView];
        
        float btnHeight = TTRealValue(56);
        float lineHeight = 0.5f;
        float optionViewLineHeight = 0;
        NSArray *arrayC = [[NSArray alloc] init];
        
        
        //actionSheet Type
        switch (self.actionSheetType){
            case GGActionSheetTypeWithImg:
                arrayC = self.imgArray;
                break;
            case GGActionSheetTypeWithTitle:
                arrayC = self.titles;
                break;
            default:
                break;
        }
        
        //分割線数
        if (arrayC.count == 0) {
            optionViewLineHeight = 0;
        }else{
            optionViewLineHeight = (arrayC.count-1) * lineHeight;
        }
        float optionBgWithCancelBtnMargin = TTRealValue(8);//オプションとボタンの間の間隔
        float optionBgViewHeight = btnHeight*arrayC.count + optionViewLineHeight;//オプション高度
        float btnAllAroundMargin = TTRealValue(16);//ボタンの距離は四方の間隔にする
        self.bgViewHeigh = optionBgViewHeight+optionBgWithCancelBtnMargin+btnHeight;
        
        
        //コントロール自動配置
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(@(optionBgViewHeight+optionBgWithCancelBtnMargin+btnHeight));
        }];
        
         //コントロール自動配置
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.bgView).offset(-btnAllAroundMargin);
            make.left.equalTo(self.bgView).offset(btnAllAroundMargin);
            make.height.equalTo(@(btnHeight));
        }];
       
         //コントロール自動配置
        [_optionsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.cancelBtn.mas_top).offset(-optionBgWithCancelBtnMargin);
            make.right.equalTo(self.bgView).offset(-btnAllAroundMargin);
            make.left.equalTo(self.bgView).offset(btnAllAroundMargin);
            make.height.equalTo(@(optionBgViewHeight));
        }];
        
        
        
        //導入のボタンタイトル
        for (int i = 0; i<arrayC.count; ++i) {
            UIButton *button = [UIButton new];
            button.tag = 990+i;
            [button setBackgroundColor:HEXColor(0xffffff, 1)];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (self.actionSheetType == GGActionSheetTypeWithTitle) {
                NSString *title = @"";
                NSAssert([self.titles[i] isKindOfClass:[NSString class]], @"标题数组里必须传入NSString类型对象" );
                title = self.titles[i];
                [button setTitle:title forState:UIControlStateNormal];
                [self.optionBtnArrayM addObject:button];
                
            }else if (self.actionSheetType == GGActionSheetTypeWithImg){
                NSString *imageName = @"";
                //
                NSAssert([self.imgArray[i] isKindOfClass:[NSString class]], @"图片名数组里必须传入NSString类型" );
                imageName = self.imgArray[i];
                [button setImage:setIMG(imageName) forState:UIControlStateNormal];
            }
            
            [self.optionsBgView addSubview:button];
            
            //フィルターとしてのデータを濾過する
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_optionsBgView).offset((i*btnHeight+(i*lineHeight)));
                make.left.right.equalTo(_optionsBgView);
                make.height.equalTo(@(btnHeight));
            }];
            
            //配列の長さ非0の時に創建する
            if (i != self.titles.count-1) {
                UIView *line = [UIView new];
                [self.optionsBgView addSubview:line];
                [line setBackgroundColor:HEXColor(0x000000, 0.1)];
                
                //コントロール自動配置
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(button.mas_bottom);
                    make.left.right.equalTo(_optionsBgView);
                    make.height.equalTo(@(lineHeight));
                }];
            }
        }
         [self optionColorSet];
    }
    
    return self;
}

-(void)setCancelDefaultColor:(UIColor *)cancelDefaultColor{
    _cancelDefaultColor = cancelDefaultColor;
    [self.cancelBtn setTitleColor:cancelDefaultColor forState:UIControlStateNormal];
}
-(void)setOptionDefaultColor:(UIColor *)optionDefaultColor{
    _optionDefaultColor = optionDefaultColor;
    [self optionColorSet];
}

-(void)optionColorSet{
    //配列は空っぽの時， 伝えなければならない UIColor タイプ
    if (self.optionBtnArrayM.count != 0) {
        UIColor *color = [UIColor whiteColor];
        
            //対応の色を設定する
            for (int i = 0; i<self.optionBtnArrayM.count; ++i) {
                UIButton *button = self.optionBtnArrayM[i];
                if (i<self.colors.count) {
                    NSAssert([self.colors[i] isKindOfClass:[UIColor class]], @"标题颜色数组里必须传入UIColor类型对象" );
                    color = self.colors[i];
                }else{
                    
                    if (self.optionDefaultColor != nil) {
                        color = self.optionDefaultColor;
                    }else{
                        color = [UIColor blackColor];
                    }
                }
                [button setTitleColor:color forState:UIControlStateNormal];
            }
        
    }
}

-(void)buttonClick:(UIButton *)btn{
    
    [self.delegate GGActionSheetClickWithIndex:(int)btn.tag-990];
    [self dismissAlertView];
}
-(void)cancelBtnClick{
    [self dismissAlertView];
}



/**
レイヤーアニメーションスイッチ
 */
-(void)layerAnimationMakeWithUp:(BOOL)up{
    [self.layer removeAllAnimations];
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    
    if (up == YES) {
        colorAnimation.duration = 0.3;
        colorAnimation.fromValue = (__bridge id _Nullable)([HEXColor(0x000000, 0) CGColor]);
        colorAnimation.toValue = (__bridge id _Nullable)([HEXColor(0x000000, 0.4) CGColor]);
    }else{
        colorAnimation.duration = 0.15;
        colorAnimation.fromValue = (__bridge id _Nullable)([HEXColor(0x000000, 0.4) CGColor]);
        colorAnimation.toValue = (__bridge id _Nullable)([HEXColor(0x000000, 0) CGColor]);
    }
    
    
    colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    colorAnimation.fillMode = kCAFillModeForwards;
    colorAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:colorAnimation forKey:@"colorAnimation"];

}


/**
 表示
 */
-(void)showGGActionSheet{
    _backWindow.hidden = NO;
    [self.backWindow addSubview:self];
    [self layerAnimationMakeWithUp:YES];
    [self.bgView.superview layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
        
            
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-self.bgViewHeigh);
        }];
        [self.bgView.superview layoutIfNeeded];//强制绘制
    }];
}


/**
 隠す
 */
-(void)dismissAlertView{
   
    [self layerAnimationMakeWithUp:NO];
    [UIView animateWithDuration:0.15 animations:^{
        [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
        }];
        [self.bgView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_backWindow resignKeyWindow];
        _backWindow.hidden = YES;
    }];
}



-(UIWindow *)backWindow{
    if (!_backWindow) {
        _backWindow=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.windowLevel=UIWindowLevelAlert;
        [_backWindow becomeKeyWindow];
        [_backWindow makeKeyAndVisible];
    }
    return _backWindow;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setBackgroundColor:HEXColor(0xffffff, 1)];
        [_cancelBtn setTitle:@"キャンセル" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEXColor(0x49515c, 1) forState:UIControlStateNormal];
        _cancelBtn.layer.cornerRadius = 10;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UIView *)optionsBgView{
    if (!_optionsBgView) {
        _optionsBgView = [UIView new];
        [_optionsBgView setBackgroundColor:HEXColor(0xffffff, 1)];
        _optionsBgView.layer.cornerRadius = 10;
        _optionsBgView.layer.masksToBounds = YES;
    }
    return _optionsBgView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        [_bgView setBackgroundColor:[UIColor clearColor]];
    }
    return _bgView;
}
-(NSMutableArray *)optionBtnArrayM{
    if (!_optionBtnArrayM) {
        _optionBtnArrayM = [[NSMutableArray alloc] initWithCapacity:41];
    }
    return _optionBtnArrayM;
}

@end
