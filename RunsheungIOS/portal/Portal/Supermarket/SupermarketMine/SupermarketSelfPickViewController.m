//
//  SupermarketSelfPickViewController.m
//  Portal
//
//  Created by ifox on 2016/12/16.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketSelfPickViewController.h"
#import "UILabel+WidthAndHeight.h"
#import "SupermarketSelfPickCollectionView.h"
#import "SupermarketSelfPickRightTableView.h"

@interface SupermarketSelfPickViewController ()

@property(nonatomic, strong) UIScrollView *mainScrollView;
@property(nonatomic, strong) UIImageView *trangleView;

@end

@implementation SupermarketSelfPickViewController {
    UIButton *_selectedButton;
    UIView *cityBg;
    SupermarketSelfPickRightTableView *tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    self.view.backgroundColor = BGColor;
    
    [self createView];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)createView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height)];
    _mainScrollView.contentSize = CGSizeMake(APPScreenWidth, APPScreenHeight);
    [self.view addSubview:_mainScrollView];
    
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 35)];
    msg.textColor = [UIColor lightGrayColor];
    msg.font = [UIFont systemFontOfSize:12];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.text = @"自提站点: 配送到宇成站点, 生鲜商品放于保险柜";
    [_mainScrollView addSubview:msg];
    
    cityBg = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(msg.frame), APPScreenHeight, 40)];
    cityBg.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:cityBg];
    
    UILabel *nowCity = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, cityBg.frame.size.height)];
    nowCity.font = [UIFont systemFontOfSize:15];
    nowCity.textColor = [UIColor grayColor];
    nowCity.text = @"当前城市:";
    CGFloat width = [UILabel getWidthWithTitle:nowCity.text font:nowCity.font];
    nowCity.frame = CGRectMake(15, 0, width, cityBg.frame.size.height);
    [cityBg addSubview:nowCity];
    
    UILabel *cityName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nowCity.frame)+10, 0, 100, cityBg.frame.size.height)];
    cityName.textColor = GreenColor;
    cityName.text = @"长沙";
    cityName.font = [UIFont systemFontOfSize:16];
    [cityBg addSubview:cityName];
    
    UIButton *changeCity = [UIButton buttonWithType:UIButtonTypeCustom];
    changeCity.frame = CGRectMake(APPScreenWidth - 15 - 80, 0, 80, cityBg.frame.size.height);
    [changeCity setTitle:@"切换城市" forState:UIControlStateNormal];
    [changeCity setTitleColor:GreenColor forState:UIControlStateNormal];
    changeCity.titleLabel.font = [UIFont systemFontOfSize:16];
    [cityBg addSubview:changeCity];
    
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.minimumInteritemSpacing = 0;
    layOut.minimumLineSpacing = 0;
    layOut.itemSize = CGSizeMake(APPScreenWidth/4, 40);
    layOut.sectionInset = UIEdgeInsetsMake(2, 0, 2, 0);
    layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    
//    SupermarketSelfPickCollectionView *collectionView = [[SupermarketSelfPickCollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cityBg.frame)-1, APPScreenWidth/4, APPScreenHeight) collectionViewLayout:layOut];
//    [_mainScrollView addSubview:collectionView];
    
    NSMutableArray *buttonArray = @[].mutableCopy;
    for (int i = 0; i < 8; i++) {
        UIButton *buuton = [UIButton buttonWithType:UIButtonTypeCustom];
        buuton.frame = CGRectMake(0, CGRectGetMaxY(cityBg.frame)-1 + (40+1)*i, APPScreenWidth/4, 40);
        if (i == 0) {
            buuton.selected = YES;
            _selectedButton = buuton;
        }
        [buuton setTitle:@"天心区" forState:UIControlStateNormal];
        [buuton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [buuton setTitleColor:GreenColor forState:UIControlStateSelected];
        buuton.titleLabel.font = [UIFont systemFontOfSize:15];
        buuton.tag = 100 + i;
        buuton.backgroundColor = [UIColor whiteColor];
        [buuton setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateSelected];
        [buuton addTarget:self action:@selector(selectArea:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:buuton];
        [buttonArray addObject:buuton];
    }
    
    tableView = [[SupermarketSelfPickRightTableView alloc] initWithFrame:CGRectMake(APPScreenWidth/4 + 1, CGRectGetMaxY(cityBg.frame)-1 + 2, APPScreenWidth - APPScreenWidth/4 - 1, buttonArray.count*41) style:UITableViewStylePlain];
    [_mainScrollView addSubview:tableView];
    
    tableView.layer.shadowColor = [UIColor blackColor].CGColor;
    tableView.layer.shadowOffset = CGSizeMake(-1, 1);
    tableView.layer.shadowOpacity = 0.4;
    
    tableView.layer.masksToBounds = NO;
    
    _trangleView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(tableView.frame)-15, CGRectGetMaxY(cityBg.frame)-1 + 20 - 7, 15, 15)];
    _trangleView.image = [UIImage imageNamed:@"t"];
    [_mainScrollView addSubview:_trangleView];
}

- (void)requestData {
    [KLHttpTool getSelfPickAddressListsuccess:^(id response) {
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSArray *dataArray = response[@"data"];
            tableView.dataArray = dataArray;
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)selectArea:(UIButton *)button {
    _selectedButton.selected = NO;
    if (button.selected == NO) {
        button.selected = YES;
        _selectedButton = button;
    }
    
    NSInteger tag = button.tag - 100;
    
    CGRect trangleFrame = _trangleView.frame;
    trangleFrame.origin.y = tag*41 + CGRectGetMaxY(cityBg.frame)-1 + 20 - 7;
    _trangleView.frame = trangleFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
