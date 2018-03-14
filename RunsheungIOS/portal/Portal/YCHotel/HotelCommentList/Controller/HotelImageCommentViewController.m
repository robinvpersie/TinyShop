//
//  HotelImageCommentViewController.m
//  Portal
//
//  Created by ifox on 2017/5/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelImageCommentViewController.h"
#import "HotelCommentTableView.h"

@interface HotelImageCommentViewController ()

@property(nonatomic, strong) HotelCommentTableView *commentTableView;
@property(nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation HotelImageCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.commentTableView];
    _dataArr = @[].mutableCopy;
    [self requestData];
}

- (void)requestData {
    [YCHotelHttpTool hotelGetCommentListWithHotelID:self.hotelID optionIndex:1 pageIndex:0 success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSArray *ratedList = data[@"RatedList"];
            if (ratedList.count > 0) {
                for (NSDictionary *dic in ratedList) {
                    HotelCommentModel *model = [NSDictionary getHotelCommentModelWithDic:dic];
                    [_dataArr addObject:model];
                }
            }
            _commentTableView.dataArray = _dataArr;
        }
    } failure:^(NSError *err) {
        
    }];
}


- (HotelCommentTableView *)commentTableView {
    if (_commentTableView == nil) {
        _commentTableView = [[HotelCommentTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 44) style:UITableViewStylePlain];
    }
    return _commentTableView;
}

@end
