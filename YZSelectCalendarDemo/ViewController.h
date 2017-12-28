//
//  ViewController.h
//  YZSelectCalendarDemo
//
//  Created by Q房通 on 2017/11/29.
//  Copyright © 2017年 Q房通. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic,copy) void (^selectDateBlock)(NSArray *selectDateArray,NSArray *dataArray);

@end

