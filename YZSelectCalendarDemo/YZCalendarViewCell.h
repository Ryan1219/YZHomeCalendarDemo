//
//  YZCalendarView.h
//  YZSelectCalendarDemo
//
//  Created by Q房通 on 2017/11/29.
//  Copyright © 2017年 Q房通. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZCalendarModel.h"

@interface YZCalendarViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
/* <#description#> */
@property (nonatomic,strong) YZCalendarModel *calendarModel;

/* <#description#> */
@property (nonatomic,copy) void (^calendarViewBlock)(NSInteger day, NSInteger month, NSInteger year);
/* <#description#> */
@property (nonatomic,copy) void (^calendarViewCellBlock)(NSDate *date,NSInteger year, NSInteger month, NSInteger day,NSInteger firstWeekDay,NSIndexPath *indexPath,YZCalendarCellModel *cellModel);

/* <#description#> */
@property (nonatomic,copy) void (^calendarViewCellDateBlock)(YZCalendarCellModel *dateModel);

@end
