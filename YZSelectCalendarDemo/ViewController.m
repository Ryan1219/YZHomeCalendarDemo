//
//  ViewController.m
//  YZSelectCalendarDemo
//
//  Created by Q房通 on 2017/11/29.
//  Copyright © 2017年 Q房通. All rights reserved.
//

#import "ViewController.h"
#import "YZCalendarViewCell.h"
#import "YZCalendarModel.h"

#define Today [NSDate date]

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

/* 列表 */
@property (nonatomic,strong) UITableView *tableView;
/* 数据源 */
@property (nonatomic,strong) NSMutableArray *dataArray;
/* 保持回调的数据 */
@property (nonatomic,strong) NSMutableArray *dateArray;
/* 保存所有无房的日期 */
@property (nonatomic,strong) NSMutableArray *noRoomArr;


@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    
    self.dateArray = [NSMutableArray array];
    
    self.noRoomArr = [NSMutableArray array];
    
    [self configData];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 32)];
    backBtn.backgroundColor = [UIColor redColor];
    [backBtn addTarget:self action:@selector(clickBackAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];;
    
}

- (void)clickBackAction:(UIButton *)sender {
    
    if (self.dateArray.count != 0) {
        if (self.selectDateBlock) {
            self.selectDateBlock(self.dateArray, self.dataArray);
        }
    }
    [self.navigationController popViewControllerAnimated:true];
}

//MARK:--数据处理
- (void)configData {
    
    NSDate *today = [NSDateTool today];
    for (NSInteger i = 0; i < 3; i++) {
        YZCalendarModel *model = [[YZCalendarModel alloc] init];
        if (i == 0) {
            model.date = today;
        } else {
            model.date = [NSDateTool nextMonth:today];
            
        }
        model.dateArray = [self calculateModelWithDate:model.date index:i];
        today = model.date;
        [self.dataArray addObject:model];
    }
}

- (NSMutableArray *)calculateModelWithDate:(NSDate *)date index:(NSInteger)index{
    
    //
    NSMutableArray *tempArr = [NSMutableArray array];
    //当月共有多少天
    NSInteger daysCountInMonth = [NSDateTool totalDaysInMonth:date];
    //当月第一天是周几
    NSInteger firstWeekday = [NSDateTool firstWeekdayInThisMonth:date];
    
    for (NSInteger i = 0; i < firstWeekday; i++) {
        YZCalendarCellModel *cellModel = [[YZCalendarCellModel alloc] init];
        cellModel.text = @"";
        cellModel.price = @"";
        cellModel.bgColor = [UIColor whiteColor];
        cellModel.isSelect = false;
        cellModel.isAvailable = false;
        [tempArr addObject:cellModel];
    }
    
    NSInteger todayIndex = 0;
    if (index == 0) { //计算第一个模型里的当天
        todayIndex = [NSDateTool getWhichTodayWithDate:[NSDateTool today]];
    }
    
    NSInteger year = [NSDateTool getDateYearMonthDay:date].year;
    NSInteger month = [NSDateTool getDateYearMonthDay:date].month;
    
    for (NSInteger i = 0; i < daysCountInMonth; i++) {
        
        YZCalendarCellModel *cellModel = [[YZCalendarCellModel alloc] init];
        cellModel.text = [NSString stringWithFormat:@"%ld",i+1];
        cellModel.dateDay = [NSString stringWithFormat:@"%ld",i+1];
        cellModel.bgColor = [UIColor whiteColor];
        NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,i+1];
//        cellModel.date = [NSDateTool dateFormatterWithDateString:dateString];
        cellModel.date = dateString;
        
        if (index == 0) { //当月
            
            if (i < todayIndex - 1) {
                cellModel.textColor = HSColor(0x999999);
                cellModel.price = @"";
                cellModel.isSelect = false;
                cellModel.isAvailable = false;
            }
            else {
                cellModel.textColor = HSColor(0x333333);
                cellModel.isSelect = true;
                cellModel.isAvailable = true;
//                cellModel.price = [NSString stringWithFormat:@"¥ %ld",i+20];
                cellModel.price = @"¥ 20";
                if (i == todayIndex  || i == todayIndex + 1) {
                    cellModel.status = @"BOOKED";
                    cellModel.isSelect = false;
                }
            }
        }
        else { // 不是当月
            cellModel.textColor = HSColor(0x333333);
            cellModel.isSelect = true;
            cellModel.isAvailable = true;
//            cellModel.price = [NSString stringWithFormat:@"¥ %ld",i+20];
            cellModel.price = @"¥ 20";
            if (i == 3 || i == 4) {
                cellModel.status = @"BOOKED";
                cellModel.isSelect = false;
            }
        }

        [tempArr addObject:cellModel];
    }
    
    return tempArr;
}

