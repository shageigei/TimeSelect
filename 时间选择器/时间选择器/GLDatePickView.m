//
//  GLDatePickView.m
//  时间选择器
//
//  Created by lang on 2017/10/18.
//  Copyright © 2017年 lang. All rights reserved.
//

#import "GLDatePickView.h"
#import "GLDatePickView+Addition.h"

@interface GLDatePickView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) UIView *dataView;                 /*!< 容器view*/
@property (strong, nonatomic) UIPickerView *pickerView;         /*!< 选择器*/
@property (strong, nonatomic) UIView *toolView;                 /*!< 工具条*/
@property (strong, nonatomic) UILabel *titleLbl;                /*!< 标题*/

@property (strong, nonatomic) NSMutableArray *dataArray;        /*!< 数据源*/
@property (copy, nonatomic)   NSString *selectStr;              /*!< 选中的时间*/
@property (copy, nonatomic)   NSString *currentDateStr;         /*!< 当前时间*/


@property (strong, nonatomic) NSMutableArray *yearArr;          /*!< 年数组*/
@property (strong, nonatomic) NSMutableArray *monthArr;         /*!< 月数组*/
@property (strong, nonatomic) NSMutableArray *dayArr;           /*!< 日数组*/
@property (strong, nonatomic) NSMutableArray *hourArr;          /*!< 时数组*/
@property (strong, nonatomic) NSMutableArray *minuteArr;        /*!< 分数组*/
@property (strong, nonatomic) NSArray *timeArr;                 /*!< 当前时间数组*/

@property (copy, nonatomic)   NSString *year;                   /*!< 选中年*/
@property (copy, nonatomic)   NSString *month;                  /*!< 选中月*/
@property (copy, nonatomic)   NSString *day;                    /*!< 选中日*/
@property (copy, nonatomic)   NSString *hour;                   /*!< 选中时*/
@property (copy, nonatomic)   NSString *minute;                 /*!< 选中分*/


@end

#define THColorRGB(rgb)    [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:1.0]

@implementation GLDatePickView


#pragma mark - init
/// 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
        self.dataArray = [NSMutableArray array];
        [self.dataArray addObject:self.yearArr];
        [self.dataArray addObject:self.monthArr];
        [self.dataArray addObject:self.dayArr];
        [self.dataArray addObject:self.hourArr];
        [self.dataArray addObject:self.minuteArr];
        
        [self configToolView];
        [self configPickerView];
        [self configDate];
    }
    return self;
}
#pragma mark - 配置界面
/// 配置工具条
- (void)configToolView {
    
//    UIView *bgView = [[UIView alloc] initWithFrame:(CGRect){0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 344}];
//    bgView.backgroundColor = [UIColor redColor];
//    [self addSubview:bgView];
    
    self.toolView = [[UIView alloc] init];
    self.toolView.backgroundColor = [UIColor lightGrayColor];
    self.toolView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 300, self.frame.size.width, 44);
    [self addSubview:self.toolView];
    
    UIButton *saveBtn = [[UIButton alloc] init];
    saveBtn.frame = CGRectMake(self.frame.size.width - 50, 2, 40, 40);
    [saveBtn setImage:[UIImage imageNamed:@"icon_select1"] forState:UIControlStateNormal];
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:saveBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake(10, 2, 40, 40);
    [cancelBtn setImage:[UIImage imageNamed:@"icon_revocation1"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:cancelBtn];
    
    self.titleLbl = [[UILabel alloc] init];
    self.titleLbl.frame = CGRectMake(60, 2, self.frame.size.width - 120, 40);
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.textColor = THColorRGB(34);
    [self.toolView addSubview:self.titleLbl];
}

/// 配置UIPickerView
- (void)configPickerView {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolView.frame), self.frame.size.width, 256)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self addSubview:self.pickerView];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLbl.text = title;
}

