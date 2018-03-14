//
//  SupermarketTasteNewController.m
//  Portal
//
//  Created by ifox on 2016/12/28.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketTasteNewController.h"
#import "SupermarketTasteNewTableView.h"
#import "ZHSCorllHeader.h"
#import "SupermarketHomeMostFreshData.h"

@interface SupermarketTasteNewController ()

@property(nonatomic, strong) SupermarketTasteNewTableView *tableView;

@end

@implementation SupermarketTasteNewController {
    ZHSCorllHeader *banner;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SupermarketTasteFresh",nil);
    
    [self createTableView];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)createTableView {
    
    _tableView = [[SupermarketTasteNewTableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    banner = [[ZHSCorllHeader alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenWidth/3*2)];
    banner.imageNameArray = @[@"1",@"2",@"3"];
    _tableView.tableHeaderView = banner;
    
//    _tableView.contentInset = UIEdgeInsetsMake(APPScreenWidth/5*4, 0, 0, 0);
}

- (void)requestData {
    [KLHttpTool getSupermarketTasteNewListWithActionID:self.actionID divCode:self.divCode success:^(id response) {
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSString *banner_url = data[@"banner_url"];
            
            banner.urlImagesArray = @[banner_url];
            NSArray *list = data[@"list"];
            if (list.count > 0) {
                NSMutableArray *dataArr = @[].mutableCopy;
                for (NSDictionary *dic in list) {
                    SupermarketHomeMostFreshData *data = [NSDictionary getSupermarketHomeMostFreshDataWithDic:dic];
                    [dataArr addObject:data];
                }
                _tableView.dataArray = dataArr;
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
