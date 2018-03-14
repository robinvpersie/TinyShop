//
//  HotelSpecificSearchResultController.m
//  Portal
//
//  Created by 王五 on 2017/4/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelSpecificSearchResultController.h"
#import "HotelPicsController.h"
#import "HotelDetailIntroController.h"
#import "HotelConfirmOrderViewController.h"
#import "HotelSpecificTableView.h"
#import "HotelCommentAndDetailedView.h"
#import "HotelDateView.h"
#import "HotelHeadView.h"
#import "HotelChoiceTypeView.h"
#import "HotelHomeListModel.h"
#import "HotelDetailModel.h"
#import "HotelRatedModel.h"
#import "HotelRoomTypeDetailView.h"
#import "HotelRoomInfoModel.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define TABLEVIEWHEADHEIGHT 0.55 *APPScreenWidth
#define UPORDOWNNOTICAFITION @"clickDownOrUpNSNotification"
#define APPNavigaHeight CGRectGetHeight(self.navigationController.navigationBar.frame)
@interface HotelSpecificSearchResultController ()<HotelHeadDelegaete,HotelDetailDelegate,HotelSpecificTableViewDelegate,MKMapViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollview;
@property (nonatomic,strong)HotelSpecificTableView *specificTableView;
@property(nonatomic,strong)HotelCommentAndDetailedView *commentAndDetailedView;
@property(nonatomic,strong)HotelDateView *dateView;
@property(nonatomic,strong)HotelHeadView *headView;
@property(nonatomic,strong)HotelChoiceTypeView *choiceTypeView;
@property(nonatomic,strong)HotelSpecificTableView *tableview;
@property (nonatomic ,strong)HotelDetailModel *detailmodel;
@property(nonatomic, strong) HotelRoomTypeDetailView *roomDetailView;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *urlScheme;
@property (nonatomic, strong) NSString *appName;

@end

@implementation HotelSpecificSearchResultController
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithModel:(id)model{
    self = [super init];
    if (self) {
        self.homelistmodel = (HotelHomeListModel*)model;
        
        [self setNaviItems];
        
    }
     return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.view addSubview:self.createScrollview];
    [self.scrollview addSubview:self.createDateView];
    [self.scrollview addSubview:self.createHeadView];
    [self.scrollview addSubview:self.createCommentAndDetailedView];
    [self.scrollview addSubview:self.createSpecificTableView];
    _roomDetailView = [[HotelRoomTypeDetailView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight)];
    _roomDetailView.hidden = YES;
    [KEYWINDOW addSubview:_roomDetailView];
    [self requestData];
   
 }

- (void)initUI{
    
}
- (HotelDateView*)createDateView{
    self.dateView = [[HotelDateView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 50)];
    self.dateView.userInteractionEnabled = YES;
    return self.dateView;

}
- (HotelHeadView*)createHeadView{
    self.headView = [[HotelHeadView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.dateView.frame) , APPScreenWidth, TABLEVIEWHEADHEIGHT)];
    self.headView.userInteractionEnabled = YES;
    self.headView.picsdelegate = self;
    
    return self.headView;
}
- (HotelCommentAndDetailedView*)createCommentAndDetailedView{
   
    self.commentAndDetailedView = [[HotelCommentAndDetailedView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.headView.frame) + 10.0f, APPScreenWidth, 120)];
    self.commentAndDetailedView.userInteractionEnabled = YES;
    self.commentAndDetailedView.hoteldetaildelegate = self;
   
    return self.commentAndDetailedView;
}

- (HotelChoiceTypeView*)createChoiceTypeView{
    self.choiceTypeView = [[HotelChoiceTypeView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.commentAndDetailedView.frame) + 10.0f, APPScreenWidth, 40)];
    self.choiceTypeView.userInteractionEnabled = YES;
    
    return self.choiceTypeView;
    
}

- (HotelSpecificTableView*)createSpecificTableView{
    self.tableview = [[HotelSpecificTableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.commentAndDetailedView.frame) + 10.0f, APPScreenWidth, 0)];
    self.tableview.userInteractionEnabled = YES;
    self.tableview.tabledelegate = self;
    CGRect frame1 = self.tableview.frame;
    frame1.origin.y = CGRectGetMaxY(self.commentAndDetailedView.frame) + 10.0f;
    self.tableview.frame = frame1;
    self.scrollview.contentSize = CGSizeMake(APPScreenWidth,CGRectGetMaxY(self.tableview.frame));
    return self.tableview;
}

