//
//  HotelPicsController.m
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelPicsController.h"
#import "NinaPagerView.h"
#import "HotelAllPicsController.h"
#import "HotelOutLookController.h"
#import "HotelHallPicsController.h"
#import "HotelRoomPicsController.h"
#import "HotelFacilityPicsController.h"

@interface HotelPicsController ()

@end

@implementation HotelPicsController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.automaticallyAdjustsScrollViewInsets == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (self.navigationController.navigationBar.translucent == NO) {
        self.navigationController.navigationBar.translucent = YES;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"HotelAlbumTitle", nil);
    
    HotelAllPicsController *allPics = [[HotelAllPicsController alloc] init];
    allPics.hotelID = self.hotelID;
    
    HotelOutLookController *outLook = [[HotelOutLookController alloc] init];
    outLook.hotelID = self.hotelID;
    
    HotelHallPicsController *hall = [[HotelHallPicsController alloc] init];
    hall.hotelID = self.hotelID;
    
    HotelRoomPicsController *room = [[HotelRoomPicsController alloc] init];
    room.hotelID = self.hotelID;
    
    HotelFacilityPicsController *facility = [[HotelFacilityPicsController alloc] init];
    facility.hotelID = self.hotelID;
    
    NSArray *colorArray = @[
                            PurpleColor, /**< 选中的标题颜色 Title SelectColor  **/
                            [UIColor darkGrayColor], /**< 未选中的标题颜色  Title UnselectColor **/
                            PurpleColor, /**< 下划线颜色或滑块颜色 Underline or SlideBlock Color   **/
                            [UIColor whiteColor], /**<  上方菜单栏的背景颜色 TopTab Background Color   **/
                            ];
    NinaPagerView *pageView = [[NinaPagerView alloc] initWithTitles:@[NSLocalizedString(@"SupermarketMyOrderAll", nil),NSLocalizedString(@"HotelPicOut", nil),NSLocalizedString(@"HotelPicHall", nil),NSLocalizedString(@"HotelPicRoom", nil),NSLocalizedString(@"HotelPicFacility", nil)] WithVCs:@[allPics,outLook,hall,room,facility] WithColorArrays:colorArray];
    pageView.pushEnabled = YES;
    [self.view addSubview:pageView];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
