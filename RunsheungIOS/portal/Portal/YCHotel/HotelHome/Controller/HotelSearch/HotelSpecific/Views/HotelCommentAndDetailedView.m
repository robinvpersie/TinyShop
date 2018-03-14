//
//  HotelCommentAndDetailedView.m
//  Portal
//
//  Created by 王五 on 2017/4/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelCommentAndDetailedView.h"
#import "UILabel+CreateLabel.h"
#import "HotelDetailModel.h"
#import "HotelSeviceInfoModel.h"
#import "HotelRatedModel.h"
#import "HotelSupportServiceView.h"
#import "HotelCommentViewController.h"
#import "UIView+ViewController.h"

@implementation HotelCommentAndDetailedView{
    UIView *DetailedbackView;
    UIView *CommentbackView;
    UILabel *scoreLab;
    UILabel *commentLab;
    UILabel *nameLab;
    UILabel* contentLab;
}

- (NSMutableArray *)buttonList
{
    if (!_buttonList)
    {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI:frame];
    }
    return self;
}

- (void)createUI:(CGRect)frame{
    [self setBackgroundColor:[UIColor whiteColor]];
    self.userInteractionEnabled = YES;
    [self buttonList];
    HotelSegmentView *segment = [[HotelSegmentView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 40)];
    segment.delegate = self;
    self.segment = segment;
    [self addSubview:segment];
    [self.buttonList addObject:segment.buttonList];
    self.LGLayer = segment.LGLayer;
    [self setContentScrollView];
 
}

#pragma mark - UIScrollViewDelegate
//实现HotelSegmentView代理方法
-(void)scrollToPage:(int)Page {
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = APPScreenWidth * Page;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentScrollView.contentOffset = offset;
    }];
}
// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    [self.segment moveToOffsetX:offsetX];
}

//加载ScrollView
-(void)setContentScrollView {
    
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40.0f, APPScreenWidth, 80.0f)];
    [self addSubview:scrollview];
    
    scrollview.bounces = NO;
    scrollview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    scrollview.contentOffset = CGPointMake(0, 0);
    scrollview.pagingEnabled = YES;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.scrollEnabled = YES;
    scrollview.userInteractionEnabled = YES;
    scrollview.delegate = self;
    scrollview.contentSize = CGSizeMake(2 * APPScreenWidth, 0);
    scrollview.delaysContentTouches = false;
    self.contentScrollView = scrollview;

    [self createCommentView];
    [self createDetailedView];
  
}

