//
//  HSMainViewController.m
//  YZSelectCalendarDemo
//
//  Created by Ryan on 2017/12/28.
//  Copyright © 2017年 Q房通. All rights reserved.
//

#import "HSMainViewController.h"
#import "ViewController.h"

@interface HSMainViewController ()

/* <#description#> */
@property (nonatomic,strong) UILabel *inLabel;
/* <#description#> */
@property (nonatomic,strong) UILabel *outLabel;
/* <#description#> */
@property (nonatomic,strong) UILabel *priceLabel;

@end

@implementation HSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat cellW = ScreenWidth / 3;
    
    self.inLabel = [[UILabel alloc] init];
    self.inLabel.font = [UIFont systemFontOfSize:12];
    self.inLabel.textColor = HSColor(0x999999);
    self.inLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.inLabel];
    
    self.outLabel = [[UILabel alloc] init];
    self.outLabel.font = [UIFont systemFontOfSize:12];
    self.outLabel.textColor = HSColor(0x999999);
    self.outLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.outLabel];
    
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.font = [UIFont systemFontOfSize:12];
    self.priceLabel.textColor = HSColor(0x999999);
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.priceLabel];
    
    [self.inLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(32);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(cellW-10);
    }];
    
    [self.outLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(32);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(cellW-10);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cellW);
        make.height.mas_equalTo(32);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(cellW);
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    ViewController *viewCtrl = [[ViewController alloc] init];
    [self.navigationController pushViewController:viewCtrl animated:true];
    viewCtrl.selectDateBlock = ^(NSArray *selectDateArray, NSArray *dataArray) {
        NSLog(@"dateArray--%ld----",selectDateArray.count);
        if (selectDateArray.count != 0) {
            
            if (selectDateArray.count == 1) {
                
                YZCalendarCellModel *dateModel = [selectDateArray objectAtIndex:0];
                self.inLabel.text = [NSString stringWithFormat:@"入住 : %@",dateModel.date];
                
                NSDate *firstDate = [NSDateTool dateFormatterWithDateString:dateModel.date];
                
                NSDate *leaveDate = [NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:firstDate];
                self.outLabel.text = [NSString stringWithFormat:@"离开 : %@",[[NSDateTool dateFormatter] stringFromDate:leaveDate]];
//                self.priceLabel.text = dateModel.price;
                self.priceLabel.text = [NSString stringWithFormat:@"%@  1晚",[dateModel.price stringByReplacingOccurrencesOfString:@"¥ " withString:@""]];

            }
            else if (selectDateArray.count == 2) {
                
                YZCalendarCellModel *firstDateModel = [selectDateArray objectAtIndex:0];
                NSDate *firstDate = [NSDateTool dateFormatterWithDateString:firstDateModel.date];
                self.inLabel.text = [NSString stringWithFormat:@"入住 : %@",firstDateModel.date];
                
                YZCalendarCellModel *secondDateModel = [selectDateArray objectAtIndex:1];
                NSDate *secondDate = [NSDateTool dateFormatterWithDateString:secondDateModel.date];
                self.outLabel.text = [NSString stringWithFormat:@"离开 : %@",secondDateModel.date];;
                
                //
                NSInteger interDays = [NSDateTool calculatorDaysFromBeginDate:firstDate endDate:secondDate];
                
                //today
                NSInteger todayYear = [NSDateTool getDateYearMonthDay:[NSDateTool today]].year;
                NSInteger todayMonth = [NSDateTool getDateYearMonthDay:[NSDateTool today]].month;
                
                //first
                NSInteger firstYear = [NSDateTool getDateYearMonthDay:firstDate].year;
                NSInteger firstMonth = [NSDateTool getDateYearMonthDay:firstDate].month;
                NSInteger firstWeekDay = [NSDateTool firstWeekdayInThisMonth:firstDate];
                NSInteger firstDay = [NSDateTool getWhichTodayWithDate:firstDate]; //根据日期确定是哪天
                //second
                NSInteger secondYear = [NSDateTool getDateYearMonthDay:secondDate].year;
                NSInteger secondMonth = [NSDateTool getDateYearMonthDay:secondDate].month;
                NSInteger secondWeekDay = [NSDateTool firstWeekdayInThisMonth:secondDate];
                NSInteger secondDay = [NSDateTool getWhichTodayWithDate:secondDate]; //根据日期确定是哪天
                
                // today 和 1点间隔
                NSInteger intervalFirstMonth = 0;
                if (firstYear == todayYear) {
                    intervalFirstMonth = firstMonth - todayMonth - 1;
                } else {
                    intervalFirstMonth = (firstYear - todayYear) * 12 + firstMonth - todayMonth - 1;
                }
                // 1 和 2点间隔
                NSInteger intervalSecondMonth = 0;
                if (secondYear == firstYear) {
                    intervalSecondMonth = secondMonth - firstMonth - 1;
                } else {
                    intervalSecondMonth = (secondYear - firstYear) * 12 + secondMonth - firstMonth - 1;
                }
                
                NSInteger totalPrice = 0;
                if (intervalSecondMonth == -1) {
                    
                    YZCalendarModel *model = dataArray[intervalFirstMonth + 1];
                    for (NSInteger i = firstWeekDay + firstDay - 1; i < firstWeekDay + secondDay-1; i++) {
                        YZCalendarCellModel *dateModel = model.dateArray[i];
                        totalPrice += [[dateModel.price stringByReplacingOccurrencesOfString:@"¥ " withString:@""] integerValue];
                    }
                }
                else {
                    // 1
                    YZCalendarModel *firstDateModel = dataArray[intervalFirstMonth + 1];
                    for (NSInteger i = firstWeekDay + firstDay - 1; i < firstDateModel.dateArray.count; i++) {
                        YZCalendarCellModel *dateModel = firstDateModel.dateArray[i];
                        totalPrice += [[dateModel.price stringByReplacingOccurrencesOfString:@"¥ " withString:@""] integerValue];
                    }
                    
                    // 点1 和 点2 之间
                    for (NSInteger i = intervalFirstMonth + 1 + 1; i < intervalFirstMonth + 1 + 1 + intervalSecondMonth; i++) {
                        YZCalendarModel *midDateModel = dataArray[i];
                        for (YZCalendarCellModel *dateModel in midDateModel.dateArray) {
                            totalPrice += [[dateModel.price stringByReplacingOccurrencesOfString:@"¥ " withString:@""] integerValue];
                        }
                    }
                    
                    //2
                    YZCalendarModel *secondDateModel = dataArray[intervalFirstMonth + 1 + intervalSecondMonth + 1];
                    for (NSInteger i = secondWeekDay; i < secondDateModel.dateArray.count; i++) {
                        YZCalendarCellModel *dateModel = secondDateModel.dateArray[i];
                        if (i < secondWeekDay + secondDay - 1) {
                            totalPrice += [[dateModel.price stringByReplacingOccurrencesOfString:@"¥ " withString:@""] integerValue];
                        }
                    }
                }
                
                self.priceLabel.text = [NSString stringWithFormat:@"¥ %ld  %zd晚",totalPrice,interDays];
            }
        }
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
