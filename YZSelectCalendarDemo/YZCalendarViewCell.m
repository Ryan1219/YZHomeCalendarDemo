//
//  YZCalendarView.m
//  YZSelectCalendarDemo
//
//  Created by Q房通 on 2017/11/29.
//  Copyright © 2017年 Q房通. All rights reserved.
//

#import "YZCalendarViewCell.h"
#import "YZCalendarCollectionViewCell.h"

@interface YZCalendarViewCell () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
/* <#description#> */
@property (nonatomic,strong) UILabel *monthLabel;
/* <#description#> */
@property (nonatomic,strong) UICollectionView *collectionView;
/* <#description#> */
@property (nonatomic,strong) NSArray *weekArray;

@end

@implementation YZCalendarViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *calendarTableViewCellIndentifier = @"calendarTableViewCellIndentifier";
    YZCalendarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:calendarTableViewCellIndentifier];
    if (!cell) {
        cell = [[YZCalendarViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:calendarTableViewCellIndentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        self.weekArray = [[NSArray alloc] initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
        [self configView];
    }
    return self;
}

- (void)configView {
    
    CGFloat itemW = ScreenWidth / 7;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HSColor(0x999999);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    self.monthLabel = [[UILabel alloc] init];
    self.monthLabel.textColor = [UIColor blackColor];
    self.monthLabel.font = [UIFont systemFontOfSize:14];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.monthLabel];
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(40);
        make.right.mas_equalTo(self.mas_right).offset(-40);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(40);
    }];
    
    
    for (int i = 0; i < 7; i++) {
        UILabel *weekLabel = [[UILabel alloc] init];
        weekLabel.text = self.weekArray[i];
        weekLabel.textColor = HSColor(0x15cc9c);
        weekLabel.font = [UIFont systemFontOfSize:14];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:weekLabel];
        [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(itemW * i);
            make.width.height.mas_equalTo(itemW);
            make.top.mas_equalTo(self.monthLabel.mas_bottom);
        }];
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(itemW, itemW);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置所有item的范围
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 0; //水平滑动的时候有作用
    flowLayout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = false;
    [self.collectionView registerClass:[YZCalendarCollectionViewCell class] forCellWithReuseIdentifier:@"calendarCollectionViewCellIndentifier"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.monthLabel.mas_bottom).offset(itemW);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
}

//MARK:--UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    

    return _calendarModel.dateArray.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YZCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"calendarCollectionViewCellIndentifier" forIndexPath:indexPath];
    
    NSInteger index = indexPath.row;
    cell.cellModel = _calendarModel.dateArray[index];


    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_calendarModel.date];
    
    NSInteger firstWeekDay = [NSDateTool firstWeekdayInThisMonth:_calendarModel.date];
    
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    day = i - firstWeekDay + 1;
    
    NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld",components.year,components.month,day];
    NSLog(@"--%@--",dateString);
    NSDate *date = [NSDateTool dateFormatterWithDateString:dateString];
    NSLog(@"---date--%@",date);
    
    YZCalendarCellModel *dateModel = _calendarModel.dateArray[indexPath.row];
    if (self.calendarViewCellBlock) {
        self.calendarViewCellBlock(date, components.year, components.month, day, firstWeekDay,indexPath,dateModel);
    }
    
    
    if (self.calendarViewCellDateBlock) {
        self.calendarViewCellDateBlock(dateModel);
    }

}

- (void)setCalendarModel:(YZCalendarModel *)calendarModel {
    _calendarModel = calendarModel;
    self.monthLabel.text = [NSString stringWithFormat:@"%ld年%ld月",[NSDateTool year:calendarModel.date],[NSDateTool month:calendarModel.date]];
    [self.collectionView reloadData];
}





@end




