- (void)configDate {
    self.year = self.timeArr[0];
    self.month = [NSString stringWithFormat:@"%ld月", [self.timeArr[1] integerValue]];
    self.day = [NSString stringWithFormat:@"%ld日", [self.timeArr[2] integerValue]];
    self.hour = [NSString stringWithFormat:@"%ld时", [self.timeArr[3] integerValue]];
    self.minute = self.minuteArr[self.minuteArr.count / 2];
    self.currentDateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",self.year,self.month,self.day,self.hour,self.minute];
    
    [self.pickerView selectRow:[self.yearArr indexOfObject:self.year] inComponent:0 animated:YES];
    /// 重新格式化转一下，是因为如果是09月/日/时，数据源是9月/日/时,就会出现崩溃
    [self.pickerView selectRow:[self.monthArr indexOfObject:self.month] inComponent:1 animated:YES];
    [self.pickerView selectRow:[self.dayArr indexOfObject:self.day] inComponent:2 animated:YES];
    [self.pickerView selectRow:[self.hourArr indexOfObject:self.hour] inComponent:3 animated:YES];
    [self.pickerView selectRow:self.minuteArr.count / 2 inComponent:4 animated:YES];
    
    
    /// 刷新日
    [self refreshDay];
}

- (void)show{
    NSLog(@"显示");

    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

#pragma mark - 点击方法
/// 保存按钮点击方法
- (void)saveBtnClick {
    NSLog(@"点击了保存");
    [self removeFromSuperview];
    NSString *month = self.month.length == 3 ? [NSString stringWithFormat:@"%ld", self.month.integerValue] : [NSString stringWithFormat:@"0%ld", self.month.integerValue];
    NSString *day = self.day.length == 3 ? [NSString stringWithFormat:@"%ld", self.day.integerValue] : [NSString stringWithFormat:@"0%ld", self.day.integerValue];
    NSString *hour = self.hour.length == 3 ? [NSString stringWithFormat:@"%ld", self.hour.integerValue] : [NSString stringWithFormat:@"0%ld", self.hour.integerValue];
    NSString *minute = self.minute.length == 3 ? [NSString stringWithFormat:@"%ld", self.minute.integerValue] : [NSString stringWithFormat:@"0%ld", self.minute.integerValue];
    
    self.selectStr = [NSString stringWithFormat:@"%ld-%@-%@ %@:%@", [self.year integerValue], month, day, hour, minute];
    
    //当前时间 大 返回 1 ; 小 返回 -1 ; 等于 返回 0
    if ([self compareDate:self.currentDateStr withDate:self.selectStr] != 1) {
        
        if ([self.delegate respondsToSelector:@selector(datePickViewSaveBtnClickDelegate:)]) {
            [self.delegate datePickViewSaveBtnClickDelegate:self.selectStr];
        }
    }else{
        UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"您选择的时小于当前时间，请重新选择" preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        //[[UIApplication sharedApplication].keyWindow rootViewController]
//        [self.nextCtrl presentViewController:alter animated:YES completion:nil];
    }
    
}
/// 取消按钮点击方法
- (void)cancelBtnClick {
    NSLog(@"点击了取消");
    [self removeFromSuperview];
//    if ([self.delegate respondsToSelector:@selector(datePickViewCancelBtnClickDelegate)]) {
//        [self.delegate datePickViewCancelBtnClickDelegate];
//    }
}
#pragma mark - UIPickerViewDelegate and UIPickerViewDataSource
/// UIPickerView返回多少组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.dataArray.count;
}

/// UIPickerView返回每组多少条数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  [self.dataArray[component] count] * 200;
}