//MARK:--UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZCalendarViewCell *cell = [YZCalendarViewCell cellWithTableView:tableView];
    
    cell.calendarModel = self.dataArray[indexPath.row];
    
    WeakSelf
    cell.calendarViewCellBlock = ^(NSDate *date, NSInteger year, NSInteger month, NSInteger day, NSInteger firstWeekDay,NSIndexPath *indexPath,YZCalendarCellModel *cellModel) {
        
        NSDate *selectDate = [NSDateTool dateFormatterWithDateString:cellModel.date];
        
        NSLog(@"----------date-----%@",date);
        NSLog(@"----------selectDate-----%@",selectDate);
        
        // 1
        if (weakSelf.dateArray.count == 0) {
//            [weakSelf.dateArray addObject:selectDate];
            [weakSelf.dateArray addObject:cellModel];
        }// 2
        else if (weakSelf.dateArray.count == 1) {
            //第二次点的日期与第一个一样
            YZCalendarCellModel *firstDateModel = weakSelf.dateArray[0];
            NSDate *firstDate = [NSDateTool dateFormatterWithDateString:firstDateModel.date];
            if ([selectDate isEqualToDate:firstDate]) {
                [weakSelf.noRoomArr removeAllObjects];
            } else {
                //如果第二个日期比第一个早
                if ([selectDate compare:firstDate] == NSOrderedAscending) {
                    [weakSelf.noRoomArr removeAllObjects];
                    [weakSelf.dateArray removeAllObjects];
//                    [weakSelf.dateArray addObject:date];
                    [weakSelf.dateArray addObject:cellModel];
                }
                //如果第二个日期比第一个晚
                else {
                    if (self.noRoomArr.count != 0) {
                        YZCalendarCellModel *firstModel = self.noRoomArr[0];
                        NSDate *firstDate = [NSDateTool dateFormatterWithDateString:firstModel.date];
                        if ([selectDate compare:firstDate] == NSOrderedAscending || [selectDate compare:firstDate] == NSOrderedSame) {
//                            [weakSelf.dateArray addObject:date];
                            [weakSelf.dateArray addObject:cellModel];
                        }
                        else {
                            [weakSelf.noRoomArr removeAllObjects];
                            [weakSelf.dateArray removeAllObjects];
//                            [weakSelf.dateArray addObject:selectDate];
                            [weakSelf.dateArray addObject:cellModel];
                        }
                    }
                    else {
//                        [weakSelf.dateArray addObject:selectDate];
                        [weakSelf.dateArray addObject:cellModel];
                    }
                }
            }
        }// 3
        else if (weakSelf.dateArray.count == 2) {
            
            [weakSelf.noRoomArr removeAllObjects];
            [weakSelf.dateArray removeAllObjects];
            [weakSelf.dataArray removeAllObjects];//数据源
            [weakSelf configData];
            [weakSelf.tableView reloadData];
//            [weakSelf.dateArray addObject:selectDate];
            [weakSelf.dateArray addObject:cellModel];

        }
        NSLog(@"-----tempArray Count----%zd",weakSelf.dateArray.count);
        //根据weakSelf.tempArray做逻辑处理
        [self handleLogic];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemW = ScreenWidth / 7;
    
    YZCalendarModel *model = self.dataArray[indexPath.row];

    NSInteger row = model.dateArray.count / 7;
    NSInteger lastDay = model.dateArray.count % 7;
    if (lastDay != 0) {
        row += 1;
    }
    return 40 + (row + 1) * itemW;
}


