//
//  YZCalendarModel.h
//  YZSelectCalendarDemo
//
//  Created by Q房通 on 2017/11/29.
//  Copyright © 2017年 Q房通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZCalendarModel : NSObject
/* <#description#> */
@property (nonatomic,strong) NSDate *date;
/* <#description#> */
@property (nonatomic,strong) NSArray *dateArray;

@end

@interface YZCalendarCellModel : NSObject
/* 后台给的日期 */
//@property (nonatomic,copy) NSDate *date;
/* <#description#> */
@property (nonatomic,copy) NSString *date;
/* <#description#> */
@property (nonatomic,copy) NSString *dateDay;
/* 背景色 */
@property (nonatomic,strong) UIColor *bgColor;
/* 价格 */
@property (nonatomic,copy) NSString *price;
/* 价格文字颜色 */
@property (nonatomic,strong) UIColor *priceColor;
/* 日期 */
@property (nonatomic,copy) NSString *text;
/* 文字颜色 */
@property (nonatomic,strong) UIColor *textColor;
/* 房间状态  FIXED, CHENEDIN, CHENKOUT, BOOKED  */
@property (nonatomic,copy) NSString *status;
/* 能否被选 */
@property (nonatomic,assign) BOOL isSelect; 
/* 能否交互 */
@property (nonatomic,assign) BOOL isAvailable;


@end















