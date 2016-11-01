//
//  WGBDatePickerView.h
//
//  Created by ArthurShuai on 16/10/27.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//  

#import <UIKit/UIKit.h>

@protocol LSDatePickerViewDelegate <NSObject>

@required
/**
 时间改变

 @param dateStr 当前选中的时间字符串
 */
- (void)changeTime:(NSString *)dateStr;

/**
 确定时间

 @param dateStr 确定按钮点击时的时间字符串
 */
- (void)deterTime:(NSString *)dateStr;

@end

@interface LSDatePickerView : UIView

@property (nonatomic) id<LSDatePickerViewDelegate> delegate;
/**
 选择器标题
 */
@property (nonatomic,copy) NSString *title;
/**
 *可选的时间的最大值和最小值，最小值默认是nil，最小值之前的时间不能选取,最大值默认为nil
 *最小值大于最大值时，最小值就会被忽略
 */
@property (nonatomic,strong) NSDate *optionalMaxDate;
@property (nonatomic,strong) NSDate *optionalMinDate;

- (instancetype)initWithType:(UIDatePickerMode)type;
+ (instancetype)datePickerWithType:(UIDatePickerMode)type;

/**
 设置打开选择器时的显示时间,默认的是当前时间
 
 @param dateStr dateStr
 */
- (void)setNowTime:(NSString *)dateStr;

/**
 显示时间选择器
 */
- (void)show;

@end
