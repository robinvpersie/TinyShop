//
//  HotelChoosePriceView.m
//  Portal
//
//  Created by ifox on 2017/3/30.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelChoosePriceView.h"
#import "UIButton+CreateButton.h"
#import "UILabel+CreateLabel.h"

#define ItemWidth (APPScreenWidth - 30 - 20)/5
#define ItemHeight 20

@interface HotelChoosePriceView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *starTitles;
@property (nonatomic, strong) NSArray *priceTitles;
@property (nonatomic, strong) NSMutableArray *starButtonArr;
@property (nonatomic, strong) NSMutableArray *priceButtonArr;

@end

@implementation HotelChoosePriceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self beforeCreateView];
        [self createView];
    }
    return self;
}

- (void)beforeCreateView {
    self.userInteractionEnabled = YES;
    _starTitles = @[@"不限",@"经济",@"三星/舒适",@"四星/高档",@"五星/豪华"];
    _priceTitles = @[@"不限",@"￥0-150",@"￥151-300",@"￥301-450",@"￥451-600",@"￥501-1000",@"￥1000以上"];
    _starButtonArr = @[].mutableCopy;
    _priceButtonArr = @[].mutableCopy;
}

- (void)createView {
    UITapGestureRecognizer *tapBackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    [self addGestureRecognizer:tapBackGesture];
    
    UIView *contentView = [[UIView alloc] initWithFrame:(CGRect){0, APPScreenHeight - APPScreenHeight/3, APPScreenWidth, 210}];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UIButton *reset = [UIButton createButtonWithFrame:CGRectMake(15, contentView.frame.size.height - 15 - 40, (APPScreenWidth - 30 - 10)/6, 40) title:@"重置" titleColor:[UIColor grayColor] titleFont:[UIFont systemFontOfSize:15] backgroundColor:[UIColor whiteColor]];
    reset.layer.borderColor = [UIColor grayColor].CGColor;
    reset.layer.borderWidth = 0.5f;
    reset.layer.cornerRadius = 4;
    [reset addTarget:self action:@selector(resetAllButton) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:reset];
    
    UIButton *sure = [UIButton createButtonWithFrame:CGRectMake(CGRectGetMaxX(reset.frame)+10, reset.frame.origin.y, reset.frame.size.width*5, reset.frame.size.height) title:@"确定" titleColor:[UIColor whiteColor] titleFont:reset.titleLabel.font backgroundColor:PurpleColor];
    sure.layer.cornerRadius = 4;
    [contentView addSubview:sure];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, CGRectGetMinY(reset.frame) - 10) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return ItemHeight+2;
    } else {
        return (ItemHeight*2+2+10);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        for (int i = 0; i < _starTitles.count; i++) {
            UIButton *button = [self createButtonWithOriginX:15+i*(5+ItemWidth) OriginY:1 title:_starTitles[i]];
            [_starButtonArr addObject:button];
            [cell.contentView addSubview:button];
        }
    }
    if (indexPath.section == 1) {
        for (int i = 0; i < _priceTitles.count; i++) {
            NSInteger line = i/5;
            NSInteger column = i%5;
            UIButton *button = [self createButtonWithOriginX:15+column*(5+ItemWidth) OriginY:1+line*(5+ItemHeight) title:_priceTitles[i]];
            [_priceButtonArr addObject:button];
            [cell.contentView addSubview:button];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *text;
    if (section == 0) {
        text = @"    星级(可多选)";
    } else {
        text = @"    价格区间";
    }
    UILabel *title = [UILabel createLabelWithFrame:CGRectMake(15, 0, APPScreenWidth, 35) textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft text:text];
    title.backgroundColor = [UIColor whiteColor];
    return title;
}

- (void)resetAllButton {
    for (UIButton *button in _starButtonArr) {
        button.selected = NO;
    }
    for (UIButton *button in _priceButtonArr) {
        button.selected = NO;
    }
}

- (UIButton *)createButtonWithOriginX:(CGFloat)x
                              OriginY:(CGFloat)y
                                title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, ItemWidth, ItemHeight);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 0.5f;
    button.layer.borderColor = [UIColor grayColor].CGColor;
    [button setBackgroundImage:[UIImage imageNamed:@"purplebg"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonSelected:(UIButton *)button {
    button.selected = !button.selected;
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    __weak typeof(self) _weakSelf = self;
    self.contentView.frame = CGRectMake(0, APPScreenHeight, APPScreenWidth, 210);
    
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _weakSelf.contentView.frame = CGRectMake(0, APPScreenHeight - 210, APPScreenWidth, 210);
    }completion:^(BOOL finished) {
        
    }];
    
}

- (void)removeView {
    __weak typeof(self) _weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        _weakSelf.backgroundColor = [UIColor clearColor];
         _weakSelf.contentView.frame = CGRectMake(0, APPScreenHeight, APPScreenWidth, 210);
    } completion:^(BOOL finished) {
        [_weakSelf removeFromSuperview];
    }];
}


@end
