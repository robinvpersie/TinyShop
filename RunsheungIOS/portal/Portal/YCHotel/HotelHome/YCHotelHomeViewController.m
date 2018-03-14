//
//  YCHotelHomeViewController.m
//  Portal
//
//  Created by ifox on 2017/3/29.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCHotelHomeViewController.h"
#import "HotelChooseView.h"
#import "ZHSCorllHeader.h"
#import "UILabel+WidthAndHeight.h"
#import "UILabel+CreateLabel.h"

#define ItemWidth 45
#define ButtonWidth (APPScreenWidth - 40 - 20)/3.0

@interface YCHotelHomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableView *homeTableView;
@property(nonatomic, strong) ZHSCorllHeader *banner;
@property(nonatomic, strong) HotelChooseView *chooseView;
@property(nonatomic, strong) NSArray *titles;

@end

@implementation YCHotelHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titles = @[@"品质出游",@"情侣主题",@"客栈青旅",@"酒景优选",@"家庭出行",@"公寓民宿"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"宇成酒店";
    
    [self createView];
    // Do any additional setup after loading the view.
}

- (void)createView {
    _homeTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _homeTableView.dataSource = self;
    _homeTableView.delegate = self;
    _homeTableView.backgroundColor = BGColor;
    _homeTableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_homeTableView];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 0)];
    header.backgroundColor = BGColor;
    _homeTableView.tableHeaderView = header;
    
    _banner = [[ZHSCorllHeader alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 150)];
    _banner.urlImagesArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490788129528&di=7a7a1e73105cde3cdacabeeb0a8f0b16&imgtype=0&src=http%3A%2F%2Fpic.fxxz.com%2Fup%2F2017-3%2F201737142418320420.jpg",
                               @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490788129525&di=8665d6135728e7a49c72b5bad48a912f&imgtype=0&src=http%3A%2F%2F2t.5068.com%2Fuploads%2Fallimg%2F170309%2F1-1F309194924.jpg",
                               @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490788129522&di=64ac7765689be7a5ebfb57ad44cc5433&imgtype=0&src=http%3A%2F%2Fi1.hdslb.com%2Fbfs%2Farchive%2Fb63be78c01b44d4249e788001fbd99b3e7bc27c5.jpg"];
    CGRect pageControlFrame = _banner.pageControl.frame;
    pageControlFrame.origin.y = pageControlFrame.origin.y - 25;
    _banner.pageControl.frame = pageControlFrame;
    [header addSubview:_banner];
    
    _chooseView = [[HotelChooseView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_banner.frame)-25, APPScreenWidth - 20, 260)];
    [header addSubview:_chooseView];
    header.frame = CGRectMake(0, 0, APPScreenWidth, CGRectGetMaxY(_chooseView.frame) + 15);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        
    }
    if (indexPath.row == 1) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 10, APPScreenWidth - 40, 0.7f)];
        line.backgroundColor = BorderColor;
        [cell.contentView addSubview:line];
        
        CGFloat width = [UILabel getWidthWithTitle:@"为你精选" font:[UIFont systemFontOfSize:14]];
        UILabel *title = [UILabel createLabelWithFrame:CGRectMake(0, 0, width, 20) textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter text:@"为你精选"];
        title.center = CGPointMake(APPScreenWidth/2, 10);
        title.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:title];
        
        for (int i = 0; i < _titles.count ; i++) {
            NSInteger line = i/3;
            NSInteger column = i%3;
            UIButton *button = [self createButtonWithOriginX:20+column*(10+ButtonWidth) OriginY:CGRectGetMaxY(title.frame)+10 + (25+10)*line title:_titles[i]];
            [cell.contentView addSubview:button];
        }
    }
    return cell;
}

- (UIButton *)createButtonWithOriginX:(CGFloat)x
                              OriginY:(CGFloat)y
                                title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, ButtonWidth, 25);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:HotelGrayColor forState:UIControlStateNormal];
    [button setBackgroundColor:BGColor];
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 0.5f;
    button.layer.borderColor = BorderColor.CGColor;
    return button;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