#pragma mark -- 分页视图
- (void)createCommentView{
    if (CommentbackView == nil) {
       
        CommentbackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, CGRectGetHeight(self.contentScrollView.frame))];
        CommentbackView.userInteractionEnabled = YES;
    }
   
    [self.contentScrollView addSubview:CommentbackView];
    
    [self createHotelComment:CommentbackView];
  
}
- (void)setDetailmodel:(HotelDetailModel *)detailmodel{
    _detailmodel = detailmodel;
    HotelRatedModel *ratemodel = detailmodel.rated;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f分",[ratemodel.totalScore floatValue]]];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:10.0] range:NSMakeRange(str.length - 1, 1)];
    scoreLab.attributedText = str;
    [commentLab setText:ratemodel.ratedName];
    [nameLab setText:ratemodel.userName];
    [contentLab setText:ratemodel.ratedContext];
    
    NSArray *severtitle = _detailmodel.hotelServices;
    NSMutableArray *serviceData = @[].mutableCopy;
    for (int i = 0; i<4; i++) {
        HotelSeviceInfoModel *sevicemodel = severtitle[i];
        
        NSDictionary *dic = @{sevicemodel.imageUrl:sevicemodel.ServiceDetailName};
        [serviceData addObject:dic];
    }
    
    HotelSupportServiceView *supportView = [[HotelSupportServiceView alloc]initWithFrame:CGRectMake(0, 5, APPScreenWidth,((serviceData.count/4.0f)>(int)(serviceData.count/4)?((int)(serviceData.count/4)+1):(serviceData.count/4))*50 )];
    supportView.serviceArr = serviceData;
    [DetailedbackView addSubview:supportView];

}
//创建酒店点评界面
- (void)createHotelComment:(UIView*)view{
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, APPScreenWidth - 20, 1)];
    [line setBackgroundColor:BGColor];
    [view addSubview:line];

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"0.0分"];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:10.0] range:NSMakeRange(str.length - 1, 1)];
    scoreLab = [UILabel createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(line.frame)+10, 60, 20) textColor:HotelYellowColor font:[UIFont systemFontOfSize:18] textAlignment:NSTextAlignmentCenter text:nil];
    scoreLab.attributedText = str;
    [view addSubview:scoreLab];
    
    commentLab = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMinX(scoreLab.frame), CGRectGetMaxY(scoreLab.frame), CGRectGetWidth(scoreLab.frame), 17) textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter text:nil];
    [commentLab.layer setCornerRadius:3];
    [commentLab.layer setMasksToBounds:YES];
    [commentLab setBackgroundColor:HotelYellowColor];
    [view addSubview:commentLab];
    
    nameLab = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(scoreLab.frame)+ 15.0f, CGRectGetMinY(scoreLab.frame), 200, 20) textColor:HotelBlackColor font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:nil];
    [view addSubview:nameLab];
   
    contentLab = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(commentLab.frame)+ 15.0f, CGRectGetMaxY(nameLab.frame), APPScreenWidth- CGRectGetMaxX(commentLab.frame) - 25, 30) textColor:HotelGrayColor font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentLeft text:nil];
    contentLab.numberOfLines = 2;
    [view addSubview:contentLab];


    //查看更多点评
    UIButton *checkCommentbtn = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth - 115,  60, 100, 20)];
    [checkCommentbtn addTarget:self action:@selector(checkActin:) forControlEvents:UIControlEventTouchUpInside];
    [checkCommentbtn setTitle:NSLocalizedString(@"HotelCheckComment", nil) forState:UIControlStateNormal];
    [checkCommentbtn setFont: [UIFont systemFontOfSize:10]];
    [checkCommentbtn setTitleColor:PurpleColor forState:UIControlStateNormal];
    [view addSubview:checkCommentbtn];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(checkCommentbtn.frame), CGRectGetMinY(checkCommentbtn.frame)+6, 4, 8)];
    imageview.userInteractionEnabled = YES;
    [imageview setImage:[UIImage imageNamed:@"icon_viewcomments"]];
    [view addSubview:imageview];

}

- (void)createDetailedView{
    if (DetailedbackView == nil) {
        DetailedbackView = [[UIImageView alloc]initWithFrame:CGRectMake(APPScreenWidth, 0, APPScreenWidth, CGRectGetHeight(self.contentScrollView.frame))];
        DetailedbackView.userInteractionEnabled = YES;
    }
    [self.contentScrollView addSubview:DetailedbackView];
    
    [self showInfoList:DetailedbackView];
}

//创建酒店详情的界面
- (void)showInfoList:(UIView*)view{
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, APPScreenWidth - 20, 1)];
    [line setBackgroundColor:BGColor];
    [view addSubview:line];
    
    
    UIButton *morebtn = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth - 85,  60, 70, 20)];
    [morebtn addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
    [morebtn setTitle:@"查看全部信息" forState:UIControlStateNormal];
    [morebtn setFont: [UIFont systemFontOfSize:10]];
    [morebtn setTitleColor:PurpleColor forState:UIControlStateNormal];
    [view addSubview:morebtn];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(morebtn.frame), CGRectGetMinY(morebtn.frame)+6, 4, 8)];
    imageview.userInteractionEnabled = YES;
    [imageview setImage:[UIImage imageNamed:@"icon_viewcomments"]];
    [view addSubview:imageview];

}

#pragma mark - 显示更多
- (void)showMore:(UIButton*)sender{
    NSLog(@"显示更多。。。。");
    if ([self.hoteldetaildelegate respondsToSelector:@selector(clickShowMoreHotelDetialed)]) {
        [self.hoteldetaildelegate clickShowMoreHotelDetialed];
    }
}

- (void)checkActin:(UIButton*)sender{
    NSLog(@"查看更多的酒店住房点评...");
    
    HotelCommentViewController *comment = [[HotelCommentViewController alloc] init];
    comment.hotelID = _detailmodel.hotelID;
    [self.viewController.navigationController pushViewController:comment animated:YES];
}
@end
