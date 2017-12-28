//
//  NSDateTool.m
//  YZSelectCalendarDemo
//
//  Created by Q房通 on 2017/11/29.
//  Copyright © 2017年 Q房通. All rights reserved.
//

#import "NSDateTool.h"

@implementation NSDateTool

//MARK:--date
+ (NSInteger)day:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return components.day;
}

+ (NSInteger)month:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return components.month;
}

+ (NSInteger)year:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return components.year;
}


+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //0.Sun. 1.Mon. 2.Thes. 3.Wed. 4.Thur. 5.Fri. 6.Sat.
    [calendar setFirstWeekday:1];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [components setDay:1];
    
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:components];
    
    NSInteger firstWeekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    
    return firstWeekDay - 1;
    
}

+ (NSInteger)totalDaysInMonth:(NSDate *)date {
    
    NSRange totalDays = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totalDays.length;
}


+ (NSDate *)lastMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *lastDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return lastDate;
}

+ (NSDate *)nextMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *nextDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return nextDate;
}


//将NSDate类型的时间转换为时间戳,从1970/1/1开始
+ (long long)getDateTimeToMilliSeconds:(NSDate *)datetime {
    
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    
    return interval * 1000;
}

//将时间戳转换为NSDate类型
+ (NSDate *)getDateTimeFromMilliSeconds:(long long)milliSeconds {
    
    NSTimeInterval tempMilli = milliSeconds;
    NSTimeInterval seconds = tempMilli / 1000.0;
    
    return [NSDate dateWithTimeIntervalSince1970:seconds];
    
}


+ (NSDateComponents *)getDateYearMonthDay:(NSDate *)date {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    return components;
}


+ (NSDate *)dateFormatterWithDateString:(NSString *)dateString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateString];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    //时区转UTC
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    
//    NSDate *today = [NSDate date];
//
//    NSInteger intervarToday = [timeZone secondsFromGMTForDate:today];
//
//    NSDate *localToday = [date dateByAddingTimeInterval:intervarToday];
    
    return localeDate;
}

+ (NSDate *)today {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
//    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [timeZone secondsFromGMTForDate:[NSDate date]];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSDate *newDate = [formatter dateFromString:dateString];
//    NSDate *newDate = [[NSDate date] dateByAddingTimeInterval:interval];
    
    return newDate;
}

+ (NSInteger)getWhichTodayWithDate:(NSDate *)date {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"dd"];
    NSInteger todayIndex = [[formatter stringFromDate:date] integerValue];
    
    return todayIndex;
}

+ (NSDateFormatter *)dateFormatter {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return formatter;
}

+ (NSInteger)calculatorDaysFromBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    
    int days = ((int)time)/(3600*24);
    
    return days;
}

@end






















