//
//  NITPicker.m
//  LGFPicker
//
//  Created by totyu3 on 16/8/4.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#define bgcolor [UIColor whiteColor]//self背景色
#define pickertextcolor [UIColor blackColor]
#define righttitlecolor [UIColor colorWithRed:100.0/255.0 green:150.0/255.0 blue:235.0/255.0 alpha:1.0]
#define lefttitlecolor [UIColor colorWithRed:255.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1.0]
#define pathcolor [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0].CGColor


#define realframe CGRectMake(self.frame.origin.x-120, self.frame.origin.y-120, self.frame.size.width+240, self.frame.size.height+160)//self真实frame
#define pickerlabelframe CGRectMake(0, 0,_nitpicker.frame.size.width / 2.0,30)//picker标题

#define pickerlabelframe2 CGRectMake(0, 0,_nitpicker.frame.size.width,30)//picker标题

#define nitpickerframe CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height*0.8)//主picker
#define leftbuttonframe CGRectMake(self.bounds.origin.x, self.bounds.size.height*0.8, self.bounds.size.width/2, self.bounds.size.height*0.2)//取消按钮
#define rightbuttonframe CGRectMake(self.bounds.size.width/2, self.bounds.size.height*0.8, self.bounds.size.width/2, self.bounds.size.height*0.2)//确定按钮

#import "NITPicker.h"
#import "Device.h"

@interface NITPicker()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    //以下对象无需 get set
    NSString*select;
    NSString*select2;
    NSDictionary *selectdic;
    int scenariotype;
}
@property (nonatomic, strong) UIPickerView             *nitpicker;
@property (nonatomic, strong) UIButton                   *leftbtn;
@property (nonatomic, strong) UIButton                   *rightbtn;
@property (nonatomic, strong) CAShapeLayer             *pathlayer;
@property (nonatomic, strong) NSMutableArray           *time;
@property (nonatomic, strong) NSMutableArray           *value;
@property (nonatomic, strong) NSMutableArray           *type;
@property (nonatomic, strong) NSMutableArray           *names;
@property (nonatomic, strong) UIButton                   *thisbutton;

@property (nonatomic, strong) Device                   *model;

@property (nonatomic, assign) NSInteger                cellindex;

@end
@implementation NITPicker

-(instancetype)initWithFrame:(CGRect)frame superviews:(UIView*)superviews selectbutton:(UIButton*)selectbutton model:(Device *)model cellNumber:(NSInteger)number {
    self = [super initWithFrame:frame];
    if (self) {
        
        switch (selectbutton.tag) {
//            case 11:
//                scenariotype =0;
//                break;
            case 22:
            case 33:
            case 44:
            case 99:
                scenariotype =1;
                break;
            case 55:
                scenariotype =2;
                break;
            case 66:
                scenariotype =3;
                break;
            case 77:
                scenariotype =4;
                break;
            case 88:
                scenariotype =6;
                break;
            case 11:
                scenariotype =7;
                break;
                
            default:
                break;
        }
//        if (selectbutton.tag==22||selectbutton.tag==11) {
//            
//        }else if(selectbutton.tag==33){
//            scenariotype =1;
//        }else if(selectbutton.tag==44){
//            scenariotype = 2;
//        } else if (selectbutton.tag == 55) {
//            scenariotype = 3;
//        } else if (selectbutton.tag == 66){
//            scenariotype = 4;
//        } else {
//            scenariotype = 5;
//        }
        self.cellindex = number;
        self.thisbutton = selectbutton;
        self.model = model;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1,1);
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 2;
        self.center = superviews.center;
        self.backgroundColor = bgcolor;
        self.layer.cornerRadius = 10;
        [self commonInit];
    }
    return self;
}
//初始化显示用数据源
-(void)commonInit{
    
    //重置frame
    self.frame = realframe;
    
    //添加控件
    [self addcontrol];
}


/**
 *  添加控件
 */
-(void)addcontrol{
    
    [self addSubview:self.nitpicker];
    [self addSubview:self.leftbtn];
    [self addSubview:self.rightbtn];
    [self.layer addSublayer:self.pathlayer];
    [self defaultselect];//默认选中
    
}
/**
 *  默认选中
 */
