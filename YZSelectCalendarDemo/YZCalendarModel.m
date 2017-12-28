//
//  YZCalendarModel.m
//  YZSelectCalendarDemo
//
//  Created by Q房通 on 2017/11/29.
//  Copyright © 2017年 Q房通. All rights reserved.
//

#import "YZCalendarModel.h"

@implementation YZCalendarModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"dateArray" : @"YZCalendarCellModel"
             };
}

@end


@implementation YZCalendarCellModel



- (instancetype)init {
    self = [super init];
    if (self) {
        self.isSelect = true; //默认可选
        self.isAvailable = true; //默认可交互
    }
    return self;
}


@end