/// UIPickerView选择哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger time_integerValue = [self.timeArr[component] integerValue];
//    NSLog(@"time_integerValue %ld",(long)time_integerValue);
    
    
//    switch (component) {
//        case 0:
//            self.year = self.yearArr[row%[self.dataArray[component] count]];
//            break;
//        case 1:
//            self.month = self.monthArr[row%[self.dataArray[component] count]];
//            break;
//        case 2:
//            self.day = self.dayArr[row%[self.dataArray[component] count]];
//            break;
//        case 3:
//            self.hour = self.hourArr[row%[self.dataArray[component] count]];
//            break;
//        case 4:
//            self.minute = self.minuteArr[row%[self.dataArray[component] count]];
//            break;
//
//        default:
//            break;
//    }
//
//    self.title = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",self.year,self.month,self.day,self.hour,self.minute];
    
  
    switch (component) {
        case 0: { // 年
            //选择的年份
            NSString *year_integerValue = self.yearArr[row%[self.dataArray[component] count]];
            //如果选择的年份小于当前年份 就回滚到当前年份
            if (year_integerValue.integerValue < time_integerValue) {
                [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
            } else {
                self.year = year_integerValue;
                /// 刷新日
                [self refreshDay];
                /// 根据当前选择的年份和月份获取当月的天数
                NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
                if (self.dayArr.count > [dayStr integerValue]) {
                    if (self.day.integerValue > [dayStr integerValue]) {
                        [pickerView selectRow:[self.dataArray[2] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:2 animated:YES];
                        self.day = [dayStr stringByAppendingString:@"日"];
                    }
                }
            }
        } break;
        case 1: { // 月
            
            NSString *month_value = self.monthArr[row%[self.dataArray[component] count]];
            
            // 如果选择年大于当前年 就直接赋值月
            if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
                
                self.month = month_value;
                /// 刷新日
                [self refreshDay];
                
                /// 根据当前选择的年份和月份获取当月的天数
                NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
                if (self.dayArr.count > [dayStr integerValue]) {
                    if (self.day.integerValue > [dayStr integerValue]) {
                        [pickerView selectRow:[self.dataArray[2] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:2 animated:YES];
                        self.day = [dayStr stringByAppendingString:@"日"];
                        
                    }
                }
                // 如果选择的年等于当前年，就判断月份
            } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
                // 如果选择的月份小于当前月份 就刷新到当前月份
                if (month_value.integerValue < [self.timeArr[component] integerValue]) {
                    [pickerView selectRow:[self.dataArray[component] indexOfObject:[NSString stringWithFormat:@"%ld月", [self.timeArr[component] integerValue]]] inComponent:component animated:YES];
                    // 如果选择的月份大于当前月份，就直接赋值月份
                } else {
                    self.month = month_value;
                    /// 刷新日
                    [self refreshDay];
                    
                    /// 根据当前选择的年份和月份获取当月的天数
                    NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
                    if (self.dayArr.count > dayStr.integerValue) {
                        if (self.day.integerValue > dayStr.integerValue) {
                            [pickerView selectRow:[self.dataArray[2] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:2 animated:YES];
                            self.day = [dayStr stringByAppendingString:@"日"];
                        }
                    }
                }
            }
        } break;
        case 2: { // 日
            /// 根据当前选择的年份和月份获取当月的天数
            NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
            // 如果选择年大于当前年 就直接赋值日
            NSString *day_value = self.dayArr[row%[self.dataArray[component] count]];
            NSLog(@"%ld", self.dayArr.count);
            if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
                if (self.dayArr.count <= [dayStr integerValue]) {
                    self.day = day_value;
                } else {
                    if (day_value.integerValue <= [dayStr integerValue]) {
                        self.day = day_value;
                    } else {
                        [pickerView selectRow:[self.dataArray[component] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:component animated:YES];
                    }
                }
                // 如果选择的年等于当前年，就判断月份
            } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
                // 如果选择的月份大于当前月份 就直接复制
                if ([self.month integerValue] > [self.timeArr[1] integerValue]) {
                    if (self.dayArr.count <= [dayStr integerValue]) {
                        self.day = day_value;
                    } else {
                        if (day_value.integerValue <= [dayStr integerValue]) {
                            self.day = day_value;
                        } else {
                            [pickerView selectRow:[self.dataArray[component] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:component animated:YES];
                        }
                    }
                    // 如果选择的月份等于当前月份，就判断日
                } else if ([self.month integerValue] == [self.timeArr[1] integerValue]) {
                    // 如果选择的日小于当前日，就刷新到当前日
                    if (day_value.integerValue < [self.timeArr[component] integerValue]) {
                        
                        [pickerView selectRow:[self.dataArray[component] indexOfObject:[NSString stringWithFormat:@"%ld日", time_integerValue]] inComponent:component animated:YES];
                        // 如果选择的日大于当前日，就复制日
                    } else {
                        if (self.dayArr.count <= [dayStr integerValue]) {
                            self.day = self.dayArr[row%[self.dataArray[component] count]];
                        } else {
                            if ([self.dayArr[row%[self.dataArray[component] count]] integerValue] <= [dayStr integerValue]) {
                                self.day = self.dayArr[row%[self.dataArray[component] count]];
                            } else {
                                [pickerView selectRow:[self.dataArray[component] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:component animated:YES];
                            }
                        }
                    }
                }
            }
        } break;
        case 3: { // 时
            // 如果选择年大于当前年 就直接赋值时
            if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
                self.hour = self.hourArr[row%[self.dataArray[component] count]];
                // 如果选择的年等于当前年，就判断月份
            } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
                // 如果选择的月份大于当前月份 就直接复制时
                if ([self.month integerValue] > [self.timeArr[1] integerValue]) {
                    self.hour = self.hourArr[row%[self.dataArray[component] count]];
                    // 如果选择的月份等于当前月份，就判断日
                } else if ([self.month integerValue] == [self.timeArr[1] integerValue]) {
                    // 如果选择的日大于当前日，就直接复制时
                    if ([self.day integerValue] > [self.timeArr[2] integerValue]) {
                        self.hour = self.hourArr[row%[self.dataArray[component] count]];
                        // 如果选择的日等于当前日，就判断时
                    } else if ([self.day integerValue] == [self.timeArr[2] integerValue]) {
                        // 如果选择的时小于当前时，就刷新到当前时
                        if ([self.hourArr[row%[self.dataArray[component] count]] integerValue] < [self.timeArr[3] integerValue]) {
                            [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
                            // 如果选择的时大于当前时，就直接赋值
                        } else {
                            self.hour = self.hourArr[row%[self.dataArray[component] count]];
                        }
                    }
                }
            }
        } break;
        case 4: { // 分
            // 如果选择年大于当前年 就直接赋值时
                        if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
//            self.minute = self.minuteArr[row%[self.dataArray[component] count]];
                            // 如果选择的年等于当前年，就判断月份
                        } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
                            // 如果选择的月份大于当前月份 就直接复制时
                            if ([self.month integerValue] > [self.timeArr[1] integerValue]) {
                                self.minute = self.minuteArr[row%[self.dataArray[component] count]];
                                // 如果选择的月份等于当前月份，就判断日
                            } else if ([self.month integerValue] == [self.timeArr[1] integerValue]) {
                                // 如果选择的日大于当前日，就直接复制时
                                if ([self.day integerValue] > [self.timeArr[2] integerValue]) {
                                    self.minute = self.minuteArr[row%[self.dataArray[component] count]];
                                    // 如果选择的日等于当前日，就判断时
                                } else if ([self.day integerValue] == [self.timeArr[2] integerValue]) {
                                    // 如果选择的时大于当前时，就直接赋值
                                    if ([self.hour integerValue] > [self.timeArr[3] integerValue]) {
                                        self.minute = self.minuteArr[row%[self.dataArray[component] count]];
                                    // 如果选择的时等于当前时,就判断分
                                    } else if ([self.hour integerValue] == [self.timeArr[3] integerValue]) {
                                        // 如果选择的分小于当前分，就刷新分
                                        if ([self.minuteArr[row%[self.dataArray[component] count]] integerValue] < [self.timeArr[4] integerValue]) {
                                            [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
                                        // 如果选择分大于当前分，就直接赋值
                                        } else {
                                            self.minute = self.minuteArr[row%[self.dataArray[component] count]];
                                        }
                                    }
                                }
                            }
                        }
        } break;
        default: break;
    }

}

