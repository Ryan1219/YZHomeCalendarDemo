//
//  YZCalendarCollectionViewCell.m
//  YZSelectCalendarDemo
//
//  Created by Q房通 on 2017/11/29.
//  Copyright © 2017年 Q房通. All rights reserved.
//

#import "YZCalendarCollectionViewCell.h"

@interface YZCalendarCollectionViewCell()

@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *priceLabel;


@end

@implementation YZCalendarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configView];
    }
    return self;
}

- (void)configView {
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.textColor = [UIColor blackColor];
    self.dateLabel.font = [UIFont systemFontOfSize:14];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.dateLabel];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textColor = HSColor(0x999999);
    self.priceLabel.font = [UIFont systemFontOfSize:12];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.priceLabel];
    
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(16);
        
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(14);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
    }];
    
}

- (void)setCellModel:(YZCalendarCellModel *)cellModel {
    
    _cellModel = cellModel;
    self.dateLabel.text = cellModel.dateDay;
    self.dateLabel.textColor = cellModel.textColor;
    
    if ([cellModel.status isEqualToString:@"BOOKED"]) {
        self.priceLabel.text = @"无房";
    }
    else if ([cellModel.status isEqualToString:@"CHENEDIN"]) {
        self.priceLabel.text = @"入住";
    }
    else if ([cellModel.status isEqualToString:@"CHENKOUT"]) {
        self.priceLabel.text = @"离开";
    }
    else {
        self.priceLabel.text = cellModel.price;
    }
    
    if (cellModel.bgColor) {
        self.backgroundColor = cellModel.bgColor;;
    }
    if (cellModel.isAvailable) {
        self.userInteractionEnabled = cellModel.isSelect;
    }else {
        self.userInteractionEnabled = false;
    }
}





@end
















