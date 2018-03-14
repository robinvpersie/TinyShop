//
//  HotelDetailIntroTableView.m
//  Portal
//
//  Created by ifox on 2017/4/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelDetailIntroTableView.h"
#import "UILabel+CreateLabel.h"
#import "HotelIntroPhoneCell.h"
#import "HotelSupportServiceView.h"
#import "HotelDetailedTraficCell.h"
#import "HotelDetailInfoModel.h"
#import "HotelRoomInfoServiceModel.h"

#define INTRODUCERATIA 45/49

@interface HotelDetailIntroTableView ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *serviceData;
@end

@implementation HotelDetailIntroTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self registerCell];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)registerCell {
    UINib *nib = [UINib nibWithNibName:@"HotelIntroPhoneCell" bundle:nil];
    [self registerNib:nib forCellReuseIdentifier:@"HotelIntroPhoneCell"];
    
    UINib *nib1 = [UINib nibWithNibName:@"HotelDetailedTraficCell" bundle:nil];
    [self registerNib:nib1 forCellReuseIdentifier:@"HotelDetailedTraficCell"];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70;
    }else if (indexPath.row == 1){
        
        float height =(((self.serviceData.count/4.0f)>(int)(self.serviceData.count/4))?((int)(self.serviceData.count/4)+1):(self.serviceData.count/4))*50 +30;
        return height;
   
    }else if(indexPath.row == 2){
        return 190;
    
    }else{
      
        if (_detailModel.description.length) {
            NSLog(@"%f",[self heightForString:_detailModel.description andWidth:APPScreenWidth]);
            return [self heightForString:_detailModel.hotelDescription andWidth:APPScreenWidth]+30;
        }else{
            return 30;
        }
    }
   
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (indexPath.row == 0) {
        HotelIntroPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelIntroPhoneCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _detailModel;
        return cell;
    }else if(indexPath.row == 1){
        UILabel *titleView =[UILabel createLabelWithFrame:CGRectMake(15, 10, 180, 20) textColor:HotelBlackColor font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft text:@"可提供的服务"];
        [cell.contentView addSubview:titleView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        HotelSupportServiceView *supportView = [[HotelSupportServiceView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), APPScreenWidth,((self.serviceData.count/4.0f)>(int)(self.serviceData.count/4)?((int)(self.serviceData.count/4)+1):(self.serviceData.count/4))*50 )];
        
        supportView.serviceArr = self.serviceData;
        [cell.contentView addSubview:supportView];
        return cell;
    }else  if (indexPath.row == 2) {
        HotelIntroPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelDetailedTraficCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UILabel *descriptionLab = [UILabel createLabelWithFrame:CGRectMake(10.0f, 0, 100, 22) textColor:HotelBlackColor font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft text:@"酒店介绍"];
        [cell.contentView addSubview:descriptionLab];
        if (_detailModel.description.length) {
            UILabel *introHotel  = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(descriptionLab.frame), APPScreenWidth , [self heightForString:_detailModel.hotelDescription andWidth:APPScreenWidth])];
            introHotel.numberOfLines = 0;
            introHotel.font = [UIFont systemFontOfSize:14];
            [introHotel setTextColor:HotelGrayColor];
            [introHotel setText:[NSString stringWithFormat:@"    %@",_detailModel.hotelDescription]];
            [cell.contentView addSubview:introHotel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
           }
    
    return cell;
}

- (void)setDetailModel:(HotelDetailInfoModel *)detailModel{
    _detailModel = detailModel;
    self.serviceData = [self reorganizingData:detailModel.serviceInfos];
    [self reloadData];
}

#pragma mark -- 重组数据
- (NSMutableArray*)reorganizingData:(NSArray*)array{
    NSMutableArray *data = @[].mutableCopy;
    
    for (int i = 0;i<array.count;i++ ) {
        HotelRoomInfoServiceModel*model = array[i];
        NSDictionary*dic = @{model.imageUrl:model.serviceDetailName};
        [data addObject:dic];
    }
    
    return data;
}

#pragma mark --- 返回的高度
- (float) heightForString:(NSString *)value andWidth:(float)width{
    

    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
    NSRange range = NSMakeRange(0, attrStr.length);
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
   
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading                                         attributes:dic
                                           context:nil].size;
    return sizeToFit.height + 16.0;
}
@end
