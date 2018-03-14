//
//  YCHotelMineViewController.m
//  Portal
//
//  Created by ifox on 2017/3/29.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCHotelMineViewController.h"
#import "HotelMineHeaderView.h"

#define kItemsWidth APPScreenWidth/4

@interface YCHotelMineViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation YCHotelMineViewController {
    NSArray *_icons;
    NSArray *_titles;
    
    NSArray *_footerTitles;
    NSArray *_footerIcons;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGColor;
    
    _icons = @[@"icon_mycomments",@"icon_myrefund",@"icon_help",@"icon_customerservice"];
    _titles = @[@"我的点评",@"我的退款",@"帮助中心",@"联系客服"];
    
    _footerIcons = @[@"icon_p_cash",@"icon_p_coupon",@"icon_p_card",@"icon_p_point"];
    _footerTitles = @[@"现金",@"优惠券",@"礼品卡",@"积分"];
    
    [self createView];
    // Do any additional setup after loading the view.
}

- (void)createView {
    [self.view addSubview:self.tableView];
    
    HotelMineHeaderView *header = [[HotelMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight/4)];
    self.tableView.tableHeaderView = header;
}

#pragma mark -- UITableViewDataSource & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return kItemsWidth;
    } else {
        return 0.1f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 4;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, kItemsWidth)];
        bgview.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < 4; i++) {
            UIView *view = [self createSingelItemWithImageName:_footerIcons[i] andtitleName:_footerTitles[i] andIndex:i];
            [bgview addSubview:view];
        }
        return bgview;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = HotelBlackColor;
    if (indexPath.section == 0) {
        UIImage *icon = [UIImage imageNamed:@"icon_mywallet"];
        CGSize itemSize = CGSizeMake(20, 18);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.textLabel.text = @"我的钱包";
    } else {
        UIImage *icon = [UIImage imageNamed:_icons[indexPath.row]];
        CGSize itemSize = CGSizeMake(20, 18);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.textLabel.text = _titles[indexPath.row];
    }
    return cell;
}

- (UIView *)createSingelItemWithImageName:(NSString *)imageName andtitleName:(NSString *)titileName andIndex:(NSInteger)index {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((index%4) * kItemsWidth, index/4*kItemsWidth, kItemsWidth, kItemsWidth)];
    view.tag = 100+index;
    view.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, kItemsWidth - 50, kItemsWidth - 50)];
    logoView.image = [UIImage imageNamed:imageName];
    [view addSubview:logoView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(logoView.frame)+5, logoView.frame.size.width, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = titileName;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor darkGrayColor];
    [view addSubview:titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSingleItem:)];
    [view addGestureRecognizer:tap];
    return view;
}

- (void)tapSingleItem:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, APPScreenWidth, APPScreenHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = BGColor;
    }
    return _tableView;
}

@end
