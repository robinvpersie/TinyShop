//
//  SupermarketOnSaleController.m
//  Portal
//
//  Created by ifox on 2016/12/28.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketOnSaleController.h"
#import "SupermarketOnSaleCollectionView.h"
#import "ZHSCorllHeader.h"
#import "SupermarketOnSaleModel.h"

@interface SupermarketOnSaleController ()

@property(nonatomic, strong) SupermarketOnSaleCollectionView *onSaleCollectionView;

@end

@implementation SupermarketOnSaleController {
    ZHSCorllHeader *banner;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BGColor;
    
    [self createView];
    
    self.title = self.actionTitle;
    
    [self requestData];
    
    // Do any additional setup after loading the view.
}

- (void)createView {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.minimumInteritemSpacing = 0;
    layOut.minimumLineSpacing = 0;
    layOut.itemSize = CGSizeMake((APPScreenWidth - 30 - 10)/3, (APPScreenWidth - 30 - 10)/3 + 120);
    layOut.sectionInset = UIEdgeInsetsMake(15, 15, 2, 15);
    layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _onSaleCollectionView = [[SupermarketOnSaleCollectionView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height) collectionViewLayout:layOut];
    _onSaleCollectionView.backgroundColor = BGColor;
    [self.view addSubview:_onSaleCollectionView];
    
    banner = [[ZHSCorllHeader alloc] initWithFrame:CGRectMake(0, -APPScreenWidth/2, APPScreenWidth, APPScreenWidth/2)];
//    banner.urlImagesArray = @[@"http://pic.58pic.com/58pic/13/20/56/56b58PIC3MY_1024.jpg",@"http://pic.58pic.com/58pic/17/71/65/557d55d0b3440_1024.jpg",@"http://pic2.ooopic.com/12/56/62/72b1OOOPICf3.jpg"];
    [_onSaleCollectionView addSubview:banner];
    
    _onSaleCollectionView.contentInset = UIEdgeInsetsMake(APPScreenWidth/2, 0, 0, 0);
    
}

- (void)requestData {
    [KLHttpTool getTodayFreshOfListWithActionID:self.actionID divCode:self.divCode success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSArray *list = data[@"list"];
            if (list.count > 0) {
                NSMutableArray *dataArr = @[].mutableCopy;
                for (NSDictionary *dic in list) {
                    SupermarketOnSaleModel *model = [NSDictionary getOnsaleModelWithDic:dic];
                    [dataArr addObject:model];
                }
                _onSaleCollectionView.dataArray = dataArr;
            }
            NSString *banner_url = data[@"banner_url"];
            banner.urlImagesArray = @[banner_url];
            
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
