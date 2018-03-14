//
//  HotelAllCommentViewController.m
//  Portal
//
//  Created by ifox on 2017/5/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelAllCommentViewController.h"
#import "HotelCommentTableView.h"
#import "HotelVirtualComments.h"
#import "HotelCommentScoreView.h"

@interface HotelAllCommentViewController ()

@property(nonatomic, strong) HotelCommentTableView *commentTableView;
@property(nonatomic, strong) HotelCommentScoreView *headerView;
@property(nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation HotelAllCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.commentTableView];
    
//    NSArray *dataArray = [HotelVirtualComments getHotelComments];
//    _commentTableView.dataArray = dataArray;
    _dataArr = @[].mutableCopy;
    
    _headerView = [[HotelCommentScoreView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 120)];
    self.commentTableView.tableHeaderView = _headerView;
    
    
    [self requestData];
}

- (void)requestData {
    [YCHotelHttpTool hotelGetCommentListWithHotelID:self.hotelID optionIndex:0 pageIndex:0 success:^(id response) {
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
            
            NSDictionary *hotelRated = ((NSArray *)data[@"HotelRated"]).firstObject;
            
            _headerView.totalScore = ((NSNumber *)hotelRated[@"total_score"]).floatValue;
            _headerView.facilityScore = ((NSNumber *)hotelRated[@"facilitiesproportion"]).floatValue;
            _headerView.hygieneScore = ((NSNumber *)hotelRated[@"hygienescore"]).floatValue;
            _headerView.serviceScore = ((NSNumber *)hotelRated[@"servicescore"]).floatValue;
            _headerView.locationScore = ((NSNumber *)hotelRated[@"environmentalscore"]).floatValue;
            
            NSNumber *totalCout = hotelRated[@"total_count"];
            NSNumber *highCount = hotelRated[@"ratedforPraise_count"];
            NSNumber *midCount = hotelRated[@"ratedforzhong_count"];
            NSNumber *lowScoreCout = hotelRated[@"ratedforLow_count"];
            NSNumber *imageCout = hotelRated[@"ratedforImg_count"];
            
            if (totalCout != nil && imageCout != nil && lowScoreCout != nil) {
                [[NSNotificationCenter defaultCenter] postNotificationName:HotelCommentListCountNotification object:@[totalCout,highCount,midCount,lowScoreCout,imageCout]];
            }
            
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
