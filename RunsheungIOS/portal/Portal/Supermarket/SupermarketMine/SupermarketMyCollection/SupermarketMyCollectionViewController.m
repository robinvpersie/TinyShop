//
//  SupermarketMyCollectionViewController.m
//  Portal
//
//  Created by ifox on 2017/5/24.
//  Copyright © 2017年 linpeng. All rights reserved.
//

//#import "SupermarketMyCollectionViewController.h"
//#import "LZCartModel.h"
//#import "LZConfigFile.h"
//#import "LZCartTableViewCell.h"
//#import <MJRefresh/MJRefresh.h>
//#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
//#import "Masonry.h"
//#import "CollectionItemModel.h"
//
//typedef NS_ENUM(NSInteger, FetchType) {
//    TopRefresh,
//    Normal,
//    LoadMore
//};
//
//@interface SupermarketMyCollectionViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource>
//
//@property (strong,nonatomic)NSMutableArray<NewCartModel *> *dataArray;
//@property (strong,nonatomic)NSMutableArray *selectedArray;
//@property (strong,nonatomic)UITableView *myTableView;
//@property (strong,nonatomic)UIButton *allSellectedButton;
//@property (assign, nonatomic) NSInteger offset;
//@property (assign, nonatomic) BOOL isLoading;
//@property (assign, nonatomic) BOOL isFetch;
//@property (assign, nonatomic) BOOL canLoadMore;
//
//@end
//
//@implementation SupermarketMyCollectionViewController {
////    UIButton *collectionDelete;//收藏夹删除
////    UIButton *collectionDeleteTile;//收藏夹删除
////    UIButton *collectionMoveShoppingCart;//收藏夹移入购物车
////    UIButton *collectionMoveShoppingCartTitle;//收藏夹移入购物车
//}
//
//
//- (void)popController {
//    if (self.refresh != nil){
//    self.refresh();
//    }
//    [super popController];
//
//}
//
//- (void)popToRootController {
//    self.refresh();
//    [super popToRootController];
//
//}
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.title = NSLocalizedString(@"SMMyCollectionTitle", nil);
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self commonInit];
//    [self setupCartView];
//    [self.myTableView.mj_header beginRefreshing];
//
//}
//
//-(void)commonInit {
//    self.selectedArray = [NSMutableArray array] ;
//    self.dataArray = [NSMutableArray array];
//    self.offset = 1;
//    self.isLoading = YES;
//    self.isFetch = NO;
//    self.canLoadMore = YES;
//}
//
//- (void)loadDataWithFetchType:(FetchType)type finishBlock:(void(^)(void)) finish {
//    if (self.isFetch) {
//        return;
//    }
//    self.isFetch = YES;
//    if (type == Normal || type == TopRefresh) {
//        self.offset = 1;
//    }else {
//        self.offset = self.offset + 1;
//    }
//    __weak typeof(self) weakself = self;
//    [KLHttpTool getMyCollectionListWithOffSet:self.offset success:^(id response) {
//        weakself.isFetch = NO;
//        weakself.isLoading = NO;
//        NSNumber *status = response[@"status"];
//        if (status.integerValue == 1) {
//            NSArray *favoriteslist = response[@"Favoriteslist"];
//            NSMutableArray<NewCartModel *> *modelArray = [NSMutableArray array];
//            for (NSDictionary *dic in favoriteslist) {
//               // LZCartModel *model = [NSDictionary getLzCartModelWithDic:dic];
//                NewCartModel *model = [NSDictionary getCartModelWithDic:dic];
//                [modelArray addObject:model];
//            }
//            if (type == Normal || type == TopRefresh) {
//                weakself.dataArray = modelArray;
//                [weakself.myTableView reloadData];
//            } else {
//                if (modelArray.count < 20) {
//                    weakself.canLoadMore = NO;
//                }
//                NSInteger originalCount = weakself.dataArray.count;
//                [weakself.dataArray addObjectsFromArray:modelArray];
//                NSInteger newCount = weakself.dataArray.count;
//                NSMutableArray<NSIndexPath *> *indexPathArray = [NSMutableArray array];
//                for (NSInteger x = originalCount; x < newCount; x++) {
//                    NSIndexPath *index = [NSIndexPath indexPathForItem:x inSection:0];
//                    [indexPathArray addObject:index];
//                }
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    [weakself.myTableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
//                }];
//            }
//            finish();
//        }
//    } failure:^(NSError *err) {
//
//    }];
//}
//
//
//
//- (void)setupCartView {
//    self.myTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
//    self.myTableView.rowHeight = lz_CartRowHeight;
//    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.myTableView.backgroundColor = LZColorFromRGB(245, 246, 248);
//    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(topRefresh)];
//    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
//    self.myTableView.tableFooterView = [[UIView alloc] init];
//    [self.myTableView registerClass:[LZCartTableViewCell class] forCellReuseIdentifier:@"LZCart"];
//    [self.view addSubview:self.myTableView];
//    self.myTableView.delegate = self;
//    self.myTableView.dataSource = self;
//    self.myTableView.emptyDataSetSource = self;
//    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//}
//
//
//-(void)topRefresh {
//    __weak typeof(self) weakself = self;
//    [self loadDataWithFetchType:TopRefresh finishBlock:^{
//        weakself.canLoadMore = YES;
//        [weakself.myTableView.mj_header endRefreshing];
//        [weakself.myTableView.mj_footer resetNoMoreData];
//    }];
//}
//
//-(void)loadMore {
//    __weak typeof(self) weakself = self;
//    [self loadDataWithFetchType:LoadMore finishBlock:^{
//        if (weakself.canLoadMore) {
//            [weakself.myTableView.mj_footer endRefreshing];
//        }else {
//            [weakself.myTableView.mj_footer endRefreshingWithNoMoreData];
//        }
//    }];
//}
//
////- (void)setupCustomBottomView {
////    UIView *backgroundView = [[UIView alloc]init];
////    backgroundView.backgroundColor = [UIColor whiteColor];
////    backgroundView.tag = TAG_CartEmptyView + 1;
////    backgroundView.frame = CGRectMake(0, LZSCREEN_HEIGHT -  LZTabBarHeight, LZSCREEN_WIDTH, LZTabBarHeight);
////    [self.view addSubview:backgroundView];
////
////    //全选按钮
////    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
////    selectAll.titleLabel.font = [UIFont systemFontOfSize:16];
////    selectAll.frame = CGRectMake(10, 5, 80, LZTabBarHeight - 10);
////    [selectAll setTitle:NSLocalizedString(@"SMMyCollectionChooseAll", nil) forState:UIControlStateNormal];
////    [selectAll setImage:[UIImage imageNamed:lz_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
////    [selectAll setImage:[UIImage imageNamed:lz_Bottom_SelectButtonString] forState:UIControlStateSelected];
////    [selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
////    [backgroundView addSubview:selectAll];
////    self.allSellectedButton = selectAll;
////
////    collectionMoveShoppingCart = [UIButton buttonWithType:UIButtonTypeCustom];
////    collectionMoveShoppingCart.frame = CGRectMake(backgroundView.frame.size.width - 15 - 30, 4, 30, 30);
////    [collectionMoveShoppingCart setImage:[UIImage imageNamed:@"shopping_cart"] forState:UIControlStateNormal];
////    collectionMoveShoppingCart.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
////    [collectionMoveShoppingCart addTarget:self action:@selector(movetoCart) forControlEvents:UIControlEventTouchUpInside];
////    [backgroundView addSubview:collectionMoveShoppingCart];
////
////    collectionMoveShoppingCartTitle = [UIButton buttonWithType:UIButtonTypeCustom];
////    collectionMoveShoppingCartTitle.frame = CGRectMake(collectionMoveShoppingCart.frame.origin.x - 3, CGRectGetMaxY(collectionMoveShoppingCart.frame)-5, collectionMoveShoppingCart.frame.size.width+8, 20);
////    [collectionMoveShoppingCartTitle setTitle:NSLocalizedString(@"SupermarketTabShoppingCart", nil) forState:UIControlStateNormal];
////    [collectionMoveShoppingCartTitle setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
////    collectionMoveShoppingCartTitle.titleLabel.font = [UIFont systemFontOfSize:10];
////    [backgroundView addSubview:collectionMoveShoppingCartTitle];
////
////    collectionDelete = [UIButton buttonWithType:UIButtonTypeCustom];
////    collectionDelete.frame = CGRectMake(CGRectGetMinX(collectionMoveShoppingCart.frame) - 10 - 30, collectionMoveShoppingCart.frame.origin.y, 22, 30);
////    collectionDelete.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
////    [collectionDelete addTarget:self action:@selector(deleteCollection) forControlEvents:UIControlEventTouchUpInside];
////    [collectionDelete setImage:[UIImage imageNamed:@"collection_delete"] forState:UIControlStateNormal];
////    [backgroundView addSubview:collectionDelete];
////
////    collectionDeleteTile = [UIButton buttonWithType:UIButtonTypeCustom];
////    collectionDeleteTile.frame = CGRectMake(collectionDelete.frame.origin.x - 2, CGRectGetMaxY(collectionDelete.frame)-5, CGRectGetWidth(collectionDelete.frame) + 5, 20);
////    [collectionDeleteTile addTarget:self action:@selector(deleteCollection) forControlEvents:UIControlEventTouchUpInside];
////    [collectionDeleteTile setTitle:NSLocalizedString(@"SMDeleteTitle", nil) forState:UIControlStateNormal];
////    [collectionDeleteTile setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
////    collectionDeleteTile.titleLabel.font = [UIFont systemFontOfSize:10];
////    [backgroundView addSubview:collectionDeleteTile];
////}
////
////-(void)setDivCode:(NSString *)divCode{
////    _divCode = [divCode copy];
////}
//
////-(void)movetoCart{
////    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SMAlertMoveToCartMsg", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
////    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertSureTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////        NSString *div;
////        if (_divCode != nil){
////            div = _divCode;
////        }else {
////           div = [[NSUserDefaults standardUserDefaults] objectForKey:DivCodeDefault];
////        }
////        for (int i = 0; i < self.selectedArray.count; i++) {
////            LZCartModel *model = _selectedArray[i];
////            [KLHttpTool addGoodsToShoppingCartWithGoodsID:model.item_code shopID:div applyID:@"YC01" numbers:1 success:^(id response) {
////                NSNumber *status = response[@"status"];
////                if (status.integerValue == 1) {
////                    [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
////                }
////            } failure:^(NSError *err) { }];
////        }
////    }];
////    UIAlertAction *cancle = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIAlertActionStyleCancel handler:nil];
////    [alertController addAction:confirm];
////    [alertController addAction:cancle];
////    [self presentViewController:alertController animated:true completion:nil];
////
////}
//
//#pragma mark --- UITableViewDataSource & UITableViewDelegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    [tableView.mj_footer setHidden:self.dataArray.count > 0 ? NO:YES ];
//    return self.dataArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    LZCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZCart" forIndexPath:indexPath];
//    cell.isCollection = YES;
//   // LZCartModel *model = self.dataArray[indexPath.row];
//    NewCartModel *model = self.dataArray[indexPath.row];
//    [cell configureWithModel:model];
//   // [cell reloadDataWithModel:model];
////    [cell cellSelectedWithBlock:^(BOOL select) {
////        model.select = select;
////        if (select) {
////            [self.selectedArray addObject:model];
////        }else {
////            [self.selectedArray removeObject:model];
////        }
////        if (self.selectedArray.count == self.dataArray.count) {
////            _allSellectedButton.selected = YES;
////        }else {
////            _allSellectedButton.selected = NO;
////        }
////
////
////    }];
//    return cell;
////    LZCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZCartReusableCell"];
////    if (cell == nil) {
////        cell = [[LZCartTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LZCartReusableCell"];
////    }
////
////    cell.isCollection = YES;
////
////    LZCartModel *model = self.dataArray[indexPath.row];
////
////    [cell cellSelectedWithBlock:^(BOOL select) {
////
////        model.select = select;
////        if (select) {
////            [self.selectedArray addObject:model];
////        } else {
////            [self.selectedArray removeObject:model];
////        }
////
////        if (self.selectedArray.count == self.dataArray.count) {
////            _allSellectedButton.selected = YES;
////        } else {
////            _allSellectedButton.selected = NO;
////        }
////    }];
////
////    [cell reloadDataWithModel:model];
//
//}
//
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}
//
//
////#pragma mark --- 全选按钮点击事件
////- (void)selectAllBtnClick:(UIButton*)button {
////    button.selected = !button.selected;
////
////    //点击全选时,把之前已选择的全部删除
////    for (LZCartModel *model in self.selectedArray) {
////        model.select = NO;
////    }
////
////    [self.selectedArray removeAllObjects];
////
////    if (button.selected) {
////
////        for (LZCartModel *model in self.dataArray) {
////            model.select = YES;
////            [self.selectedArray addObject:model];
////        }
////    }
////
////    [self.myTableView reloadData];
////}
////
////#pragma mark - 收藏夹删除商品
////- (void)deleteCollection {
////    if (self.selectedArray.count > 0) {
////        UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SMAlertTitle", nil) message:NSLocalizedString(@"SMAlertDeleteCollectionMsg", nil) preferredStyle:UIAlertControllerStyleAlert];
////        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMDeleteTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////            NSMutableArray *goodsIDs = @[].mutableCopy;
////            for (LZCartModel *model in self.selectedArray) {
////                NSMutableDictionary *dic = @{}.mutableCopy;
////                [dic setObject:model.item_code forKey:@"item_code"];
////                [dic setObject:model.divCode forKey:@"div_code"];
////                [goodsIDs addObject:dic];
////            }
////            [KLHttpTool deleteCollectionGoods:goodsIDs success:^(id response) {
////                NSNumber *status = response[@"status"];
////                if (status.integerValue == 1) {
////                    [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
////
////                    for (LZCartModel *model in self.selectedArray) {
////                        if ([self.dataArray containsObject:model]) {
////                            [self.dataArray removeObject:model];
////                        }
////                    }
////                    [self.selectedArray removeAllObjects];
////                    [_myTableView reloadData];
////                }
////            } failure:^(NSError *err) {
////
////            }];
////        }];
////
////        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIAlertActionStyleDefault handler:nil];
////        [deleteAlert addAction:ok];
////        [deleteAlert addAction:cancel];
////        [self presentViewController:deleteAlert animated:YES completion:nil];
////    } else {
////        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:NSLocalizedString(@"SMNoChooseGoodsMsg", nil)];
////    }
////}
//
//-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    if (self.isLoading) {
//        return nil;
//    } else {
//        return [[NSAttributedString alloc] initWithString:@"您还没有收藏"];
//    }
//}
//
//@end

