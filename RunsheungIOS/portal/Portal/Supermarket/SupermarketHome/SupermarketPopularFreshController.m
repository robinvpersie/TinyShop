//
//  SupermarketPopularFreshController.m
//  Portal
//
//  Created by ifox on 2016/12/27.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketPopularFreshController.h"
#import "ZHSCorllHeader.h"
#import "SupermarketHomeWantBuyCollectionView.h"
#import "SupermarketHomePeopleLikeData.h"

@interface SupermarketPopularFreshController ()

@property(nonatomic, strong) SupermarketHomeWantBuyCollectionView *wantBuyCollectionView;

@end

@implementation SupermarketPopularFreshController {
    ZHSCorllHeader *banner;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SMPopFreshTitle", nil);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.minimumInteritemSpacing = 0;
    layOut.minimumLineSpacing = 0;
    layOut.itemSize = CGSizeMake((APPScreenWidth - 4)/2, (APPScreenWidth - 4)/2+75);
    layOut.sectionInset = UIEdgeInsetsMake(15, 0, 2, 0);
    layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _wantBuyCollectionView = [[SupermarketHomeWantBuyCollectionView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height) collectionViewLayout:layOut];
    [self.view addSubview:_wantBuyCollectionView];
    
    banner = [[ZHSCorllHeader alloc] initWithFrame:CGRectMake(0, -APPScreenWidth/2, APPScreenWidth, APPScreenWidth/2)];
//    banner.urlImagesArray = @[@"http://pic.58pic.com/58pic/13/20/56/56b58PIC3MY_1024.jpg",@"http://pic.58pic.com/58pic/17/71/65/557d55d0b3440_1024.jpg",@"http://pic2.ooopic.com/12/56/62/72b1OOOPICf3.jpg"];
    [_wantBuyCollectionView addSubview:banner];
    
    _wantBuyCollectionView.contentInset = UIEdgeInsetsMake(APPScreenWidth/2, 0, 0, 0);
    
    [self requestData];
    
    // Do any additional setup after loading the view.
}

- (void)requestData {
    [KLHttpTool getSupermarketPopularFreshListWithActionID:self.actionID divCode:self.divCode success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSString *url = data[@"banner_url"];
            banner.urlImagesArray = @[url];
            NSArray *list = data[@"list"];
            if (list.count > 0) {
                NSMutableArray *dataArr = @[].mutableCopy;
                for (NSDictionary *dic in list) {
                    SupermarketHomePeopleLikeData *data = [NSDictionary getSupermarketHomePeopleLikeDataWithDic:dic];
                    [dataArr addObject:data];
                }
                _wantBuyCollectionView.dataArray = dataArr;
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
