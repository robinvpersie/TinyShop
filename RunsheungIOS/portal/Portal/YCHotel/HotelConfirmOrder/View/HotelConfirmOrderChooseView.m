//
//  HotelChooseView.m
//  Portal
//
//  Created by ifox on 2017/4/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelConfirmOrderChooseView.h"
#import "UILabel+CreateLabel.h"
#import "UIButton+CreateButton.h"
#import "TPKeyboardAvoidingTableView.h"
#import "HotelRetainTimeModel.h"

@interface HotelConfirmOrderChooseView()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *check;
@property(nonatomic, strong) NSIndexPath *lastIndexPath;

@end

@implementation HotelConfirmOrderChooseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
//    UITapGestureRecognizer *tapBackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
//    [self addGestureRecognizer:tapBackGesture];
    
    UIView *contentView = [[UIView alloc] initWithFrame:(CGRect){0, APPScreenHeight - APPScreenHeight/3, APPScreenWidth, APPScreenHeight/3}];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    _titleLabel = [UILabel createLabelWithFrame:CGRectMake(0, 0, 200, 40) textColor:HotelGrayColor font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter text:@""];
    [_contentView addSubview:_titleLabel];
    CGPoint titleCenter = _titleLabel.center;
    titleCenter.x = _contentView.center.x;
    _titleLabel.center = titleCenter;
    
     UIButton *cancel = [UIButton createButtonWithFrame:CGRectMake(APPScreenWidth - 50 - 10, 0, 50, 40) title:@"取消" titleColor:HotelGrayColor titleFont:[UIFont systemFontOfSize:13] backgroundColor:[UIColor whiteColor]];
    [cancel addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:cancel];
    
    _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), APPScreenWidth, _contentView.frame.size.height - _titleLabel.frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = BorderColor;
    [_contentView addSubview:_tableView];
    
    _check = [[UIImageView alloc] initWithFrame:CGRectMake(APPScreenWidth - 25 - 10, 10, 20, 20)];
    _check.contentMode = UIViewContentModeScaleAspectFit;
    _check.image = [UIImage imageNamed:@"icon_tick"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataSource.count > 0) {
        return _dataSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = HotelBlackColor;
    if (_dataSource.count > 0) {
        id title = _dataSource[indexPath.row];
        if ([title isKindOfClass:[NSString class]]) {
            cell.textLabel.text = title;
        } else if ([title isKindOfClass:[HotelRetainTimeModel class]]) {
            HotelRetainTimeModel *model = title;
            cell.textLabel.text = model.dictValue;
        }
        if (_defaultChoose) {
            if (indexPath.row == 1) {
                [cell.contentView addSubview:_check];
                _lastIndexPath = indexPath;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_lastIndexPath != nil) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:_lastIndexPath];
        cell.textLabel.textColor = HotelBlackColor;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.contentView addSubview:_check];
    cell.textLabel.textColor = PurpleColor;
    _lastIndexPath = indexPath;
    [self removeView];
    if ([self.delegate respondsToSelector:@selector(didSelectedRowTitle:indexPath:chooseView:)]) {
        [self.delegate didSelectedRowTitle:cell.textLabel.text indexPath:indexPath chooseView:self];
    }
    NSLog(@"%@",cell.textLabel.text);
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setDefaultChoose:(BOOL)defaultChoose {
    _defaultChoose = defaultChoose;
    [self.tableView reloadData];
}

- (void)setDelegate:(id<HotelConfirmOrderChooseViewDelegate>)delegate {
    _delegate = delegate;
    if ([_delegate respondsToSelector:@selector(didSelectedRowTitle:indexPath:chooseView:)]) {
        NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath0];
        [self.delegate didSelectedRowTitle:cell.textLabel.text indexPath:indexPath0 chooseView:self];
    }

}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    __weak typeof(self) _weakSelf = self;
    self.contentView.frame = CGRectMake(0, APPScreenHeight, APPScreenWidth, 210);
    
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _weakSelf.contentView.frame = CGRectMake(0, APPScreenHeight - APPScreenHeight/3, APPScreenWidth, APPScreenHeight/3);
    }completion:^(BOOL finished) {
        
    }];

}

- (void)removeView {
    __weak typeof(self) _weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        _weakSelf.backgroundColor = [UIColor clearColor];
        _weakSelf.contentView.frame = CGRectMake(0, APPScreenHeight, APPScreenWidth, APPScreenHeight/3);
    } completion:^(BOOL finished) {
        [_weakSelf removeFromSuperview];
    }];
}

@end