#import "SupermarketMyCollectionViewController.h"
#import "LZCartModel.h"
#import "LZConfigFile.h"
#import "LZCartTableViewCell.h"
#import <MJRefresh/MJRefresh.h>

@interface SupermarketMyCollectionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic)NSMutableArray *dataArray;
@property (strong,nonatomic)NSMutableArray *selectedArray;
@property (strong,nonatomic)UITableView *myTableView;
@property (strong,nonatomic)UIButton *allSellectedButton;

@end

@implementation SupermarketMyCollectionViewController {
    UIButton *collectionDelete;//收藏夹删除
    UIButton *collectionDeleteTile;//收藏夹删除
    UIButton *collectionMoveShoppingCart;//收藏夹移入购物车
    UIButton *collectionMoveShoppingCartTitle;//收藏夹移入购物车
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
}



- (void)popController {
    if (self.refresh != nil){
        self.refresh();
    }
    [super popController];
    
}

- (void)popToRootController {
    self.refresh();
    [super popToRootController];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"SMMyCollectionTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectedArray = [NSMutableArray array];
    [self setupCartView];
    
    [self.myTableView.mj_header beginRefreshing];
}

- (void)loadData {
        NSMutableArray *dataArray = [NSMutableArray array];
        [KLHttpTool getMyCollectionListWithAppType:6 success:^(id response) {
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSArray *data = response[@"data"];
                for (NSDictionary *dic in data) {
                     LZCartModel *model = [NSDictionary getLzCartModelWithDic:dic];
                     [dataArray addObject:model];
                }
                self.dataArray = dataArray;
                [self changeView];
            }
            [self.myTableView.mj_header endRefreshing];
        } failure:^(NSError *err) {
            [self.myTableView.mj_header endRefreshing];
        }];
}

