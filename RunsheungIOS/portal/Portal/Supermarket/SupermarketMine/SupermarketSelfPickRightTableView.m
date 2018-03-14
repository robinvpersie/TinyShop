//
//  SupermarketSelfPickRightTableView.m
//  Portal
//
//  Created by ifox on 2016/12/19.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketSelfPickRightTableView.h"

#define CircleWidth 20

@implementation SupermarketSelfPickRightTableView {
//    UIImageView *_circle;
//    UIView      *_line;
//    UILabel     *_addressLabel;
//    UILabel *addressLabel;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
//        CGRect tableViewFrame = self.frame;
//        tableViewFrame.size.height = 70*4;
//        self.frame = tableViewFrame;
        self.scrollEnabled = NO;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray.count > 0) {
        return _dataArray.count;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rightCell"];
    
    
    UIImageView *circle = [[UIImageView alloc] initWithFrame:CGRectMake(15, 35 - CircleWidth/2, CircleWidth, CircleWidth)];
    circle.image = [UIImage imageNamed:@"circle"];
    [cell.contentView addSubview:circle];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(circle.frame)+5, circle.frame.origin.y, self.frame.size.width - CircleWidth - 10 - 15, 40)];
    addressLabel.textColor = [UIColor darkGrayColor];
    addressLabel.font = [UIFont systemFontOfSize:14];
    addressLabel.text = @"时光是帅哥和时光就是就是技术贾经理根据拉萨的价格拉斯";
    if (_dataArray.count > 0) {
        NSDictionary *dic = _dataArray[indexPath.row];
        addressLabel.text = dic[@"site_name"];
    }
    addressLabel.numberOfLines = 0;
    [addressLabel sizeToFit];
    
    [cell.contentView addSubview:addressLabel];
    
    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(25, 0, 1.2f, CGRectGetMinY(circle.frame))];
    upLine.backgroundColor = GreenColor;
    [cell.contentView addSubview:upLine];
    
    if (indexPath.row == 0) {
        upLine.hidden = YES;
    }
    
    UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(upLine.frame.origin.x, CGRectGetMaxY(circle.frame), 1.2f, 70-CGRectGetMaxY(circle.frame))];
    downLine.backgroundColor = GreenColor;
    [cell.contentView addSubview:downLine];
    
    if (indexPath.row == 3) {
        downLine.hidden = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self reloadData];
}

@end
