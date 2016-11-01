//
//  WGBDatePickerView.m
//  DatePick
//
//  Created by Wangguibin on 16/9/15.
//  Copyright © 2016年 王贵彬. All rights reserved.
//
//  文件名称：时间选择器
//

#import "LSDatePickerView.h"

#define kContentY kScreenH/3*2-44
#define kCOntentHeight kScreenH/3+44

#define kDatePicY 44
#define kDatePicHeight kScreenH/3

#define kDateTopBtnHeight 44
#define kDateTopLeftBtnWidth kScreenW/6
#define kDateTopRightBtnWidth kDateTopLeftBtnWidth
#define kDateTopRightBtnX kScreenW-0-kDateTopRightBtnWidth

@interface LSDatePickerView ()

@property (nonatomic,strong)UIView *coverView;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIDatePicker *datePicker;
@property (nonatomic,strong)UIButton *cancelBtn;//左侧取消按钮
@property (nonatomic,strong)UIButton *determineBtn;//右侧确定按钮
@property (nonatomic,strong)UIView *topView;
@property (nonatomic)UIDatePickerMode type;
@property (nonatomic,strong)UILabel *titleLabel;
@end

@implementation LSDatePickerView
- (NSString*)stringFromDate:(NSDate*)date{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    switch (self.type) {
        case UIDatePickerModeTime:
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
            
        default:
            break;
    }
    return [dateFormatter stringFromDate:date];
}
- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, kCOntentHeight)];
        [_contentView addSubview:self.datePicker];
        [_contentView addSubview:self.topView];
        [_contentView addSubview:self.cancelBtn];
        [_contentView addSubview:self.determineBtn];
    }
    return _contentView;
}
- (UIDatePicker *)datePicker{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, kDatePicY, kScreenW, kDatePicHeight)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = self.type;
        [_datePicker addTarget:self action:@selector(handleDatePicker:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}
- (void)handleDatePicker:(NSDate *)date {
    if ([self.delegate respondsToSelector:@selector(changeTime:)]) {
        [self.delegate changeTime:[self stringFromDate:self.datePicker.date]];
    }
}
- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.4;
    }
    return _coverView;
}
- (UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, 0, kDateTopLeftBtnWidth, kDateTopBtnHeight);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(handleDateTopViewLeft) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (void)handleDateTopViewLeft {
    WeakObj(self)
    [UIView animateWithDuration:0.5f animations:^{
        weakself.contentView.frame = CGRectMake(0, kScreenH, kScreenW, kCOntentHeight);
    } completion:^(BOOL finished) {
        [weakself removeFromSuperview];
    }];
}
- (UIButton *)determineBtn {
    if (_determineBtn == nil) {
        _determineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _determineBtn.frame = CGRectMake(kDateTopRightBtnX, 0, kDateTopRightBtnWidth, kDateTopBtnHeight);
        [_determineBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_determineBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_determineBtn addTarget:self action:@selector(handleDateTopViewRight) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determineBtn;
}
- (void)handleDateTopViewRight {
    if ([self.delegate respondsToSelector:@selector(deterTime:)]) {
        [self.delegate deterTime:[self stringFromDate:self.datePicker.date]];
    }
    WeakObj(self)
    [UIView animateWithDuration:0.5f animations:^{
        weakself.contentView.frame = CGRectMake(0, kScreenH, kScreenW, kCOntentHeight);
    } completion:^(BOOL finished) {
        [weakself removeFromSuperview];
    }];
}
- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kDateTopBtnHeight)];
        _topView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW-2*(0+kDateTopLeftBtnWidth) , kDateTopBtnHeight)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.minimumScaleFactor = 0.5;
        _titleLabel.center = CGPointMake(_topView.frame.size.width/2, kDateTopBtnHeight/2);
        [_topView addSubview: _titleLabel];
    }
    return _topView;
}

- (instancetype)initWithType:(UIDatePickerMode)type{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.type = type;
        [self addSubview:self.coverView];
        [self addSubview:self.contentView];
    }
    return self;
}
+ (instancetype)datePickerWithType:(UIDatePickerMode)type{
    return [[LSDatePickerView alloc] initWithType:type];
}

#pragma mark - 重写setter方法
- (void)setOptionalMaxDate:(NSDate *)optionalMaxDate{
    _optionalMaxDate = optionalMaxDate;
    self.datePicker.maximumDate = optionalMaxDate;
}
- (void)setOptionalMinDate:(NSDate *)optionalMinDate{
    _optionalMinDate = optionalMinDate;
    self.datePicker.minimumDate = optionalMinDate;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}

- (void)setNowTime:(NSString *)dateStr{
    [self.datePicker setDate:[self dateFromString:dateStr] animated:YES];
}
- (NSDate*)dateFromString:(NSString*)dateString{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    switch (self.type) {
        case UIDatePickerModeTime:
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        
        default:
            break;
    }
    return [dateFormatter dateFromString:dateString];
}
- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    WeakObj(self)
    [UIView animateWithDuration:0.5f animations:^{
        weakself.contentView.frame = CGRectMake(0, kContentY, kScreenW, kCOntentHeight);
    }];
}

@end
