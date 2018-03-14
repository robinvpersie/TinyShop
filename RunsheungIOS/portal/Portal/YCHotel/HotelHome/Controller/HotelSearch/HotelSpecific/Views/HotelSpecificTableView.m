//
//  HotelSpecificTableView.m
//  Portal
//
//  Created by 王五 on 2017/4/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelSpecificTableView.h"
#import "HotelSpecificTableCell.h"
#import "HotelHeadView.h"
#import "HotelDownTableViewCell.h"
#import "HotelCommentAndDetailedView.h"
#import "HotelRoomTypeModel.h"
#define tableHeadHeight 0.55 *APPScreenWidth

@interface HotelSpecificTableView ()<UITableViewDelegate, UITableViewDataSource,HotelSpecificDelegate>
@end
@implementation HotelSpecificTableView{
    CGRect _frame1;
}



- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initUI:frame];
        _frame1 = frame;
        
    }
    return self;
}

- (void)setHotelroomData:(NSArray *)hotelroomData{
    _hotelroomData = hotelroomData;
    self.frame = CGRectMake(0,CGRectGetMinY(_frame1), APPScreenWidth, _hotelroomData.count*100+(_hotelroomData.count - 1)*10);

    [self reloadData];
    
}
- (void)initUI:(CGRect)frame{
    
    [self registerNib:[UINib nibWithNibName:@"HotelSpecificTableCell" bundle:nil] forCellReuseIdentifier:@"specificTableViewCell"];
    [self registerNib:[UINib nibWithNibName:@"HotelDownTableViewCell" bundle:nil] forCellReuseIdentifier:@"HotelDownTableViewCell"];
    self.backgroundColor = BGColor;
    [self setSeparatorColor:BGColor];
    self.delegate = self;
    self.dataSource = self;
    self.showsVerticalScrollIndicator = NO;
    self.scrollEnabled = NO;
    
}

#pragma mark -- 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
      return 1 ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.hotelroomData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelRoomTypeModel *model = self.hotelroomData[indexPath.section];
    HotelSpecificTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"specificTableViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    cell.roommodel = model;
    cell.hotelID = self.hotelID;
    cell.hotelName = self.hotelName;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
 }
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tabledelegate respondsToSelector:@selector(tableViewSelectCell:)]) {
        [self.tabledelegate tableViewSelectCell:self.hotelroomData[indexPath.section]];
    }
}
- (void)sumbitAction:(id)viewVC{
    if ([self.tabledelegate respondsToSelector:@selector(talbeViewSumbitAction:)]) {
        [self.tabledelegate talbeViewSumbitAction:viewVC];
    }
}



@end