#pragma mark -- 购物车为空时的默认视图
- (void)changeView {
    if (self.dataArray.count > 0) {
        UIView *view = [self.view viewWithTag:TAG_CartEmptyView];
        if (view != nil) {
            [view removeFromSuperview];
        }
        [self setupCartView];
    } else {
        UIView *bottomView = [self.view viewWithTag:TAG_CartEmptyView + 1];
        [bottomView removeFromSuperview];
        
        [self.myTableView removeFromSuperview];
        self.myTableView = nil;
        [self setupCartEmptyView];
    }
}

- (void)setupCartEmptyView {
    //默认视图背景
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, LZNaigationBarHeight, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight)];
    backgroundView.tag = TAG_CartEmptyView;
    [self.view addSubview:backgroundView];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:lz_CartEmptyString]];
    img.center = CGPointMake(LZSCREEN_WIDTH/2.0, LZSCREEN_HEIGHT/2.0 - 120);
    img.bounds = CGRectMake(0, 0, 247.0/187 * 100, 100);
    [backgroundView addSubview:img];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.center = CGPointMake(LZSCREEN_WIDTH/2.0, LZSCREEN_HEIGHT/2.0 - 10);
    warnLabel.bounds = CGRectMake(0, 0, LZSCREEN_WIDTH, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.text = NSLocalizedString(@"SMMyCollectionEmpty", nil);
    warnLabel.font = [UIFont systemFontOfSize:15];
    warnLabel.textColor = LZColorFromHex(0x706F6F);
    [backgroundView addSubview:warnLabel];
}

