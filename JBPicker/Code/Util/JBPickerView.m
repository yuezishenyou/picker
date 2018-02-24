//
//  JBPickerView.m
//  JBPicker
//
//  Created by maoziyue on 2018/2/24.
//  Copyright © 2018年 maoziyue. All rights reserved.
//

#import "JBPickerView.h"

#define kViewHeight      (260)
#define kScreenWidth         ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight         ([UIScreen mainScreen].bounds.size.height)
#define kColor(r, g, b)  [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]





@interface JBPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    CGFloat kHeight;
    CGFloat kWidth;
}
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIView *naviContainView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIPickerView *pickView;

@property (nonatomic, strong) UIButton *bgBtn;

@property (nonatomic, strong) UIView *mainView;

//
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSArray *dayArray;

@property (nonatomic, strong) NSArray *hourArray;

@property (nonatomic, strong) NSArray *minuteArray;

@property (nonatomic, strong) NSDateComponents *components;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *hour;

@property (nonatomic, copy) NSString *minute;

@property (nonatomic, strong) NSArray *dateArray;

@property (nonatomic, copy) NSString *dateString;

@property (nonatomic, copy) NSString *YYMMDD;

@property (nonatomic, strong) NSNumber *timestamp;

@end


@implementation JBPickerView


- (instancetype)initWithTimestamp:(NSNumber *)timestamp
{
    if (self = [super init]) {
        self.frame = [[UIScreen mainScreen]bounds];
        
        self.timestamp = timestamp;
        
        [self initData];
        [self setup];
    }
    return self;
}

- (void)initData
{
    //self.dataSource = [[NSMutableArray alloc]init];
}

- (void)setup
{
    [self addSubview:self.bgBtn];
    [self addSubview:self.mainView];
    
    [self.mainView addSubview:self.naviContainView];
    [self.naviContainView addSubview:self.cancelBtn];
    [self.naviContainView addSubview:self.titleLabel];
    [self.naviContainView addSubview:self.confirmBtn];
    [self.mainView addSubview:self.pickView];
    
    
    [self.bgBtn setFrame:[[UIScreen mainScreen]bounds]];
    
    
    
//    if (IsIPhone)
//    {
    
        kWidth = kScreenWidth;
        kHeight = kViewHeight;
        
        [self.mainView setFrame:CGRectMake(0, kScreenHeight, kWidth, kHeight)];
        
        [self.naviContainView setFrame:CGRectMake(0, 0, kWidth, 44)];
        [self.cancelBtn setFrame:CGRectMake(12, 0, 80, 44)];
        [self.confirmBtn setFrame:CGRectMake(kWidth - 80, 0, 80, 44)];
        [self.titleLabel setFrame:CGRectMake((kWidth - 120)/2, 0, 120, 44)];
        [self.pickView setFrame:CGRectMake(0, 44, kWidth, kHeight - 44)];
//    }
//    else
//    {
//
//        kWidth = kScreenWidth;
//        kHeight = kiPadRatio(350);
//
//        [self.mainView setFrame:CGRectMake(0, kScreenHeight, kWidth, kHeight)];
//
//        [self.naviContainView setFrame:CGRectMake(0, 0, kWidth, 44)];
//        [self.cancelBtn setFrame:CGRectMake(12, 0, 80, 44)];
//        [self.confirmBtn setFrame:CGRectMake(kWidth - 80, 0, 80, 44)];
//        [self.titleLabel setFrame:CGRectMake((kWidth - 120)/2, 0, 120, 44)];
//        [self.pickView setFrame:CGRectMake(0, 44, kWidth, kHeight - 44)];
//    }
    

    //[self.pickView reloadAllComponents];
    
}


- (void)show
{
    [self setDate];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.bgBtn.alpha = 0.3;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.mainView.frame;
        rect.origin.y = kScreenHeight - rect.size.height;
        self.mainView.frame = rect;
    }];
}



- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.mainView.frame;
        rect.origin.y = kScreenHeight;
        self.mainView.frame = rect;
        self.bgBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dismissAction{
    
}


#pragma mark - private methods

- (void)cancelAction:(UIButton *)btn
{
    [self dismiss];
}

- (void)confirmAction:(UIButton *)btn
{
    NSInteger component0_row = [self.pickView selectedRowInComponent:0];
    
    NSInteger component1_row = [self.pickView selectedRowInComponent:1];
    
    NSInteger component2_row = [self.pickView selectedRowInComponent:2];
    

    self.date = self.dayArray[component0_row];
    
    self.dateString = self.dateArray[component0_row];
    
    if (component1_row < self.hourArray.count) {
        self.hour = self.hourArray[component1_row];
    }
    
    if (component2_row < self.minuteArray.count ) {
        self.minute = self.minuteArray[component2_row];
    }
        

    
    if (self.completionBlock)
    {

        
        self.YYMMDD = self.dateArray[component0_row];
        
        NSString *dateString = [NSString stringWithFormat:@"%@ %@:%@:00",self.YYMMDD,self.hour,self.minute];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
        NSDate *date = [dateFormatter dateFromString:dateString];
        
        long long timestamp = [date timeIntervalSince1970] *1000;
        
        NSNumber *timesp = @(timestamp);
        
        self.completionBlock(self.YYMMDD, self.hour,  self.minute, self.date, timesp);
        
    }
    
    [self dismiss];
    
}











- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    [self.pickView selectRow:row inComponent:component animated:animated];
}

- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    return [self.pickView selectedRowInComponent:component];
}

#pragma mark - UIPickViewDelegate, UIPickViewDataSource


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return kWidth / 2 * 1;
    }
    else
    {
        return kWidth / 4;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.dayArray.count;
    }
    else if (component == 1)
    {
        return self.hourArray.count;
    }
    else
    {
        return self.minuteArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.dayArray[row];
    }
    else if (component == 1)
    {
        return [NSString stringWithFormat:@"%@", self.hourArray[row]];
    }
    else
    {
        return [NSString stringWithFormat:@"%@", self.minuteArray[row]
                ];
        
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    //NSLog(@"----didSelectRow:%ld  component:%ld---",row,component);
    
    if (component == 0 )
    {
        NSInteger component1_row = [self.pickView selectedRowInComponent:1];
        
        if (row == 0 && component1_row == 0)
        {
            [self setHoursWithRow:row];
            [self setMinutesWithRow:row hour:self.components.hour];
        }
        else
        {
            [self setHoursWithRow:row];
            [self setMinutesWithRow:row hour:-1];
        }

        
        [self.pickView reloadComponent:1];
        [self.pickView reloadComponent:2];
        
   
        
    }
    else if (component == 1)
    {
        NSInteger component0_row = [self.pickView selectedRowInComponent:0];

        if (component0_row == 0  && row == 0)
        {
            [self setMinutesWithRow:row hour:self.components.hour];
        }
        else
        {
            [self setMinutesWithRow:row hour:-1];
        }
        
        [self.pickView reloadComponent:2];
        
        
    }
    else if (component == 2)
    {
        
    }
    
    

    
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return nil;
}









#pragma mark --util
- (void)setDate
{
    NSDate *date = [NSDate date];
    
    NSMutableArray *dayArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger oldMonth = -1;
    NSInteger oldDay = -1;
    NSInteger oldHour = -1;
    NSInteger oldMinute = -1;
    
    if (self.timestamp && [self.timestamp longLongValue] > 0)
    {
        NSDate *oldDate = [NSDate dateWithTimeIntervalSince1970:[self.timestamp longLongValue] / 1000];
        
        self.components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay fromDate:oldDate];
        
        oldMonth = self.components.month;
        oldDay = self.components.day;
        oldHour = self.components.hour;
        oldMinute = self.components.minute;
        
        //NSLog(@"-----赋值--components:%@--------------",self.components);
    }

    
    
    self.components =  [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay fromDate:date];
    
    if (self.components.hour == 0 && self.components.minute < 30 )
    {//
        NSString *weak = [self week:self.components.weekday];
        
        NSString *MMDD = [NSString stringWithFormat:@"%ld月%ld日 %@",self.components.month,self.components.day,weak];
        
        NSString *YYMMDD = [NSString stringWithFormat:@"%04ld-%02ld-%02ld",self.components.year, self.components.month, self.components.day];
        
        [dayArray addObject:MMDD];
        
        [dateArray addObject:YYMMDD];
        
    }
    else
    {
        NSString *MMDD = [NSString stringWithFormat:@"%ld月%ld日 今天",self.components.month, self.components.day];
        
        NSString *YYMMDD = [NSString stringWithFormat:@"%04ld-%02ld-%02ld",self.components.year, self.components.month, self.components.day];
        
        [dayArray addObject:MMDD];
        
        [dateArray addObject:YYMMDD];
    }
    
    for (int i = 0; i < 4; i++)
    {
        
        NSDate *future = [NSDate dateWithTimeIntervalSinceNow:1800 + 24 * 60 * 60 *(i + 1)]; //1800 + 24 * 60 * 60 *(i + 1)
        
        self.components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay fromDate:future];
        
        NSString *weak = [self week:self.components.weekday];
        
        NSString *MMDD = [NSString stringWithFormat:@"%ld月%ld日 %@",self.components.month, self.components.day,weak];
        
        NSString *YYMMDD = [NSString stringWithFormat:@"%04ld-%02ld-%02ld",self.components.year, self.components.month, self.components.day];
        
        [dayArray addObject:MMDD];
        
        [dateArray addObject:YYMMDD];
        
    }
    
    
    self.components =  [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay fromDate:date];
    
    self.dateArray = dateArray;
    
    self.dayArray = dayArray;
    
    self.date = self.dayArray.firstObject;
    
    [self setHoursWithRow:0];
    
    [self setMinutesWithRow:0 hour:self.components.hour];
    
    
    
    
    
    //
    if (oldMonth > 0)
    {
        NSInteger component0_row = 0;
        NSInteger component1_row = 0;
        NSInteger component2_row = 0;
        
        for (int i = 0; i < self.dayArray.count ; i++)
        {
            NSString *day = self.dayArray[i];
            if ([day containsString:[NSString stringWithFormat:@"%ld月%ld日",oldMonth,oldDay]])
            {
                component0_row = i;
                
                [self setHoursWithRow:component0_row];
                
                if (component0_row == 0)
                {
                    [self setMinutesWithRow:component0_row hour:self.components.hour];
                }
                else
                {
                    [self setMinutesWithRow:component0_row hour:-1];
                }

                break;
            }
        }
        
        
        for (int i = 0; i < self.hourArray.count; i++)
        {
            NSString *hour = self.hourArray[i];
            if ([hour containsString:[NSString stringWithFormat:@"%ld",oldHour]])
            {
                component1_row = i;
                
                break;
            }
        }
        
        for (int i = 0; i < self.minuteArray.count; i++)
        {
            NSString *minute = self.minuteArray[i];
            
            if ([minute containsString:[NSString stringWithFormat:@"%ld",oldMinute]])
            {
                component2_row = i;
                
                break;
            }
        }

        
        [self.pickView reloadAllComponents];
        [self.pickView selectRow:component0_row inComponent:0 animated:NO];
        [self.pickView selectRow:component1_row inComponent:1 animated:NO];
        [self.pickView selectRow:component2_row inComponent:2 animated:NO];
    }
    else
    {
        [self.pickView reloadAllComponents];
        [self.pickView selectRow:0 inComponent:0 animated:NO];
        [self.pickView selectRow:0 inComponent:1 animated:NO];
        [self.pickView selectRow:0 inComponent:2 animated:NO];
    }
 
}







