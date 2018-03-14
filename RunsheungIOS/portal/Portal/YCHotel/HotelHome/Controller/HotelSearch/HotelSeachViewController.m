//
//  HotelSeachViewController.m
//  Portal
//
//  Created by ifox on 2017/3/31.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelSeachViewController.h"
#import "HotelSearchTableView.h"
#import "HotelSearchResultController.h"

@interface HotelSeachViewController ()<UISearchBarDelegate>

@property(nonatomic, strong) HotelSearchTableView *searchTableView;
@property(nonatomic, strong) UISearchBar *searchBar;

@end

@implementation HotelSeachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGColor;
    
    [self createView];
}

- (void)createView {
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth - 60, 32.0)];
    _searchBar.delegate = self;
    UIImage* searchBarBg = [self GetImageWithColor:BGColor andHeight:32.0f];
    //设置背景图片
    [_searchBar setBackgroundImage:searchBarBg];
    //设置背景色
    [_searchBar setBackgroundColor:[UIColor clearColor]];
    //设置文本框背景
    [_searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
    _searchBar.placeholder = @"酒店/关键字/关键词";
    self.navigationItem.titleView = _searchBar;
    
    _searchTableView = [[HotelSearchTableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_searchTableView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
    HotelSearchResultController *searchResult = [[HotelSearchResultController alloc] init];
    [self.navigationController pushViewController:searchResult animated:YES];
}

/**
 *  生成图片
 *
 *  @param color  图片颜色
 *  @param height 图片高度
 *
 *  @return 生成的图片
 */
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