#pragma mark -- 有商品时的视图
- (void)setupCartView {
    //创建底部视图
    [self setupCustomBottomView];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [table registerClass:[LZCartTableViewCell class] forCellReuseIdentifier:@"LZCartReusableCell"];
    table.rowHeight = lz_CartRowHeight;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = LZColorFromRGB(245, 246, 248);
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49);
    }];
    self.myTableView = table;
    
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.selectedArray removeAllObjects];
            [self.dataArray removeAllObjects];
            [self loadData];
    }];
}

- (void)setupCustomBottomView {
    
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.tag = TAG_CartEmptyView + 1;
    backgroundView.frame = CGRectMake(0, LZSCREEN_HEIGHT -  LZTabBarHeight, LZSCREEN_WIDTH, LZTabBarHeight);
    [self.view addSubview:backgroundView];
    
    //全选按钮
    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:16];
    selectAll.frame = CGRectMake(10, 5, 80, LZTabBarHeight - 10);
    [selectAll setTitle:NSLocalizedString(@"SMMyCollectionChooseAll", nil) forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:lz_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:lz_Bottom_SelectButtonString] forState:UIControlStateSelected];
    [selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:selectAll];
    self.allSellectedButton = selectAll;
    
    collectionMoveShoppingCart = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionMoveShoppingCart.frame = CGRectMake(backgroundView.frame.size.width - 15 - 30, 4, 30, 30);
    [collectionMoveShoppingCart setImage:[UIImage imageNamed:@"shopping_cart"] forState:UIControlStateNormal];
    collectionMoveShoppingCart.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
    [collectionMoveShoppingCart addTarget:self action:@selector(movetoCart) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:collectionMoveShoppingCart];
    
    collectionMoveShoppingCartTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionMoveShoppingCartTitle.frame = CGRectMake(collectionMoveShoppingCart.frame.origin.x - 3, CGRectGetMaxY(collectionMoveShoppingCart.frame)-5, collectionMoveShoppingCart.frame.size.width+8, 20);
    [collectionMoveShoppingCartTitle setTitle:NSLocalizedString(@"SupermarketTabShoppingCart", nil) forState:UIControlStateNormal];
    [collectionMoveShoppingCartTitle setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    collectionMoveShoppingCartTitle.titleLabel.font = [UIFont systemFontOfSize:10];
    [backgroundView addSubview:collectionMoveShoppingCartTitle];
    
    collectionDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionDelete.frame = CGRectMake(CGRectGetMinX(collectionMoveShoppingCart.frame) - 10 - 30, collectionMoveShoppingCart.frame.origin.y, 22, 30);
    collectionDelete.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
    [collectionDelete addTarget:self action:@selector(deleteCollection) forControlEvents:UIControlEventTouchUpInside];
    [collectionDelete setImage:[UIImage imageNamed:@"collection_delete"] forState:UIControlStateNormal];
    [backgroundView addSubview:collectionDelete];
    
    collectionDeleteTile = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionDeleteTile.frame = CGRectMake(collectionDelete.frame.origin.x - 2, CGRectGetMaxY(collectionDelete.frame)-5, CGRectGetWidth(collectionDelete.frame) + 5, 20);
    [collectionDeleteTile addTarget:self action:@selector(deleteCollection) forControlEvents:UIControlEventTouchUpInside];
    [collectionDeleteTile setTitle:NSLocalizedString(@"SMDeleteTitle", nil) forState:UIControlStateNormal];
    [collectionDeleteTile setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    collectionDeleteTile.titleLabel.font = [UIFont systemFontOfSize:10];
    [backgroundView addSubview:collectionDeleteTile];
}

-(void)setDivCode:(NSString *)divCode{
    _divCode = [divCode copy];
}

-(void)movetoCart{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SMAlertMoveToCartMsg", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertSureTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     
        for (int i = 0; i < self.selectedArray.count; i++) {
            LZCartModel *model = self.selectedArray[i];
            [KLHttpTool addGoodsToShoppingCartWithGoodsID:model.item_code shopID:@"2" applyID:@"YC01" numbers:1 success:^(id response) {
                NSNumber *status = response[@"status"];
                if (status.integerValue == 1) {
                    [self showMessage:response[@"message"] interval:1.2 completionAction:nil];
                } else {
                    [self showMessage:response[@"message"] interval:1.2 completionAction:nil];
                }
            } failure:^(NSError *err) {
                [self showMessage:@"add failure" interval:1.2 completionAction:nil];
            }];
        }
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:confirm];
    [alertController addAction:cancle];
    [self presentViewController:alertController animated:true completion:nil];
    
}