-(void)defaultselect{
    
    switch (scenariotype) {
        case 1:
            select = self.time[0];
            break;
        case 2:
            select = self.value[0];
            select2 = self.type[0];
            break;
        case 3:
            select = self.value[0];
            select2 = self.type[0];
            break;
        case 4:
            select = self.value[0];
            select2 = self.type[0];
            break;
        case 6:
            select = self.names[0];
        case 7:
            selectdic = self.names[0];
            break;
            
        default:
            break;
    }
}
/**
 *  点击取消按钮
 */
-(void)leftbtnselsct{
    [self removeFromSuperview];
}
/**
 *  点击确定按钮
 */
-(void)rightbtnselsct{
    if (scenariotype == 2) {
        NSString *str = [NSString stringWithFormat:@"%@℃ %@",select,select2];
        [self.thisbutton setTitle:str forState:UIControlStateNormal];
        [self.thisbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else if (scenariotype == 3){
        NSString *str = [NSString stringWithFormat:@"%@%@ %@",select,@"%",select2];
        [self.thisbutton setTitle:str forState:UIControlStateNormal];
        [self.thisbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else if (scenariotype == 4){
        NSString *str = [NSString stringWithFormat:@"%@ - %@",select,select2];
        [self.thisbutton setTitle:str forState:UIControlStateNormal];
        [self.thisbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }else if (scenariotype == 6){
        // 2.通知代理
        if ([self.mydelegate respondsToSelector:@selector(PickerDelegateSelectString:withDic:)]) {
            [self.mydelegate PickerDelegateSelectString:select withDic:selectdic];
        }
        
    } else if (scenariotype == 7) {
        if ([self.mydelegate respondsToSelector:@selector(PickerDelegateSelectString:withDic:)]) {
             [self.mydelegate PickerDelegateSelectString:select withDic:selectdic];
        }
    } else {
        NSString *str = [NSString stringWithFormat:@"%@H",select];
        [self.thisbutton setTitle:str forState:UIControlStateNormal];
        [self.thisbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    NSData *data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    NSArray *deletearr = arr[self.cellindex];
    NSMutableArray *newarr = [NSMutableArray new];
    
    NSMutableDictionary *dicOne = [NSMutableDictionary dictionaryWithDictionary:deletearr[0]];
    NSMutableDictionary *dicTwo = [NSMutableDictionary dictionaryWithDictionary:deletearr[1]];
    NSMutableDictionary *dicThree = [NSMutableDictionary dictionaryWithDictionary:deletearr[2]];
    NSMutableDictionary *dicFour = [NSMutableDictionary dictionaryWithDictionary:deletearr[3]];
    
        switch (self.thisbutton.tag) {
            case 22:
                [dicTwo setObject:select forKey:@"time"];
                break;
            case 33:
                [dicThree setObject:select forKey:@"time"];
                break;
            case 44:
                [dicFour setObject:select forKey:@"time"];
                break;
            case 99:
                [dicOne setObject:select forKey:@"time"];
                break;
            case 55:
                [dicTwo setObject:select forKey:@"value"];
                [dicTwo setObject:select2 forKey:@"rpoint"];
                break;
            case 66:
                [dicThree setObject:select forKey:@"value"];
                [dicThree setObject:select2 forKey:@"rpoint"];
                
                break;
            case 77:
                [dicFour setObject:select forKey:@"value"];
                [dicFour setObject:select2 forKey:@"rpoint"];
                
                break;
            default:
                break;
        }
    
    [newarr addObject:dicOne];
    [newarr addObject:dicTwo];
    [newarr addObject:dicThree];
    [newarr addObject:dicFour];
    
    [arr replaceObjectAtIndex:self.cellindex withObject:newarr];
    
    NSData *newdata = [NSKeyedArchiver archivedDataWithRootObject:arr];
    
    [NITUserDefaults setObject:newdata forKey:@"scenariodtlinfoarr"];
    
//    NITLog(@"nodesdic:%@",arr);
    //\U5c45\U5ba4\U5165\U53e3
    
//      [nodesdic setObject:dicnode forKey:self.model.nodeid];
//      [NITUserDefaults setObject:nodesdic forKey:@"sensorallnodes"];
//        
//    } else {
//        NSDictionary *dic = @{@"displayname":select,@"place":@""};
//        
//        [nodesdic setObject:dic forKey:self.model.nodeid];
//        [NITUserDefaults setObject:nodesdic forKey:@"sensorallnodes"];
//    }
    
    
    //    [self.delegate selecttitle:select tag:thistag];
//    NSData * data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
//    NSMutableArray * scenarioarr= [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    
//    for (int i = 0 ; i < scenarioarr.count ; i++) {
//        //NSMutableArray *modelarray = scenarioarr[i];
//        Device *device = [scenarioarr objectAtIndex:i];
//        if ([device.deviceid isEqualToString:_model.deviceid]) {
//            if (self.thisbutton.tag==11) {
//                device.deviceValue.time = @([select integerValue]);
//            }else if(self.thisbutton.tag==22){
//                device.deviceValue.time = @([select integerValue]);
//            }else if(self.thisbutton.tag==33){
//                device.deviceValue.value = @([select integerValue]);
//            }else if(self.thisbutton.tag==44){
//                device.deviceValue.rpoint = select;
//            }
//
////            NSMutableArray *modelarrays = [NSMutableArray array];
////            [modelarrays addObject:device];
//            [scenarioarr replaceObjectAtIndex:i withObject:device];
//        }
//    }
//    
//    NSData * datas = [NSKeyedArchiver archivedDataWithRootObject:scenarioarr];
//    [NITUserDefaults setObject:datas forKey:@"scenariodtlinfoarr"];
    
    
    [self removeFromSuperview];
}

#pragma mark - Picker view data source and delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (scenariotype == 2 || scenariotype == 3 ||scenariotype == 4) {
        return 2;
    } else {
        return 1;
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (scenariotype==0) {
        return self.names.count;
    }else if(scenariotype==1){
        return self.time.count;
    }else if(scenariotype == 2 || scenariotype == 3 ||scenariotype == 4){
        if (component == 0) {
            return self.value.count;
        } else {
            return self.type.count;
        }
    } else if(scenariotype==5) {
        return 0;
    } else {
        return self.names.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    
    if (!view) {
        view = [[UIView alloc]init];
    }
    view = [self pickerLabel:pickerView view:view row:row component:component];
    return view;
}

-(UIView*)pickerLabel:(UIPickerView *)pickerView view:(UIView*)view row:(NSInteger)row component:(NSInteger)component{
    UILabel *text = [[UILabel alloc]init];
    
    text.textColor = pickertextcolor;
    
    text.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    text.textAlignment = NSTextAlignmentCenter;
    
    if (scenariotype == 2 || scenariotype == 3 ||scenariotype == 4) {
        text.frame = pickerlabelframe;
//        if (scenariotype==0) {
//            text.text = self.time[row];
//        }else if(scenariotype==1){
//            text.text = self.value[row];
//        }else if(scenariotype==2){
//            text.text = self.type[row];
//        } else if(scenariotype==3) {
//            text.text = self.names[row];
//        } else if(scenariotype==4){
            if (component == 0) {
                text.text = self.value[row];
            } else {
                text.text = self.type[row];
            }
//        } else {
//            text.text = self.names[row];
        
        [view addSubview:text];
        return view;
    } else {
        text.frame = pickerlabelframe2;
        
//        if (scenariotype==0) {
//            text.text = self.names[row];
//        }else
        if(scenariotype==1){
            text.text = self.time[row];
        }  else if (scenariotype == 7){
            text.text = [self.names[row] objectForKey:@"displayname"];
            
        } else {
            text.text = self.names[row];
        }
        [view addSubview:text];
        return view;
    }
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    [_nitpicker viewForRow:row forComponent:component];

    if (scenariotype==0) {
        select = [self.names[row] objectForKey:@"displayname"];
    }else if(scenariotype==1){
        select = self.time[row];
    } else if(scenariotype == 2 || scenariotype == 3 ||scenariotype == 4){
        if (component == 0) {
            select = self.value[row];
        } else {
            select2 = self.type[row];
        }
    } else if(scenariotype==5) {
        select = @"";
    } else if (scenariotype == 7) {
        selectdic = self.names[row];
        
    } else {
        
        select = self.names[row];
    }
}

#pragma mark - 触摸
/**
 *  子控件超出父控件fram依旧响应点击事件
 */
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self){
        [self removeFromSuperview];
        return nil;
    }else{
        return [super hitTest:point withEvent:event];
    }
}
/**
 *  点击非本控件收起菜单
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    return YES;
}

#pragma mark - 懒加载

-(UIPickerView *)nitpicker{
    if (!_nitpicker) {
        //按钮
        _nitpicker = [[UIPickerView alloc]initWithFrame:nitpickerframe];
        _nitpicker.showsSelectionIndicator = YES;
        _nitpicker.delegate = self;
        _nitpicker.dataSource = self;
    }
    return _nitpicker;
}

-(UIButton *)leftbtn{
    if (!_leftbtn) {
        //按钮
        _leftbtn = [[UIButton alloc]initWithFrame:leftbuttonframe];
        _leftbtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [_leftbtn setTitle:@"キャンセル" forState:UIControlStateNormal];
        [_leftbtn setTitleColor:lefttitlecolor forState:UIControlStateNormal];
        [_leftbtn addTarget:self action:@selector(leftbtnselsct) forControlEvents:UIControlEventTouchDown];
    }
    return _leftbtn;
}

-(UIButton *)rightbtn{
    if (!_rightbtn) {
        //按钮
        _rightbtn = [[UIButton alloc]initWithFrame:rightbuttonframe];
        _rightbtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [_rightbtn setTitle:@"OK" forState:UIControlStateNormal];
        [_rightbtn setTitleColor:righttitlecolor forState:UIControlStateNormal];
        [_rightbtn addTarget:self action:@selector(rightbtnselsct) forControlEvents:UIControlEventTouchDown];
    }
    return _rightbtn;
}

-(CAShapeLayer *)pathlayer{
    if (!_pathlayer) {
        _pathlayer = [[CAShapeLayer alloc] init];
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(self.bounds.origin.x, self.bounds.size.height*0.8)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height*0.8)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height*0.8)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height*0.8)];
        [path closePath];
        _pathlayer.path = path.CGPath;
        _pathlayer.lineWidth = 0.5;
        _pathlayer.strokeColor = pathcolor;
    }
    return _pathlayer;
}

-(NSMutableArray *)type{
    if (!_type) {
        _type = [NSMutableArray arrayWithObjects:@"-",@"以上",@"以下", nil];
    }
    return _type;
}

-(NSMutableArray *)value{
    if (!_value) {
        if (scenariotype == 2) {
            _value = [NSMutableArray arrayWithArray:self.getdata];
        } else if (scenariotype == 3) {
            _value = [NSMutableArray arrayWithArray:self.getdata];
        } else {
            _value = [NSMutableArray arrayWithArray:self.getdata];
        }
        
    }
    return _value;
}

- (NSArray *)getdata {
    NSMutableArray *arr = [NSMutableArray new];
    [arr addObject:@"-"];
    for (int i = 0; i<100; i++) {
        [arr addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    return arr;
}

-(NSMutableArray *)time{
    if (!_time) {
        _time = [NSMutableArray new];
        [_time addObject:@"-"];
        for (int i = 1; i<48; i++) {
            [_time addObject:[NSString stringWithFormat:@"%.1f",i / 2.0]];
        }
    }
    return _time;
}

-(NSMutableArray *)names{
    if (!_names) {
        if (scenariotype == 6) {
            _names = [NSMutableArray arrayWithObjects:@"夜間活動",@"熱中症",@"活動なし", nil];
            
        } else {
           NSArray *arr = [[NITUserDefaults objectForKey:@"tempdeaddnodeiddatas"] copy];
            _names = arr.count > 0 ? [NSMutableArray arrayWithArray:arr] : [NSMutableArray new];
        }
    }
    return _names;
}

-(UIButton *)thisbutton{
    if (!_thisbutton) {
        _thisbutton = [UIButton new];
    }
    return _thisbutton;
}



@end
