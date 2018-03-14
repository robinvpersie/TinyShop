//
//  HotelOutLookController.m
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelOutLookController.h"
#import "HotelPicTableView.h"

@interface HotelOutLookController ()

@property(nonatomic, strong) HotelPicTableView *hotelPicTableView;
@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong) NSMutableArray *outLookArr;

@end

@implementation HotelOutLookController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = @[].mutableCopy;
    _outLookArr = @[].mutableCopy;
    
    _hotelPicTableView = [[HotelPicTableView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height- 64 - 40) style:UITableViewStyleGrouped];
    _hotelPicTableView.picType = PicTypeOutLook;
    [self.view addSubview:_hotelPicTableView];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)requestData {
    [YCHotelHttpTool hotelGetImagesWithHotelID:self.hotelID imageType:1 success:^(id response) {
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSArray *data = response[@"data"];
            if (data.count > 0) {
                for (NSDictionary *dic in data) {
                    HotelAlbumImageModel *model = [NSDictionary getHotelAlbumModelWithDic:dic];
                    [_outLookArr addObject:model];
                }
                [_dataArr addObject:_outLookArr];
                _hotelPicTableView.dataArr = _dataArr;
            }
        }
    }failure:^(NSError *err) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
