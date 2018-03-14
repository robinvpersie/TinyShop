//
//  SupermarketChooseTimeCell.m
//  Portal
//
//  Created by ifox on 2016/12/15.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketChooseTimeCell.h"

@implementation SupermarketChooseTimeCell {
    UILabel *date;
    UILabel *weekDate;
    UILabel *time;
    UIButton *checkAm;
    UIButton *checkPm;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createView {
    date = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 25)];
    date.textColor = GreenColor;
    date.font = [UIFont systemFontOfSize:17];
    date.text = @"11月14日";
    [self addSubview:date];
    
    weekDate = [[UILabel alloc] initWithFrame:CGRectMake(date.frame.origin.x, CGRectGetMaxY(date.frame), 100, 15)];
    weekDate.textColor = [UIColor grayColor];
    weekDate.font = [UIFont systemFontOfSize:11];
    weekDate.text = @"(星期六)";
    [self addSubview:weekDate];
    
    time = [[UILabel alloc] initWithFrame:CGRectMake(APPScreenWidth - 80 - 15, weekDate.frame.origin.y, 80, weekDate.frame.size.height)];
    time.textColor = GreenColor;
    time.font = [UIFont systemFontOfSize:13];
    time.textAlignment = NSTextAlignmentRight;
    time.text = @"明天";
    [self addSubview:time];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(time.frame)+5, APPScreenWidth, 0.7f)];
    line.backgroundColor = RGB(241, 241, 241);
    [self addSubview:line];
    
    checkAm = [UIButton buttonWithType:UIButtonTypeCustom];
    checkAm.tag = 100;
    [checkAm addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    checkAm.frame = CGRectMake(date.frame.origin.x, CGRectGetMaxY(line.frame)+10, 25, 25);
    [checkAm setImage:[UIImage imageNamed:@"icon_selected-n"] forState:UIControlStateNormal];
    [checkAm setImage:[UIImage imageNamed:@"icon_selected-s"] forState:UIControlStateSelected];
    [self addSubview:checkAm];
    
    UILabel *amTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(checkAm.frame)+10, checkAm.frame.origin.y, 200, checkAm.frame.size.height)];
    amTime.textColor = [UIColor darkGrayColor];
    amTime.text = @"上午  9:30 -- 12:00";
    amTime.font = [UIFont systemFontOfSize:16];
    [self addSubview:amTime];
    
    checkPm = [UIButton buttonWithType:UIButtonTypeCustom];
    checkPm.tag = 200;
    [checkPm addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    checkPm.frame = CGRectMake(checkAm.frame.origin.x, CGRectGetMaxY(checkAm.frame)+10, checkAm.frame.size.height, checkAm.frame.size.height);
    [checkPm setImage:[UIImage imageNamed:@"icon_selected-n"] forState:UIControlStateNormal];
    [checkPm setImage:[UIImage imageNamed:@"icon_selected-s"] forState:UIControlStateSelected];
    [self addSubview:checkPm];
    
    UILabel *pmTime = [[UILabel alloc] initWithFrame:CGRectMake(amTime.frame.origin.x, checkPm.frame.origin.y, 200, checkPm.frame.size.height)];
    pmTime.textColor = [UIColor darkGrayColor];
    pmTime.text = @"下午  16:00 -- 19:00";
    pmTime.font = amTime.font;
    [self addSubview:pmTime];
}

- (void)selectTime:(UIButton *)button {
    button.selected = !button.selected;
    
    [self.delegate clickCheckButton:button];
}

- (void)setTimeModel:(SupermarketReceiveTimeModel *)timeModel {
    _timeModel = timeModel;
    date.text = timeModel.date;
    time.text = timeModel.dayAfter;
    weekDate.text = timeModel.weekDay;
    if (timeModel.selectedAm == YES) {
        checkAm.selected = YES;
    }
    if (timeModel.selectedPm == YES) {
        checkPm.selected = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
