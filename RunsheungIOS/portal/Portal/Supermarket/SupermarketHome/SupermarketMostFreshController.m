//
//  SupermarketMostFreshController.m
//  Portal
//
//  Created by ifox on 2016/12/27.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketMostFreshController.h"
#import "ZHSCorllHeader.h"
#import "SupermarketMostFreshTableView.h"
#import "ImageData.h"

@interface SupermarketMostFreshController ()

@end

@implementation SupermarketMostFreshController {
    SupermarketMostFreshTableView *tableView;
    ZHSCorllHeader *banner;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SMMostFreshTitle", nil);
    
    [self createSubViews];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)createSubViews {
    banner = [[ZHSCorllHeader alloc] initWithFrame:CGRectMake(0, 64, APPScreenWidth, APPScreenWidth/2)];
//    banner.urlImagesArray = @[@"http://pic.58pic.com/58pic/13/20/56/56b58PIC3MY_1024.jpg",@"http://pic.58pic.com/58pic/17/71/65/557d55d0b3440_1024.jpg",@"http://pic2.ooopic.com/12/56/62/72b1OOOPICf3.jpg"];
    
    tableView = [[SupermarketMostFreshTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    
    tableView.tableHeaderView = banner;
}

- (void)requestData {
    [KLHttpTool getSupermarketMostFreshListWithActionID:self.actionID divCode:self.divCode success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSArray *list = data[@"list"];
            if (list.count > 0) {
                NSMutableArray *dataArr = @[].mutableCopy;
                for (NSDictionary *dic in list) {
                    SupermarketHomeMostFreshData *data = [NSDictionary getSupermarketHomeMostFreshDataWithDic:dic];
                    [dataArr addObject:data];
                }
                tableView.dataArray = dataArr;
                
                NSString *url = data[@"banner_url"];
                banner.urlImagesArray = @[url];
            }
        }
    } failure:^(NSError *err) {
        
    }];
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
