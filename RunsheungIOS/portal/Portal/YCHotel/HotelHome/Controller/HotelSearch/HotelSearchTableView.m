//
//  HotelSearchTableView.m
//  Portal
//
//  Created by ifox on 2017/4/1.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelSearchTableView.h"
#import "HotelSearchTableViewCell.h"
#import "UILabel+CreateLabel.h"
#import "HotelCityModel.h"

@interface HotelSearchTableView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSArray *sectionTitles;

@end

@implementation HotelSearchTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _sectionTitles = @[@"    当前选择",@"    酒店所在城市"];
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = BGColor;
        self.separatorColor = [UIColor clearColor];
        [self registerClass:[HotelSearchTableViewCell class] forCellReuseIdentifier:@"cell"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:HotelCityListReloadCityNotification object:nil];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 45;
    }
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *sectionTitle = [UILabel createLabelWithFrame:CGRectMake(0, 0, APPScreenWidth, 35) textColor:HotelGrayColor font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft text:_sectionTitles[section]];
    sectionTitle.backgroundColor = [UIColor whiteColor];
    return sectionTitle;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelSearchTableViewCell *cell = [[HotelSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.contentView.backgroundColor = BGColor;
    if (indexPath.section == 0) {
        NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:HotelChooseCityName];
        HotelCityModel *city = [[HotelCityModel alloc] init];
        cell.userInteractionEnabled = NO;
        if (cityName.length > 0) {
            city.cityName = cityName;
            cell.citys = @[city];
        } else {
            if (_dataArr.count > 0) {
                cell.citys = @[_dataArr.firstObject];
            }
        }
    } else {
        cell.citys = _dataArr;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)loadData {
    [self reloadData];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self reloadData];
}

@end
