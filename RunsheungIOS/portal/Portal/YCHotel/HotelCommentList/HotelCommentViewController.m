//
//  HotelCommentViewController.m
//  Portal
//
//  Created by ifox on 2017/5/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelCommentViewController.h"
#import "NinaPagerView.h"
#import "HotelAllCommentViewController.h"
#import "HotelImageCommentViewController.h"
#import "HotelLowCommentViewController.h"
#import "HotelHighCommentViewController.h"
#import "HotelMidCommentViewController.h"

@interface HotelCommentViewController ()

@end

@implementation HotelCommentViewController {
    NinaPagerView *pageView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCommentCout:) name:HotelCommentListCountNotification object:nil];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HotelCommentListCountNotification object:nil];
    if (self.automaticallyAdjustsScrollViewInsets == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (self.navigationController.navigationBar.translucent == NO) {
        self.navigationController.navigationBar.translucent = YES;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"HotelCommentTitle", nil);
    
    HotelAllCommentViewController *allComment = [[HotelAllCommentViewController alloc] init];
    allComment.hotelID = self.hotelID;
    HotelImageCommentViewController *imageComment = [[HotelImageCommentViewController alloc] init];
    imageComment.hotelID = self.hotelID;
    HotelLowCommentViewController *lowComment = [[HotelLowCommentViewController alloc] init];
    lowComment.hotelID = self.hotelID;
//    HotelLastCommentViewController *lastComment = [[HotelLastCommentViewController alloc] init];
    
    HotelHighCommentViewController *highComment = [[HotelHighCommentViewController alloc] init];
    highComment.hotelID = self.hotelID;
    
    HotelMidCommentViewController *midComment = [[HotelMidCommentViewController alloc] init];
    midComment.hotelID = self.hotelID;
    
    NSArray *colorArray = @[
                            PurpleColor, /**< 选中的标题颜色 Title SelectColor  **/
                            [UIColor darkGrayColor], /**< 未选中的标题颜色  Title UnselectColor **/
                            PurpleColor, /**< 下划线颜色或滑块颜色 Underline or SlideBlock Color   **/
                            [UIColor whiteColor], /**<  上方菜单栏的背景颜色 TopTab Background Color   **/
                            ];
    pageView = [[NinaPagerView alloc] initWithTitles:@[@"全    部",@"好   评",@"中   评",@"差    评",@"晒    图"] WithVCs:@[allComment,highComment,midComment,lowComment,imageComment] WithColorArrays:colorArray];
    pageView.pushEnabled = YES;
    [self.view addSubview:pageView];
    
    
}

- (void)reloadCommentCout:(NSNotification *)notification {
    NSArray *obj = notification.object;
    NSString *totalCount = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"HotalCommentAll", nil),obj.firstObject];
    NSString *highCount = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"SMCommentGood", nil),obj[1]];
    NSString *midCount = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"SMCommentMid", nil),obj[2]];
    NSString *lowCount = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"SMCommentBad", nil),obj[3]];
    NSString *imageCount = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"SMCommentPic", nil),obj[4]];
    pageView.titleArray = @[totalCount,highCount,midCount,lowCount,imageCount];
    NSLog(@"---");
}

@end
