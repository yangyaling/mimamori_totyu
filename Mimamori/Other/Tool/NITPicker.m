//
//  NITPicker.m
//  LGFPicker
//
//  Created by NISSAY IT on 16/8/4.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#define bgcolor [UIColor whiteColor]
#define pickertextcolor [UIColor blackColor]
#define righttitlecolor [UIColor colorWithRed:12.0/255.0 green:10.0/255.0 blue:12.0/255.0 alpha:1.0]
#define lefttitlecolor [UIColor colorWithRed:255.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1.0]
#define pathcolor [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0].CGColor


#define realframe CGRectMake(self.frame.origin.x-120, self.frame.origin.y-120, self.frame.size.width+240, self.frame.size.height+160)
#define pickerlabelframe CGRectMake(0, 0,_nitpicker.frame.size.width / 2.0,30)

#define pickerlabelframe2 CGRectMake(0, 0,_nitpicker.frame.size.width,30)

#define pickerlabelframe3 CGRectMake(0, 0,_nitpicker.frame.size.width / 4.0, 30)

#define nitpickerframe CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height*0.8)
#define leftbuttonframe CGRectMake(self.bounds.origin.x, self.bounds.size.height*0.8, self.bounds.size.width/2, self.bounds.size.height*0.2)
#define rightbuttonframe CGRectMake(self.bounds.size.width/2, self.bounds.size.height*0.8, self.bounds.size.width/2, self.bounds.size.height*0.2)

#import "NITPicker.h"
#import "Device.h"

@interface NITPicker()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString*select;
    NSString*select2;
    NSString*select3;
    NSString*select4;
    NSDictionary *selectdic;
    int scenariotype;
}
@property (nonatomic, strong) UIPickerView             *nitpicker;

@property (nonatomic, strong) UIButton                 *leftbtn; //キャンセルボタン

@property (nonatomic, strong) UIButton                 *rightbtn; //確認ボタン

@property (nonatomic, strong) CAShapeLayer             *pathlayer;  //角丸せん断

@property (nonatomic, strong) NSMutableArray           *onedayHours;  //一日の時間配列
@property (nonatomic, strong) NSMutableArray           *onedayMinute; //一日の分間配列

@property (nonatomic, strong) NSMutableArray           *userList;     //見守る人のリスト
@property (nonatomic, strong) NSMutableArray           *custList;     //見守られる人のリスト
@property (nonatomic, strong) NSMutableArray           *roomList;     //居室のリスト
@property (nonatomic, strong) NSMutableArray           *custidList;   //見守られるIDのリスト


@property (nonatomic, strong) NSMutableArray           *time;
@property (nonatomic, strong) NSMutableArray           *value;
@property (nonatomic, strong) NSMutableArray           *type;
@property (nonatomic, strong) NSMutableArray           *names;

@property (nonatomic, strong) UIButton                 *thisbutton;   //届けのボタン


@property (nonatomic, strong) NSArray                  *models;   //届けの配列

@property (nonatomic, assign) NSInteger                cellindex;   //リレーが入ってきたセル標識

@end
@implementation NITPicker