- (UIScrollView*)createScrollview{
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight)];
    self.scrollview.contentSize = CGSizeMake(APPScreenWidth, APPScreenHeight);
    self.scrollview.userInteractionEnabled = YES;
    self.scrollview.scrollEnabled = YES;
    self.scrollview.showsVerticalScrollIndicator = NO;
    [self.scrollview setBackgroundColor:BGColor];
    return self.scrollview;
}

- (void)setNaviItems{
    //分享
    UIButton* shareBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"icon_sharehotel"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(0, 0, 30, 30);
    [shareBtn addTarget:self action:@selector(shareHotel) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:shareBtn]];
    
    
}

#pragma mark -- 数据
- (void)requestData {
    [YCHotelHttpTool hotelGetDetailWithHotelID:self.homelistmodel.hotelInfoID success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
             _detailmodel = [NSDictionary getHotelDetaiModelWithDic:data];
            NSLog(@"%@",_detailmodel);
           
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self refreshInterface];

            });
        }
    } failure:^(NSError *err) {
        
    }];
}
#pragma mark -- 刷新界面
- (void)refreshInterface{
    
    self.navigationItem.title = _detailmodel.hotelName;
    self.headView.detailmodel = _detailmodel;
    self.commentAndDetailedView.detailmodel = _detailmodel;
    self.tableview.hotelroomData = _detailmodel.hotelRoomTypes;
    self.tableview.hotelID = _detailmodel.hotelID;
    self.tableview.hotelName = _detailmodel.hotelName;
    self.scrollview.contentSize = CGSizeMake(APPScreenWidth,CGRectGetMaxY(self.tableview.frame));
}
#pragma mark -- 分享酒店
- (void)shareHotel{
    
    NSLog(@"分享酒店。。。。");
}

#pragma mark-- HotelHeadDelegaete
- (void)clickHotelHeadPics{

        HotelPicsController *hotelPics = [[HotelPicsController alloc] init];
        hotelPics.hidesBottomBarWhenPushed = YES;
        hotelPics.hotelID = _homelistmodel.hotelInfoID;
        [self.navigationController pushViewController:hotelPics animated:YES];
}

- (void)clickHotelHeadLocation{
    NSLog(@"点击定位......");
    self.coordinate = CLLocationCoordinate2DMake([_detailmodel.latitude floatValue],[ _detailmodel.longtitude floatValue]);
    [self startDaoHang];
}
#pragma mark -- hotelDetailDelegate
- (void)clickShowMoreHotelDetialed{
    HotelDetailIntroController *detailVC = [HotelDetailIntroController new];
    detailVC.hotelInfoID = _detailmodel.hotelID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark --HotelSpecificTableViewDelegate
- (void)talbeViewSumbitAction:(id)vc{
   
    HotelConfirmOrderViewController *orderVC = (HotelConfirmOrderViewController*)vc;
    orderVC.dateArray = @[self.dateView.startStr,self.dateView.endStr,self.dateView.totalStr];
     [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tableViewSelectCell:(HotelRoomTypeModel *)model{
    NSLog(@"model:%@",model);
    _roomDetailView.hidden = NO;
    
    [YCHotelHttpTool hotelGetRoomTypeDetailWithHotelID:self.homelistmodel.hotelInfoID roomTypeID:model.roomTypeID success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            HotelRoomInfoModel *roomInfo = [NSDictionary getHotelRoomTypeInfoModelWithDic:data];
            NSLog(@"%@",roomInfo);
            _roomDetailView.roomModel = roomInfo;
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)startDaoHang
{

    __block NSString *urlScheme = self.urlScheme;
    __block NSString *appName = self.appName;
    __block CLLocationCoordinate2D coordinate = self.coordinate;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"HotelMapChoose", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"HotelMapApple", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
            
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }];
        
        [alert addAction:action];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"HotelMapBaidu", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        
        [alert addAction:action];
    }
    
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"HotelMapGaode", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=3",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        
        [alert addAction:action];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"HotelMapGoogle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        
        [alert addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

@end