// 处理点击cell
- (void)handleLogic {
    
    if (self.dateArray.count == 1) {
        
        YZCalendarCellModel *firstDateModel = [self.dateArray objectAtIndex:0];
//        NSDate *firstDate = [self.dateArray objectAtIndex:0];
         NSDate *firstDate = [NSDateTool dateFormatterWithDateString:firstDateModel.date];
        NSLog(@"--firstDate--%@",firstDate);
        //today
        NSInteger todayYear = [NSDateTool getDateYearMonthDay:[NSDateTool today]].year;
        NSInteger todayMonth = [NSDateTool getDateYearMonthDay:[NSDateTool today]].month;
        NSInteger todayWeekDay = [NSDateTool firstWeekdayInThisMonth:[NSDateTool today]];
        NSInteger todayDay = [NSDateTool getWhichTodayWithDate:[NSDateTool today]]; //根据日期确定是哪天
        
        //first
        NSInteger firstYear = [NSDateTool getDateYearMonthDay:firstDate].year;
        NSInteger firstMonth = [NSDateTool getDateYearMonthDay:firstDate].month;
        NSInteger firstWeekDay = [NSDateTool firstWeekdayInThisMonth:firstDate];
        NSInteger firstDay = [NSDateTool getWhichTodayWithDate:firstDate]; //根据日期确定是哪天
        
        NSInteger intervalFirstMonth = 0;
        if (firstYear == todayYear) {
            intervalFirstMonth = firstMonth - todayMonth - 1;
        } else {
            intervalFirstMonth = (firstYear - todayYear) * 12 + firstMonth - todayMonth - 1;
        }
        // today 和 1点同一个月
        if (intervalFirstMonth == -1) {
            //获取点击月模型
            YZCalendarModel *model = self.dataArray[intervalFirstMonth + 1];
            
            for (NSInteger i = todayWeekDay + todayDay - 1; i < model.dateArray.count; i++) {
                YZCalendarCellModel *cellModel = model.dateArray[i];
                
                if (i < firstWeekDay + firstDay - 1) {
                    cellModel.bgColor = [UIColor whiteColor];
                    cellModel.isSelect = true;
                    if ([cellModel.status isEqualToString:@"BOOKED"] ) {
                        cellModel.isSelect = false;
                    }
                    else if ([cellModel.status isEqualToString:@"CHENEDIN"]) {
                        cellModel.status = @"";
                    }
                }
                else if (i == firstWeekDay + firstDay - 1) {
                    cellModel.bgColor = [UIColor redColor];
                    cellModel.status = @"CHENEDIN";
                    cellModel.isSelect = true;
                }
                else {
                    //如果后面只有一个无房，可以点, 有俩个，则只有第一个可以点
                    cellModel.bgColor = [UIColor whiteColor];
                    cellModel.isSelect = true;
                    if ([cellModel.status isEqualToString:@"BOOKED"]) {
                        [self.noRoomArr addObject:cellModel];//保存无房
                    }
                    else if ([cellModel.status isEqualToString:@"CHENEDIN"]) {
                        cellModel.status = @"";
                    }
                }
            }
            
            //end
            for (NSInteger i = 1; i < 3; i++) {
                YZCalendarModel *model = self.dataArray[i];
                for (YZCalendarCellModel *cellModel in model.dateArray) {
                    cellModel.bgColor = [UIColor whiteColor];
                    if ([cellModel.status isEqualToString:@"BOOKED"] ) {
                        [self.noRoomArr addObject:cellModel];//保存无房
                    }
                    if ([cellModel.status isEqualToString:@"CHENEDIN"] ) {
                        cellModel.status = @"";
                    }
                }
            }
            //设置第一个无房可以点
            if (self.noRoomArr.count != 0) {
                for (NSInteger i = 0 ; i < self.noRoomArr.count; i++) {
                    YZCalendarCellModel *cellModel = self.noRoomArr[i];
                    if (i == 0) {
                        cellModel.isSelect = true;
                    } else {
                        cellModel.isSelect = false;
                    }
                }
            }
            
            [self.tableView reloadData];
        } // today 和 1点不同一个月
        else {
            //从today开始到点击月,指当月和点击月之间
            for (NSInteger i = 0; i < intervalFirstMonth + 1; i++) {
                YZCalendarModel *todayModel = self.dataArray[i];
                for (YZCalendarCellModel *cellModel in todayModel.dateArray) {
                    cellModel.bgColor = [UIColor whiteColor];
                    if ([cellModel.status isEqualToString:@"BOOKED"]) {
                        cellModel.isSelect = false;
                    }
                    if ([cellModel.status isEqualToString:@"CHENEDIN"]) {
                        cellModel.status = @"";
                    }
                }
            }
            // 点击月
            YZCalendarModel *firstModel = self.dataArray[intervalFirstMonth + 1];
            //保持所有无房的模型
//            NSMutableArray *currentTempArray = [NSMutableArray array];
            
            for (NSInteger i = firstWeekDay; i < firstModel.dateArray.count; i++) {
                YZCalendarCellModel *cellModel = firstModel.dateArray[i];
                if (i < firstWeekDay + firstDay - 1) {
                    cellModel.bgColor = [UIColor whiteColor];
                    cellModel.isSelect = true;
                    if ([cellModel.status isEqualToString:@"BOOKED"]) {
                        cellModel.isSelect = false;
                    }
                    if ([cellModel.status isEqualToString:@"CHENEDIN"] ) {
                        cellModel.status = @"";
                        cellModel.bgColor = [UIColor whiteColor];
                    }
                }
                else if (i == firstWeekDay + firstDay - 1) {
                    cellModel.bgColor = [UIColor redColor];
                    cellModel.status = @"CHENEDIN";
                    cellModel.isSelect = true;
                }
                else {
                    cellModel.bgColor = [UIColor whiteColor];
                    cellModel.isSelect = true;
                    if ([cellModel.status isEqualToString:@"BOOKED"]) {
                        [self.noRoomArr addObject:cellModel];//保存无房
                    }
                    if ([cellModel.status isEqualToString:@"CHENEDIN"] ) {
                        cellModel.status = @"";
                        cellModel.bgColor = [UIColor whiteColor];
                    }
                }
            }
            
            //end  (intervalFirstMonth + 1)为点击月
            for (NSInteger i = intervalFirstMonth + 1 + 1; i < 3; i++) {
                YZCalendarModel *model = self.dataArray[i];
                for (YZCalendarCellModel *cellModel in model.dateArray) {
                    cellModel.isSelect = true;
                    cellModel.bgColor = [UIColor whiteColor];
                    if ([cellModel.status isEqualToString:@"BOOKED"]) {
                        [self.noRoomArr addObject:cellModel];//保存无房
                    }
                    if ([cellModel.status isEqualToString:@"CHENEDIN"] ) {
                        cellModel.status = @"";
                    }
                }
            }
            //设置第一个无房可以点
            if (self.noRoomArr.count != 0) {
                for (NSInteger i = 0 ; i < self.noRoomArr.count; i++) {
                    YZCalendarCellModel *cellModel = self.noRoomArr[i];
                    if (i == 0) {
                        cellModel.isSelect = true;
                    } else {
                        cellModel.isSelect = false;
                    }
                }
            }
            [self.tableView reloadData];
        }
    }
    else if (self.dateArray.count == 2) {
        
        YZCalendarCellModel *firstDateModel = [self.dateArray objectAtIndex:0];
        NSDate *firstDate = [NSDateTool dateFormatterWithDateString:firstDateModel.date];
        
        YZCalendarCellModel *secondDateModel = [self.dateArray objectAtIndex:1];
        NSDate *secondDate = [NSDateTool dateFormatterWithDateString:secondDateModel.date];
        
//        NSDate *firstDate = [self.dateArray objectAtIndex:0];
//        NSDate *secondDate = [self.dateArray objectAtIndex:1];
        //today
        NSInteger todayYear = [NSDateTool getDateYearMonthDay:[NSDateTool today]].year;
        NSInteger todayMonth = [NSDateTool getDateYearMonthDay:[NSDateTool today]].month;
//        NSInteger todayWeekDay = [NSDateTool firstWeekdayInThisMonth:[NSDateTool today]];
//        NSInteger todayDay = [NSDateTool getWhichTodayWithDate:[NSDateTool today]]; //根据日期确定是哪天
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
        //1 2 在同一个月
        if (intervalSecondMonth == -1) {
            YZCalendarModel *model = self.dataArray[intervalFirstMonth + 1];
            // 1点和2点之间
            for (NSInteger i = firstWeekDay + firstDay - 1; i < firstWeekDay + secondDay; i++) {
                
                YZCalendarCellModel *cellModel = model.dateArray[i];
                
                cellModel.bgColor = [UIColor redColor];
                cellModel.isSelect = true;
                if (i == firstWeekDay + firstDay - 1) {
                    cellModel.isSelect = true;
                    cellModel.status = @"CHENEDIN";
                }
                else if (i == firstWeekDay + secondDay - 1){
                    if ([cellModel.status isEqualToString:@"BOOKED"]) {
                        cellModel.isSelect = false;
                    } else {
                        cellModel.isSelect = true;
                    }
                    cellModel.status = @"CHENKOUT";
                    
                }
            }
            // 2点和当月后面的数据
            for (NSInteger i = secondWeekDay + secondDay; i < model.dateArray.count; i++) {
                YZCalendarCellModel *cellModel = model.dateArray[i];
                cellModel.bgColor = [UIColor whiteColor];
                cellModel.isSelect = true;
                if ([cellModel.status isEqualToString:@"BOOKED"]) {
                    cellModel.isSelect = false;
                }
            }
            
            //end
            for (NSInteger i = intervalFirstMonth + 1 + 1; i < 3; i++) {
                YZCalendarModel *model = self.dataArray[i];
                for (YZCalendarCellModel *cellModel in model.dateArray) {
                    cellModel.bgColor = [UIColor whiteColor];
                    cellModel.isSelect = true;
                    if ([cellModel.status isEqualToString:@"BOOKED"]) {
                        cellModel.isSelect = false;
                    }
                }
            }
            [self.tableView reloadData];
        }
        //1 2 不在同一个月
        else {
            // 1
            YZCalendarModel *firstModel = self.dataArray[intervalFirstMonth + 1];
            for (NSInteger i = firstWeekDay + firstDay - 1; i < firstModel.dateArray.count; i++) {
                YZCalendarCellModel *cellModel = firstModel.dateArray[i];
                cellModel.bgColor = [UIColor redColor];
                if (i == firstWeekDay + firstDay - 1) {
                    cellModel.isSelect = true;
                } else {
                    cellModel.isSelect = true;
                }
            }
            // 点1 和 点2 之间
            for (NSInteger i = intervalFirstMonth + 1 + 1; i < intervalFirstMonth + 1 + 1 + intervalSecondMonth; i++) {
                YZCalendarModel *model = self.dataArray[i];
                for (YZCalendarCellModel *cellModel in model.dateArray) {
                    cellModel.bgColor = [UIColor redColor];
                    cellModel.isSelect = true;
                }
            }
            // 点2  1点所在intervalFirstMonth + 1,2点所在intervalSecondMonth + 1
            YZCalendarModel *secondModel = self.dataArray[intervalFirstMonth + 1 + intervalSecondMonth + 1];
            for (NSInteger i = secondWeekDay; i < secondModel.dateArray.count; i++) {
                YZCalendarCellModel *cellModel = secondModel.dateArray[i];
                if (i < secondWeekDay + secondDay - 1) {
                    cellModel.bgColor = [UIColor redColor];
                    cellModel.isSelect = true;
                }
                else if (i == secondWeekDay + secondDay - 1) {
                    cellModel.bgColor = [UIColor redColor];
                    if ([cellModel.status isEqualToString:@"BOOKED"]) {
                        cellModel.isSelect = false;
                    } else {
                        cellModel.isSelect = true;
                    }
                    cellModel.status = @"CHENKOUT";
                }
                else {
                    cellModel.bgColor = [UIColor whiteColor];
                    cellModel.isSelect = true;
                    if ([cellModel.status isEqualToString:@"BOOKED"]) {
                        cellModel.isSelect = false;
                    }
                    if ([cellModel.status isEqualToString:@"CHENEDIN"]) {
                        cellModel.status = @"";
                    }
                }
            }
            
            //end
            for (NSInteger i = intervalFirstMonth + 1 + intervalSecondMonth + 1 + 1; i < 3; i++) {
                YZCalendarModel *model = self.dataArray[i];
                for (YZCalendarCellModel *cellModel in model.dateArray) {
                    cellModel.bgColor = [UIColor whiteColor];
                    cellModel.isSelect = true;
                    if ([cellModel.status isEqualToString:@"BOOKED"]) {
                        cellModel.isSelect = false;
                    }
                }
            }
            [self.tableView reloadData];
        }
    }
}


@end



























































