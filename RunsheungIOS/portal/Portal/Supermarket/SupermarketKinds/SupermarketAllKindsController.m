//
//  SupermarketAllKindsController.m
//  Portal
//
//  Created by ifox on 2016/12/29.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketAllKindsController.h"
#import "SupermarketAllKindsCollectionView.h"
#import "SupermarketKindModel.h"

@interface SupermarketAllKindsController ()

@property(nonatomic, strong) SupermarketAllKindsCollectionView *collectionView;
@property(nonatomic, strong) UICollectionViewFlowLayout *layout;
@property(nonatomic, strong) NSArray *dataArray;

@end

@implementation SupermarketAllKindsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"分类列表";
    
    [self createView];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)createView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0.4f, 0);
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[SupermarketAllKindsCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.collectionView];
    NSLayoutConstraint *leadingConstraint = [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
    NSLayoutConstraint *trailingConstraint = [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    NSLayoutConstraint *topConstraint;
    NSLayoutConstraint *bottomConstraint;
    if (@available(iOS 11.0, *)) {
       topConstraint = [self.collectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor];
       bottomConstraint = [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor];
    } else {
       topConstraint = [self.collectionView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor];
       bottomConstraint = [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor];
    }
    NSArray *constraintsArray = [NSArray arrayWithObjects:leadingConstraint,trailingConstraint,topConstraint,bottomConstraint, nil];
    [NSLayoutConstraint activateConstraints:constraintsArray];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.layout.itemSize = CGSizeMake(self.view.frame.size.width / 3.0 - 1, self.view.frame.size.width / 3.0 - 1);
}

- (void)requestData {
    [KLHttpTool supermarketGetAllKindWithAppType:6 success:^(id response) {
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSArray *data = response[@"data"];
            NSMutableArray *dataArr = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                SupermarketKindModel *kindModel = [NSDictionary getKindsModelWithDic:dic];
                [dataArr addObject:kindModel];
            }
            self.collectionView.dataArray = dataArr;
         }
    } failure:^(NSError *err) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
