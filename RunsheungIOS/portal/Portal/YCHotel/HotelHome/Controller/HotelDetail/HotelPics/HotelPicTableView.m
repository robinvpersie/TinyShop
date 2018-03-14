//
//  HotelPicTableView.m
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelPicTableView.h"
#import "UILabel+CreateLabel.h"
#import "HotelPicTableViewCell.h"

@interface HotelPicTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HotelPicTableView {
    NSArray *_sectionTitles;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _sectionTitles = @[@"    外观(0)",@"    大厅(0)",@"    客房(0)",@"    公共设施(0)"];
        self.dataSource = self;
        self.delegate = self;
        self.separatorColor = [UIColor clearColor];
        [self registerClass:[HotelPicTableViewCell class] forCellReuseIdentifier:@"HotelPicCell"];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_picType == PicTypeAll) {
        return 4;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *title = [UILabel createLabelWithFrame:CGRectMake(0, 0, APPScreenWidth, 30) textColor:HotelGrayColor font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft text:_sectionTitles[section]];
    if (_picType == PicTypeOutLook) {
        title.text = [NSString stringWithFormat:@"    %@(%ld)",NSLocalizedString(@"HotelPicOut", nil),((NSArray *)_dataArr.firstObject).count];
    } else if (_picType == PicTypeHall) {
        title.text = [NSString stringWithFormat:@"    %@(%ld)",NSLocalizedString(@"HotelPicHall", nil),((NSArray *)_dataArr.firstObject).count];
    } else if (_picType == PicTypeRoom) {
        title.text = [NSString stringWithFormat:@"    %@(%ld)",NSLocalizedString(@"HotelPicRoom", nil),((NSArray *)_dataArr.firstObject).count];
    } else if (_picType == PicTypeFacility) {
        title.text = [NSString stringWithFormat:@"    %@(%ld)",NSLocalizedString(@"HotelPicFacility", nil),((NSArray *)_dataArr.firstObject).count];
    }
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *imageArr = _dataArr[indexPath.section];
    if (imageArr.count > 0) {
        NSInteger line = (imageArr.count + 1)/2;
        NSInteger space = (imageArr.count - 1)/2;
        CGFloat cellHeight = 110*line + 15*space;
        NSLog(@"%@-------%f-------%ld",indexPath,cellHeight,imageArr.count);
        return cellHeight;
    } else {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelPicTableViewCell *cell = [[HotelPicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HotelPicCell"];
    if (_dataArr.count > 0) {
     cell.imageArr = _dataArr[indexPath.section];   
    }
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"TableViewIndexPath:%@",indexPath);
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    if (_picType == PicTypeAll) {
        _sectionTitles = @[[NSString stringWithFormat:@"    %@(%ld)",NSLocalizedString(@"HotelPicOut", nil),((NSArray *)dataArr[0]).count],[NSString stringWithFormat:@"    %@(%ld)",NSLocalizedString(@"HotelPicHall", nil),((NSArray *)dataArr[1]).count],[NSString stringWithFormat:@"    %@(%ld)",NSLocalizedString(@"HotelPicRoom", nil),((NSArray *)dataArr[2]).count],[NSString stringWithFormat:@"    %@(%ld)",NSLocalizedString(@"HotelPicFacility", nil),((NSArray *)dataArr[3]).count]];
    }
    
    [self reloadData];
}

@end