/// UIPickerView返回每一行数据
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
}
/// UIPickerView返回每一行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
/// UIPickerView返回每一行的View
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 44)];
    titleLbl.font = [UIFont systemFontOfSize:15];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
    
    return titleLbl;
}


- (void)pickerViewLoaded:(NSInteger)component row:(NSInteger)row{
    NSUInteger max = 16384;
    NSUInteger base10 = (max/2)-(max/2)%row;
    [self.pickerView selectRow:[self.pickerView selectedRowInComponent:component] % row + base10 inComponent:component animated:NO];
}


/// 获取年份
- (NSMutableArray *)yearArr {
    if (!_yearArr) {
        _yearArr = [NSMutableArray array];
        for (int i = 1970; i < 2099; i ++) {
            [_yearArr addObject:[NSString stringWithFormat:@"%d年", i]];
        }
    }
    return _yearArr;
}

/// 获取月份
- (NSMutableArray *)monthArr {
//        NSDate *today = [NSDate date];
//        NSCalendar *c = [NSCalendar currentCalendar];
//        NSRange days = [c rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:today];
    if (!_monthArr) {
        _monthArr = [NSMutableArray array];
        for (int i = 1; i <= 12; i ++) {
            [_monthArr addObject:[NSString stringWithFormat:@"%d月", i]];
        }
    }
    return _monthArr;
}