#pragma mark --- UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LZCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZCartReusableCell" forIndexPath:indexPath];
    cell.isCollection = YES;
    LZCartModel *model = self.dataArray[indexPath.row];
    [cell cellSelectedWithBlock:^(BOOL select) {
        model.select = select;
        if (select) {
            [self.selectedArray addObject:model];
        } else {
            [self.selectedArray removeObject:model];
        }
        
        if (self.selectedArray.count == self.dataArray.count) {
            _allSellectedButton.selected = YES;
        } else {
            _allSellectedButton.selected = NO;
        }
    }];
    
    [cell reloadDataWithModel:model];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


#pragma mark --- 全选按钮点击事件
- (void)selectAllBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    //点击全选时,把之前已选择的全部删除
    for (LZCartModel *model in self.selectedArray) {
        model.select = NO;
    }
    
    [self.selectedArray removeAllObjects];
    
    if (button.selected) {
        
        for (LZCartModel *model in self.dataArray) {
            model.select = YES;
            [self.selectedArray addObject:model];
        }
    }
    
    [self.myTableView reloadData];
}

#pragma mark - 收藏夹删除商品
- (void)deleteCollection {
    if (self.selectedArray.count > 0) {
        UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SMAlertTitle", nil) message:NSLocalizedString(@"SMAlertDeleteCollectionMsg", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMDeleteTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableArray *goodsIDs = [NSMutableArray array];
            for (LZCartModel *model in self.selectedArray) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:model.item_code forKey:@"item_code"];
                [dic setObject:model.divCode forKey:@"div_code"];
                [goodsIDs addObject:dic];
            }
            [KLHttpTool deleteCollectionGoods:goodsIDs success:^(id response) {
                NSNumber *status = response[@"status"];
                if (status.integerValue == 1) {
                   [self showMessage:response[@"message"] interval:2 completionAction:nil];
                    for (LZCartModel *model in self.selectedArray) {
                        if ([self.dataArray containsObject:model]) {
                            [self.dataArray removeObject:model];
                        }
                    }
                    [self.selectedArray removeAllObjects];
                    [_myTableView reloadData];
                }
            } failure:^(NSError *err) {
                
            }];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIAlertActionStyleDefault handler:nil];
        [deleteAlert addAction:ok];
        [deleteAlert addAction:cancel];
        [self presentViewController:deleteAlert animated:YES completion:nil];
    } else {
        [self showMessage:NSLocalizedString(@"SMNoChooseGoodsMsg", nil) interval:2 completionAction:nil];
        //[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:NSLocalizedString(@"SMNoChooseGoodsMsg", nil)];
    }
}

@end


