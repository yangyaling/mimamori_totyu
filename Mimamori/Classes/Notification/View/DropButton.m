//
//  DropButton.m
//  FSDropDownMenu
//
//  Created by totyu2 on 2017/4/26.
//  Copyright © 2017年 chx. All rights reserved.
//

#import "DropButton.h"

@interface DropButton ()

@property (nonatomic, assign) BOOL        isShow;

@end

@implementation DropButton

+(instancetype)sharedDropButton {
    DropButton *dropbtn = [[DropButton alloc] init];
    return dropbtn;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        
        [self setinit];
        
    }
    
    return self;
}

-(instancetype)init {
    self = [super init];
    
    if (self) {
        
        [self setinit];
        
    }
    
    return self;
}


-(instancetype)setinit {
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6;
        self.frame = CGRectMake(30, 2, [UIScreen mainScreen].bounds.size.width-60, 40);
        self.backgroundColor = [UIColor whiteColor];
        NSString *str = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
        [self setTitle:str forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [self setImage:[UIImage imageNamed:@"drop_icon"] forState:UIControlStateNormal];
        self.imageEdgeInsets = UIEdgeInsetsMake(2, 4, 2, 200);
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.isShow = YES;
        
        [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;
    [self setTitle:buttonTitle forState:UIControlStateNormal];
}


-(void)buttonClick:(UIButton *)sender {
    if (self.isShow) {
        self.isShow = NO;
        [self buttonImageViewAnimateStatas:M_PI];
//        [self.dropButtonDelegate showSelectedList];
        
        NSMutableArray *tmparr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"FacilityList"]];
        
        NSArray *iconname = [NITUserDefaults objectForKey:@"TempcellImagesName"];
        
        [NITDropDowm configCustomPopViewWithFrame:CGRectMake(30, 80, 140, 180) imagesArr:iconname dataSourceArr:tmparr seletedRowForIndex:^(NSInteger index) {
            
            [self buttonClick:sender];
            if (index == 10000) return ;
            
            NSString *str = [tmparr[index] objectForKey:@"facilityname2"];
            
            [self setTitle:str forState:UIControlStateNormal];
            
            [NITUserDefaults setObject:tmparr[index] forKey:@"TempFacilityName"];
            [NITUserDefaults synchronize];
            
            if ([self.DropClickDelegate respondsToSelector:@selector(SelectedListName:)]) {
                [self.DropClickDelegate SelectedListName:tmparr[index]];
            }
            
        } animation:YES];
        
    } else {
        self.isShow = YES;
        [self buttonImageViewAnimateStatas:0];
    }
    
}

-(void)buttonImageViewAnimateStatas:(double)statas {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.imageView.transform = CGAffineTransformMakeRotation(statas);
    } completion:^(BOOL finished) {
    }];
}

@end