/// 获取当前月的天数
- (NSMutableArray *)dayArr {
    if (!_dayArr) {
        _dayArr = [NSMutableArray array];
        for (int i = 1; i <= 31; i ++) {
            [_dayArr addObject:[NSString stringWithFormat:@"%d日", i]];
        }
    }
    return _dayArr;
}

/// 获取小时
- (NSMutableArray *)hourArr {
    if (!_hourArr) {
        _hourArr = [NSMutableArray array];
        for (int i = 0; i < 24; i ++) {
            [_hourArr addObject:[NSString stringWithFormat:@"%d时", i]];
        }
    }
    return _hourArr;
}

/// 获取分钟
- (NSMutableArray *)minuteArr {
    if (!_minuteArr) {
        _minuteArr = [NSMutableArray array];
//        for (int i = 0; i <= 55; i ++) {
//            if (i % 5 == 0) {
//                [_minuteArr addObject:[NSString stringWithFormat:@"%d分", i]];
//                continue;
//            }
//        }
        
        for (int i = 0; i <= 59; i ++) {
//            if (i % 5 == 0) {
                [_minuteArr addObject:[NSString stringWithFormat:@"%d分", i]];
                continue;
//            }
        }
    }
    return _minuteArr;
}

// 获取当前的年月日时
- (NSArray *)timeArr {
    if (!_timeArr) {
        _timeArr = [NSArray array];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年,MM月,dd日,HH时,mm分"];
        NSDate *date = [NSDate date];
        NSString *time = [formatter stringFromDate:date];
        _timeArr = [time componentsSeparatedByString:@","];
    }
    return _timeArr;
}

// 比较选择的时间是否小于当前时间
- (int)compareDate:(NSString *)date01 withDate:(NSString *)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy年-MM月-dd日 HH时:mm分"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result) {
            //date02比date01大
        case NSOrderedAscending: ci=-1;break;
            //date02比date01小
        case NSOrderedDescending: ci=1;break;
            //date02=date01
        case NSOrderedSame: ci=0;break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);break;
    }
    return ci;
}


- (void)refreshDay {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i < [self getDayNumber:self.year.integerValue month:self.month.integerValue].integerValue + 1; i ++) {
        [arr addObject:[NSString stringWithFormat:@"%d日", i]];
    }
    
    [self.dataArray replaceObjectAtIndex:2 withObject:arr];
    [self.pickerView reloadComponent:2];
}

- (NSString *)getDayNumber:(NSInteger)year month:(NSInteger)month{
    NSArray *days = @[@"31", @"28", @"31", @"30", @"31", @"30", @"31", @"31", @"30", @"31", @"30", @"31"];
    if (2 == month && 0 == (year % 4) && (0 != (year % 100) || 0 == (year % 400))) {
        return @"29";
    }
    return days[month - 1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //touches,拿到触摸屏上的手指所对应的UITouch对象
    UITouch *touch = [touches anyObject];
    //拿到手指在self上的坐标
    CGPoint pt = [touch locationInView:self];
    if ((pt.y < [UIScreen mainScreen].bounds.size.height - 300)) {
        [self removeFromSuperview];
    }
    
}

@end