-(instancetype)initWithFrame:(CGRect)frame superviews:(UIView*)superviews selectbutton:(UIButton*)selectbutton model:(NSArray *)model cellNumber:(NSInteger)number {
    self = [super initWithFrame:frame];
    if (self) {
        //ボタンマーク
        switch (selectbutton.tag) {
            case 99:
                scenariotype =0;
                break;
            case 22:
            case 33:
            case 44:
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
            case 111:
                scenariotype =8;
                break;
            case 112:
                scenariotype =9;
                break;
            case 113:
                scenariotype =10;
                break;
            case 114:
                scenariotype =11;
                break;
            case 115:
                scenariotype =12;
                break;
            case 116:
                scenariotype =13;
                break;
            case 117:
                scenariotype =14;
                break;
                
            default:
                break;
        }
        
        self.cellindex = number;
        self.thisbutton = selectbutton;
        self.models = model.copy;
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

//初期設定データ
-(void)commonInit{
    
  
    self.frame = realframe;
    
    //コントロールを追加
    [self addcontrol];
}


/**
 *  コントロールを追加
 */
-(void)addcontrol{
    
    [self addSubview:self.nitpicker];
    [self addSubview:self.leftbtn];
    [self addSubview:self.rightbtn];
    [self.layer addSublayer:self.pathlayer];
    [self defaultselect];//默认选中
    
}
/**
 *デフォルト選択
 */
-(void)defaultselect{
    
    switch (scenariotype) {
        case 0:
            select = self.time[0];
            break;
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
            select = @"0";
            selectdic = [self.names[0] firstObject];
            break;
        case 7:
            select = [self.names[0] objectForKey:@"displayname"];
            selectdic = self.names[0];
            break;
        case 8:
            select = self.names[0];
            break;
        case 9:
            select = [self.names[0] objectForKey:@"name"];
            selectdic = self.names[0];
            break;
        case 10:
            select = self.onedayHours[0];
            select2 = self.onedayMinute[0];
//            select3 = self.onedayHours[0];
//            select4 = self.onedayMinute[0];
            break;
            
        case 11:
            select = [self.userList[0] objectForKey:@"name"];
            selectdic = self.userList[0];
            break;
        case 12:
            
            select = [NSString stringWithFormat:@"%@", [self.custList[0] objectForKey:@"floorno"]];
            selectdic = self.custList[0];
            break;
        case 13:
            select = [self.roomList[0] objectForKey:@"roomcd"];
            selectdic = self.roomList[0];
            break;
        case 14:
            select = [self.custidList[0] objectForKey:@"custid"];
            selectdic = self.custidList[0];
            break;
            
        default:
            break;
    }
}
/**
 *  コントロールを除去する
 */
-(void)leftbtnselsct{
    [self removeFromSuperview];
}

/**
 *  種類の違いによって
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
        
    } else if (scenariotype == 6 || scenariotype == 7 || scenariotype == 8 || scenariotype == 12 || scenariotype == 14) {
        
        if ([self.mydelegate respondsToSelector:@selector(PickerDelegateSelectString:withDic:)]) {
            
             [self.mydelegate PickerDelegateSelectString:select withDic:selectdic];
        }
        
    } else if (scenariotype == 10) {
        NSString *str = [NSString stringWithFormat:@"%@%@",select,select2];
        [self.thisbutton setTitle:str forState:UIControlStateNormal];
        [self.thisbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else  if (scenariotype == 0 || scenariotype == 1) {
        NSString *str = [NSString stringWithFormat:@"%@H",select];
        [self.thisbutton setTitle:str forState:UIControlStateNormal];
        [self.thisbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        NSString *str = [NSString stringWithFormat:@"%@",select];
        [self.thisbutton setTitle:str forState:UIControlStateNormal];
        [self.thisbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if (scenariotype == 0  || scenariotype == 1  || scenariotype == 2 || scenariotype == 3 || scenariotype == 4 || scenariotype == 8 ) {
        
        
        //シナリオ  ->異なる押しボタンのデータ更新
        
        
        BOOL ison = NO;
        if (scenariotype == 8) {
            if ([select isEqualToString:@"使用あり"] || [select isEqualToString:@"反応あり"]) {
                ison = YES;  //アリ状態によると  選択できる時間帯 更新
            }
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
            case 111:
                [dicOne setObject:ison ? @"0" : @"-" forKey:@"time"];
                [dicOne setObject:@"0" forKey:@"value"];
                [dicOne setObject:select forKey:@"rpoint"];
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
        
        
    } else if(scenariotype == 9) {
       
        //ノード関係のデータ更新
        
        NSMutableDictionary *mainnodesdic = [NSMutableDictionary dictionaryWithDictionary:[NITUserDefaults objectForKey:@"mainondedatakey"]];
        [mainnodesdic setValue:select forKey:@"mainnodename"];
        [NITUserDefaults setObject:mainnodesdic forKey:@"mainondedatakey"];
        
        
        //
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"sensorallnodes"]]];
        
       
        
        NSMutableDictionary *nodesdic = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:self.cellindex]];
        
        [nodesdic setValue:selectdic[@"cd"] forKey:@"displaycd"];
        [nodesdic setValue:select forKey:@"displayname"];
        [arr replaceObjectAtIndex:self.cellindex withObject:nodesdic];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
        [NITUserDefaults setObject:data forKey:@"sensorallnodes"];
        
    } else if (scenariotype == 11) {
        
         //スタッフ情報のデータ更新
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"STAFFINFO"]];
        
        NSMutableDictionary *nodesdic = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:self.cellindex]];
        
        [nodesdic setValue:selectdic[@"cd"] forKey:@"usertype"];
        
        [nodesdic setValue:selectdic[@"name"] forKey:@"usertypename"];
        
        [arr replaceObjectAtIndex:self.cellindex withObject:nodesdic];
        
        [NITUserDefaults setObject:arr forKey:@"STAFFINFO"];
        
    } else if (scenariotype == 12){
        //スタッフ情報のデータ更新
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"HOMECUSTINFO"]];
        
        NSMutableDictionary *nodesdic = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:self.cellindex]];
        
        [nodesdic setValue:select forKey:@"floorno"];
        
        
        [arr replaceObjectAtIndex:self.cellindex withObject:nodesdic];
        
        [NITUserDefaults setObject:arr forKey:@"HOMECUSTINFO"];
        
    } else if (scenariotype == 13) {
        
        //居室コード 更新
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"HOMECUSTINFO"]];
        
        NSMutableDictionary *nodesdic = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:self.cellindex]];
        
        [nodesdic setValue:select forKey:@"roomcd"];
        
        [arr replaceObjectAtIndex:self.cellindex withObject:nodesdic];
        
        [NITUserDefaults setObject:arr forKey:@"HOMECUSTINFO"];
        
    } else if (scenariotype == 14) {
        
    } else {
        
    }
    
    
    
    [self removeFromSuperview];
}

#pragma mark - Picker view data source and delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (scenariotype == 2 || scenariotype == 3 ||scenariotype == 4) {
        return 2;
        
    } else if (scenariotype == 10){
        return 4;
    } else {
        return 1;
    }
    
}


/**
セレクタ1列に1列の個数
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if(scenariotype==0 || scenariotype == 1){
        return self.time.count;
    }else if(scenariotype == 2 || scenariotype == 3 ||scenariotype == 4){
        if (component == 0) {
            return self.value.count;
        } else {
            return self.type.count;
        }
    } else if(scenariotype==5) {
        return 0;
    } else if (scenariotype == 10) {
        
        if (component == 0) {
            
            return 0;
            
        } else if (component == 1) {
            
            return self.onedayHours.count;
            
            
        } else if (component == 2) {
            
            return self.onedayMinute.count;
            
        } else {
            return 0;
        }
    }else if (scenariotype == 11) {
        
        return self.userList.count;
        
    } else if (scenariotype == 12) {
        
        return self.custList.count;
        
    } else if (scenariotype == 13) {
        
        return self.roomList.count;
        
    } else if (scenariotype == 14) {
        
        return self.custidList.count;
        
    }
    else {
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


/**
 セレクタはどのくらい
 */
-(UIView*)pickerLabel:(UIPickerView *)pickerView view:(UIView*)view row:(NSInteger)row component:(NSInteger)component{
    UILabel *text = [[UILabel alloc]init];
    
    text.textColor = pickertextcolor;
    
    text.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    text.textAlignment = NSTextAlignmentCenter;
    
    if (scenariotype == 2 || scenariotype == 3 ||scenariotype == 4) {
        text.frame = pickerlabelframe;
        
            if (component == 0) {
                
                text.text = self.value[row];
                
            } else {
                
                text.text = self.type[row];
                
            }
        
        
        [view addSubview:text];
        
        return view;
        
    } else if (scenariotype == 10) {
        
        text.frame = pickerlabelframe3;
        
        if (component  == 1) {
            
            text.text = self.onedayHours[row];
            
        } else if (component  == 2) {
            
            text.text = self.onedayMinute[row];
            
        }
        
        [view addSubview:text];
        
        return view;
    } else {
        text.frame = pickerlabelframe2;
        
        if(scenariotype==0 || scenariotype == 1){
            
            text.text = self.time[row];
            
        }else if (scenariotype == 6) {
            
            text.text = [[self.names[row] firstObject] objectForKey:@"protoname"];
            
        } else if (scenariotype == 7){
            
            text.text = [self.names[row] objectForKey:@"displayname"];
            
        }else if(scenariotype == 9){
            text.text = [self.names[row] objectForKey:@"name"];
        } else if(scenariotype == 11){
            text.text = [self.userList[row] objectForKey:@"name"];
        } else if(scenariotype == 12){
            NSString *str  = [NSString stringWithFormat:@"%@", [self.custList[row] objectForKey:@"floorno"]];
            text.text = str;
        } else if(scenariotype == 13) {
            text.text = [self.roomList[row] objectForKey:@"roomcd"];
        } else if(scenariotype == 14) {
            text.text = [self.custidList[row] objectForKey:@"custid"];
        }else {
            text.text = self.names[row];
        }
        [view addSubview:text];
        return view;
    }
    
    
}



/**
 セレクタ 現在表示の対象

 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    [_nitpicker viewForRow:row forComponent:component];

    selectdic = nil;
    
     if(scenariotype==0 || scenariotype == 1){
        select = self.time[row];
    } else if(scenariotype == 2 || scenariotype == 3 ||scenariotype == 4){
        if (component == 0) {
            select = self.value[row];
        } else {
            select2 = self.type[row];
        }
    } else if(scenariotype==5) {
        select = @"";
    } else if (scenariotype == 6) {
        select = [NSString stringWithFormat:@"%ld",row];
        NSArray *arr = self.names[row];
        selectdic = [arr.firstObject copy];
    } else if (scenariotype == 7) {
        selectdic = self.names[row];
        select = [self.names[row] objectForKey:@"displayname"];
    } else if (scenariotype == 10) {
        switch (component) {
            case 1:
                select = self.onedayHours[row];
                break;
            case 2:
                select2 = self.onedayMinute[row];
                break;
//            case 2:
//                select3 = self.onedayHours[row];
//                break;
//            case 3:
//                select4 = self.onedayMinute[row];
//                break;
            
            default:
                break;
        }

        
    } else if(scenariotype == 9){
    
        selectdic = self.names[row];
        select = [self.names[row] objectForKey:@"name"];
        
    }else if(scenariotype == 11){
        
        selectdic = self.userList[row];
        select = [self.userList[row] objectForKey:@"name"];
        
    } else if(scenariotype == 12){
        
        selectdic = self.custList[row];

        NSString *str  = [NSString stringWithFormat:@"%@", [self.custList[row] objectForKey:@"floorno"]];
        
        select = str;
        
    } else if(scenariotype == 13){
        selectdic = self.roomList[row];
        select = [self.roomList[row] objectForKey:@"roomcd"];
    } else if(scenariotype == 14){
        selectdic = self.custidList[row];
        select = [self.custidList[row] objectForKey:@"custid"];
    }
    else{
        select = self.names[row];
    }
}

#pragma mark -
/**
 *タッチコントロール以外の部分
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
 *  隠しメニュー
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    return YES;
}

#pragma mark -

-(UIPickerView *)nitpicker{
    if (!_nitpicker) {
      
        _nitpicker = [[UIPickerView alloc]initWithFrame:nitpickerframe];
        _nitpicker.showsSelectionIndicator = YES;
        _nitpicker.delegate = self;
        _nitpicker.dataSource = self;
    }
    return _nitpicker;
}

-(UIButton *)leftbtn{
    if (!_leftbtn) {
       
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
        
        if (scenariotype == 0) {
            
            if (self.models.count > 0) {
                
                for (int i = 1; i<48; i++) {
                    [_time addObject:[NSString stringWithFormat:@"%.1f",i / 2.0]];
                }
            } else {
                [_time addObject:@"0"];
            }
            
        } else {
            for (int i = 1; i<48; i++) {
                [_time addObject:[NSString stringWithFormat:@"%.1f",i / 2.0]];
            }
        }
    }
    return _time;
}


-(NSMutableArray *)onedayHours {
    if (!_onedayHours) {
        _onedayHours = [NSMutableArray new];
        [_onedayHours addObject:@"-"];
        for (int i = 0; i<24; i++) {
            if (i<10) {
                [_onedayHours addObject:[NSString stringWithFormat:@"0%d:",i]];
            } else {
                [_onedayHours addObject:[NSString stringWithFormat:@"%d:",i]];
            }
        }
    }
    return _onedayHours;
}


-(NSMutableArray *)onedayMinute {
    if (!_onedayMinute) {
        _onedayMinute = [NSMutableArray new];
        [_onedayMinute addObject:@"-"];
        for (int i = 0; i<60; i++) {
            if (i<10) {
                [_onedayMinute addObject:[NSString stringWithFormat:@"0%d",i]];
            } else {
                [_onedayMinute addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
    }
    return _onedayMinute;
}

-(NSMutableArray *)names{
    
    if (!_names) {
        
        if (scenariotype == 6) {
            
            _names = self.models.count > 0 ? [NSMutableArray arrayWithArray:self.models] : [NSMutableArray new];
//            _names = [NSMutableArray arrayWithObjects:@"夜間活動",@"熱中症",@"活動なし", nil];
            
        } else if (scenariotype == 8) {
            NSData *data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
            NSDictionary *dicOne = [arr[self.cellindex] firstObject];
            //门 - 人感
            if ([dicOne[@"nodetype"] integerValue] == 2) {
                _names = [NSMutableArray arrayWithObjects:@"-",@"使用あり",@"使用なし", nil];
            } else {
                _names = [NSMutableArray arrayWithObjects:@"-",@"反応あり",@"反応なし", nil];
            }
            
        } else if (scenariotype == 9) {
            NSArray *arr = [NITUserDefaults objectForKey:@"tempdisplaylist"];
            _names = [NSMutableArray arrayWithArray:arr];
            
        } else {
            
           NSArray *arr = [[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"tempdeaddnodeiddatas"]]copy];
            _names = arr.count > 0 ? [NSMutableArray arrayWithArray:arr] : [NSMutableArray new];
            
        }
        
    }
    return _names;
}

-(NSMutableArray *)userList {
    if (!_userList) {
        NSArray *arr = [NITUserDefaults objectForKey:@"usertypelist"];
        NSMutableArray *tmparr = [NSMutableArray arrayWithArray:arr];
        NSString *usert = USERTYPE;
        if ([usert isEqualToString:@"2"] && tmparr.count > 2) {
            [tmparr removeObjectAtIndex:0];
            _userList = tmparr.count > 0 ? [NSMutableArray arrayWithArray:tmparr] :[NSMutableArray new];
        } else {
            _userList = arr.count > 0 ? [NSMutableArray arrayWithArray:arr] :[NSMutableArray new];
        }
    
        
    }
    return _userList;
}

-(NSMutableArray *)custList {
    if (!_custList) {
        NSArray *arr = [NITUserDefaults objectForKey:@"FLOORLISTKEY"];
        _custList = arr.count > 0 ? [NSMutableArray arrayWithArray:arr] :[NSMutableArray new];
    }
    return _custList;
}

-(NSMutableArray *)roomList {
    if (!_roomList) {
        NSArray *arr = [NITUserDefaults objectForKey:@"ROOMLISTKEY"];
        _roomList = arr.count > 0 ? [NSMutableArray arrayWithArray:arr] :[NSMutableArray new];
    }
    return _roomList;
}

-(NSMutableArray *)custidList {
    if (!_custidList) {
        
        NSArray *arr = [NITUserDefaults objectForKey:@"custidlist"];
        _custidList = arr.count > 0 ? [NSMutableArray arrayWithArray:arr] :[NSMutableArray new];
        
    }
    return _custidList;
}

//HOMECUSTINFO
//朝-昼-夜

-(UIButton *)thisbutton{
    if (!_thisbutton) {
        _thisbutton = [UIButton new];
    }
    return _thisbutton;
}



@end
