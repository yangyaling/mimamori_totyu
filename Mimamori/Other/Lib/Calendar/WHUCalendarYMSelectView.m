//
//  WHUCalendarYMSelectView.m
//  TEST_Calendar
//
//  Created by NISSAY IT on 15/11/6.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//
#import "WHUCalendarYMSelectView.h"
#define WHUCalendarYMSelectView_Piker_Height 150.0f
#define WHUCalendarYMSelectView_Margin 10.0f
@interface WHUCalendarYMSelectView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong) UIPickerView* pickerView;
@property(nonatomic,strong) NSArray* monthArr;
@property(nonatomic,strong) NSArray* yearArr;
@property(nonatomic,assign) NSInteger curYear;
@property(nonatomic,assign) NSInteger yearRange;

@property(nonatomic,assign) NSInteger yearnum;
@property(nonatomic,assign) NSInteger monthnum;
@end
@implementation WHUCalendarYMSelectView

+ (instancetype)currentYear:(NSInteger)year withMonth:(NSInteger)month {
    
    WHUCalendarYMSelectView *view = [[WHUCalendarYMSelectView alloc] initWithFrame:CGRectZero andyear:year withmonth:month];
    return view;
}

-(id)initWithFrame:(CGRect)frame andyear:(NSInteger)year withmonth:(NSInteger)month{
    self=[super initWithFrame:frame];
    if(self){
        self.yearnum = year;
        self.monthnum = month;
        [self setupViews];
    }
    return self;
}

//-(id)initWithCoder:(NSCoder *)aDecoder{
//   self= [super initWithCoder:aDecoder];
//    if(self){
//        [self setupViews];
//    }
//    return self;
//}

-(void)setupViews{
    _yearRange=20;
    _pickerView=[[UIPickerView alloc] init];
    _pickerView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_pickerView];
    _pickerView.showsSelectionIndicator=YES;
    _pickerView.delegate=self;
    NSDictionary* viewDic=@{
                            @"picker":_pickerView
                            };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[picker]|" options:0 metrics:nil views:viewDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[picker]|" options:0 metrics:nil views:viewDic]];
    NSCalendar* cal=[NSCalendar currentCalendar];
    NSDateComponents* com=[cal components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
    self.curYear=com.year;
    [_pickerView selectRow:_yearnum-1995 inComponent:0 animated:NO];
    [_pickerView selectRow:_monthnum-1 inComponent:1 animated:NO];
}


-(NSString*)selectdDateStr{
  NSInteger year=2015-_yearRange+[_pickerView selectedRowInComponent:0];
  NSInteger month=[_pickerView selectedRowInComponent:1]+1;
  return [NSString stringWithFormat:@"%ld年%ld月",(long)year,(long)month];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 41;
    }
    
    return 12;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if(component==0){
        return pickerView.frame.size.width/2.0f;
    }
    else{
        return pickerView.frame.size.width/3.0f;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        row=2015-_yearRange+row;
        return  [NSString stringWithFormat:@"%ld年",(long)row];
    } else {
        return  [NSString stringWithFormat:@"%ld月",(long)row+1];
    }
}
@end