// 判断是星期几
- (NSString *)week:(NSInteger)week
{
    NSString *str = @"周";
    switch (week) {
        case 1:
            return [NSString stringWithFormat:@"%@日", str];
        case 2:
            return [NSString stringWithFormat:@"%@一", str];
        case 3:
            return [NSString stringWithFormat:@"%@二", str];
        case 4:
            return [NSString stringWithFormat:@"%@三", str];
        case 5:
            return [NSString stringWithFormat:@"%@四", str];
        case 6:
            return [NSString stringWithFormat:@"%@五", str];
        case 7:
            return [NSString stringWithFormat:@"%@六", str];
        default:
            return @"";
            
    }
}

- (void)setHoursWithRow:(NSInteger)row
{
    if (row == 0)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (NSInteger i = self.components.hour; i <= 23; i++)
        {
            [arr addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
        }
        self.hourArray = arr;
    }
    else
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i <= 23; i++) {
            [arr addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
        }
        self.hourArray = arr;
        
    }
    self.hour = self.hourArray.firstObject;
    
}

- (void)setMinutesWithRow:(NSInteger)row hour:(NSInteger) hour
{
    if (row == 0 && hour == self.components.hour)
    {
        NSInteger temp = self.components.minute % 5;
        NSInteger i;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        if (temp != 0)
        {
            i = self.components.minute + (5 - temp);
            if (i >= 60) {
                i = 0;
            }
        }else {
            i = self.components.minute;
        }
        
        for (NSInteger j = i; j <= 55; j= j + 5) {
            [arr addObject:[NSString stringWithFormat:@"%02ld", j]];
        }
        self.minuteArray = arr;
    }else{
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (NSInteger j = 0; j <= 55; j= j + 5) {
            [arr addObject:[NSString stringWithFormat:@"%02ld", j]];
        }
        self.minuteArray = arr;
    }
    self.minute = self.minuteArray.firstObject;

}
























#pragma mark - lazy

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:kColor(85, 85, 85) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn sizeToFit];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:kColor(255, 126, 0) forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_confirmBtn sizeToFit];
        
    }
    return _confirmBtn;
}

- (UIView *)naviContainView {
    if (!_naviContainView) {
        _naviContainView = [[UIView alloc] init];
        _naviContainView.backgroundColor = [UIColor whiteColor];
    }
    return _naviContainView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIPickerView *)pickView {
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] init];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

- (UIButton *)bgBtn {
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] init];
        _bgBtn.backgroundColor = [UIColor blackColor];
        _bgBtn.alpha = 0.3;
        [_bgBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor whiteColor];
    }
    return _mainView;
}



- (void)dealloc
{
    //NSLog(@"----air 释放------");
}










@end
