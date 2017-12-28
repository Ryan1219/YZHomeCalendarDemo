//
//  NSDateTool.h
//  YZSelectCalendarDemo
//
//  Created by Q房通 on 2017/11/29.
//  Copyright © 2017年 Q房通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateTool : NSObject

+ (NSInteger)day:(NSDate *)date;

+ (NSInteger)month:(NSDate *)date;

+ (NSInteger)year:(NSDate *)date;

+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;

+ (NSInteger)totalDaysInMonth:(NSDate *)date;

+ (NSDate *)lastMonth:(NSDate *)date;

+ (NSDate *)nextMonth:(NSDate *)date;


//将NSDate类型的时间转换为时间戳,从1970/1/1开始
+ (long long)getDateTimeToMilliSeconds:(NSDate *)datetime;

//将时间戳转换为NSDate类型
+ (NSDate *)getDateTimeFromMilliSeconds:(long long)milliSeconds;

+ (NSDateComponents *)getDateYearMonthDay:(NSDate *)date;

+ (NSDate *)dateFormatterWithDateString:(NSString *)dateString;


+ (NSDate *)today;

//根据日期获取日期在该月的第几天
+ (NSInteger)getWhichTodayWithDate:(NSDate *)date;

+ (NSDateFormatter *)dateFormatter;

+ (NSInteger)calculatorDaysFromBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;

@end



















