//
//  HotelAllPicsController.m
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelAllPicsController.h"
#import "HotelPicTableView.h"
#import "HotelAlbumImageModel.h"

@interface HotelAllPicsController ()

@property(nonatomic, strong) HotelPicTableView *hotelPicTableView;
@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong) NSMutableArray *outLookArr;
@property(nonatomic, strong) NSMutableArray *hallArr;
@property(nonatomic, strong) NSMutableArray *roomArr;
@property(nonatomic, strong) NSMutableArray *facilityArr;

@end

@implementation HotelAllPicsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = @[].mutableCopy;
    _outLookArr = @[].mutableCopy;
    _hallArr = @[].mutableCopy;
    _roomArr = @[].mutableCopy;
    _facilityArr = @[].mutableCopy;
    
    _hotelPicTableView = [[HotelPicTableView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height - 64 - 40) style:UITableViewStyleGrouped];
    _hotelPicTableView.picType = PicTypeAll;
    [self.view addSubview:_hotelPicTableView];
    
    [self requestData];
}

- (void)requestData {
    [YCHotelHttpTool hotelGetImagesWithHotelID:self.hotelID imageType:0 success:^(id response) {
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSArray *data = response[@"data"];
            if (data.count > 0) {
                for (NSDictionary *dic in data) {
                    HotelAlbumImageModel *model = [NSDictionary getHotelAlbumModelWithDic:dic];
                    if (model.albumType == 1) {
                        [_outLookArr addObject:model];
                    } else if (model.albumType == 2) {
                        [_hallArr addObject:model];
                    } else if (model.albumType == 3) {
                        [_roomArr addObject:model];
                    } else if (model.albumType == 4) {
                        [_facilityArr addObject:model];
                    }
                }
                [_dataArr addObject:_outLookArr];
                [_dataArr addObject:_hallArr];
                [_dataArr addObject:_roomArr];
                [_dataArr addObject:_facilityArr];
                _hotelPicTableView.dataArr = _dataArr;
            }
        }
    } failure:^(NSError *err) {
        
    }];
}

@end
