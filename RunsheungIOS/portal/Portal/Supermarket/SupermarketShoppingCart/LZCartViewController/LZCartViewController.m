//


#import "LZCartViewController.h"
#import "LZConfigFile.h"
#import "LZCartTableViewCell.h"
#import "LZCartModel.h"
#import "SupermarketChangeBuyView.h"
#import "SupermarketConfrimOrderByNumbersController.h"
#import "MJRefresh.h"
#import "LZShopModel.h"
#import "LZTableHeaderView.h"
#import "GoodsDetailController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "Masonry.h"
#import "LZCartEmptyView.h"
#import <MBProgressHUD/MBProgressHUD.h>

typedef void(^finishAction)();

@interface LZCartViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
	BOOL _isHiddenNavigationBarWhenDisappear;//记录当页面消失时是否需要隐藏系统导航
	BOOL _isHasTabBarController;//是否含有tabbar
	BOOL _isHasNavitationController;//是否含有导航
}

@property (strong,nonatomic)__block NSMutableArray *dataArray;
@property (strong,nonatomic)__block NSMutableArray *selectedArray;
@property (strong,nonatomic)UITableView *myTableView;
@property (strong,nonatomic)UIButton *allSellectedButton;
@property (strong,nonatomic)UILabel *totlePriceLabel;
@property(nonatomic, strong) NSMutableArray *selectedShopArray;
@property(nonatomic, assign)BOOL isloading;
@property(nonatomic, strong)UIActivityIndicatorView *indicator;


@end


@implementation LZCartViewController {
	UIButton *_edit;//导航栏编辑按钮
	NSMutableArray * _dataArray;
	UIButton *delete;
	UIButton *moveToCollection;
	
	UILabel *label;//合计
	UIButton *btn;//立即购买
	
	UIButton *collectionDelete;//收藏夹删除
	UIButton *collectionDeleteTile;//收藏夹删除
	UIButton *collectionMoveShoppingCart;//收藏夹移入购物车
	UIButton *collectionMoveShoppingCartTitle;//收藏夹移入购物车
	
	UISegmentedControl *segment;
	
	UIView *backgroundView;
}
#pragma mark - viewController life cicle
- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	
	//当进入购物车的时候判断是否有已选择的商品,有就清空
	//主要是提交订单后再返回到购物车,如果不清空,还会显示
	if (self.selectedArray.count > 0) {
		for (LZCartModel *model in self.selectedArray) {
			model.select = NO;//这个其实有点多余,提交订单后的数据源不会包含这些,保险起见,加上了
		}
		[self.selectedArray removeAllObjects];
	}
	
	_allSellectedButton.selected = NO;
	_totlePriceLabel.attributedText = [self LZSetString:@"￥0.00"];
	
	[self.myTableView reloadData];
	
}


- (void)loadData {
	//    [self requestShoppingCartData];
	[self requestShoppingCartData:^{
		
	}];
	segment.selectedSegmentIndex = 0;
	
}

-(void)hideBottomAndBarItem:(BOOL)ishide {
	if (ishide) {
		_edit.hidden = YES;
	}else {
		_edit.hidden = NO;
	}
}


- (void)requestShoppingCartData:(finishAction)finish{
	[self.indicator startAnimating];
	[KLHttpTool getSupermarketShoppintCartListWithAppType:6 success:^(id response) {
		[self.indicator stopAnimating];
		self.isloading = NO;
		NSNumber *status = response[@"status"];
		if (status.integerValue == 1) {
			NSArray *data = response[@"data"];
			if (data.count > 0) {
				self.dataArray = [NSDictionary getShoppingartListShopsWithData:data];
			}
		}else {
			[MBProgressHUD hideAfterDelayWithView:self.view interval:2 text:response[@"message"]];
		}
		[NSOperationQueue.mainQueue addOperationWithBlock:^{
			[self.myTableView reloadData];
		}];
		finish();
	} failure:^(NSError *err) {
		[self.myTableView reloadEmptyDataSet];
		finish();
	}];
	
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = @"购物车";
	self.isloading = YES;
	[self setNavigationBar];
	
	self.selectedShopArray = [NSMutableArray array];
	self.dataArray = [NSMutableArray array];
	self.selectedArray = [NSMutableArray array];
	
	//    [self checkLogStatus];
	
	//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkLogStatus) name:SupermarketSelectTabBar object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"YCAccountIsLogin" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseDivCode:) name:@"ChooseDivCode" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAllData) name:@"ReloadShoppingCartNotification" object:nil];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	_isHasTabBarController = self.tabBarController?YES:NO;
	_isHasNavitationController = self.navigationController?YES:NO;
	
	self.myTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	self.myTableView.translatesAutoresizingMaskIntoConstraints = NO;
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
	self.myTableView.emptyDataSetSource = self;
	self.myTableView.emptyDataSetDelegate = self;
	self.myTableView.rowHeight = lz_CartRowHeight;
	self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.myTableView.backgroundColor = LZColorFromRGB(245, 246, 248);
	self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[self.selectedArray removeAllObjects];
		//                [self.dataArray removeAllObjects];
		//                [self.myTableView reloadData];
		//        [self reloadAllData];
		[self requestShoppingCartData:^{
			[self.myTableView.mj_header endRefreshing];
		}];
	}];
	[self.myTableView registerClass:[LZTableHeaderView class] forHeaderFooterViewReuseIdentifier:@"LZHeaderView"];
	[self.view addSubview:self.myTableView];
	if (@available(iOS 11.0, *)) {
		self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
		NSArray *layoutConstraints = @[
									   [self.myTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
									   [self.myTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
									   [self.myTableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
									   [self.myTableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
									   ];
		[NSLayoutConstraint activateConstraints:layoutConstraints];
	} else {
		self.automaticallyAdjustsScrollViewInsets = NO;
		NSArray *layoutConstraints =  @[
										[self.myTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
										[self.myTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
										[self.myTableView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor],
										[self.myTableView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor]
										];
		[NSLayoutConstraint activateConstraints:layoutConstraints];
	}
	self.myTableView.contentInset = UIEdgeInsetsMake(0, 0, LZTabBarHeight, 0);
	
	[self setupCustomBottomView];
	
	
	self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.indicator.hidesWhenStopped = YES;
	[self.view addSubview:self.indicator];
	[self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.view);
	}];
	
	[self requestShoppingCartData:^{
		
	}];
	//
}

- (void)dealloc
{
	[NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)setNavigationBar {
	_edit = [UIButton buttonWithType:UIButtonTypeCustom];
	[_edit setTitle:NSLocalizedString(@"SMShoppingCartEdit", nil) forState:UIControlStateNormal];
	[_edit setTitle:NSLocalizedString(@"SMShoppingCartFinish", nil) forState:UIControlStateSelected];
	_edit.titleLabel.font = [UIFont systemFontOfSize:15];
	[_edit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	_edit.frame = CGRectMake(0, 0, 50, 25);
	[_edit addTarget:self action:@selector(editAll:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_edit];
	self.navigationItem.rightBarButtonItem = rightItem;
	if (_isPush) {
		UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
		back.frame = CGRectMake(0, 0, 25, 25);
		[back setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
		[back addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:back];
		UIBarButtonItem *navBack = [[UIBarButtonItem alloc] initWithCustomView:back];
		self.navigationItem.leftBarButtonItem = navBack;
	}
}


- (void)chooseDivCode:(NSNotification *)notification {
	NSArray *arr = notification.object;
	self.divCode = arr.firstObject;
}

- (void)loginSuccess:(NSNotification *)notification {
	BOOL islogIn = [YCAccountModel islogin];
	if (islogIn) {
		[self loadData];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	//    if (_isHiddenNavigationBarWhenDisappear == YES) {
	//        self.navigationController.navigationBarHidden = NO;
	//    }
}

/**
 *  @author LQQ, 16-02-18 11:02:16
 *
 *  计算已选中商品金额
 */
-(float)countPrice {
	double totlePrice = 0.0;
	
	for (LZCartModel *model in self.selectedArray) {
		
		double price = [model.price doubleValue];
		
		totlePrice += price*model.number;
	}
	NSString *string = [NSString stringWithFormat:@"￥%.2f",totlePrice];
	self.totlePriceLabel.attributedText = [self LZSetString:string];
	
	return totlePrice;
}

#pragma mark - 初始化数组

-(void)setDataArray:(NSMutableArray *)dataArray {
	_dataArray = [dataArray mutableCopy];
	if (dataArray.count == 0) {
		[self hideBottomAndBarItem:YES];
	}else {
		[self hideBottomAndBarItem:NO];
	}
}

-(NSMutableArray *)dataArray {
	return _dataArray;
}



#pragma mark - 布局页面视图
#pragma mark -- 自定义导航
- (void)setupCustomNavigationBar {
	UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LZSCREEN_WIDTH, LZNaigationBarHeight)];
	backgroundView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:backgroundView];
	
	UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, LZNaigationBarHeight - 0.5, LZSCREEN_WIDTH, 0.5)];
	lineView.backgroundColor = [UIColor lightGrayColor];
	[self.view addSubview:lineView];
	
	UILabel *titleLabel = [[UILabel alloc]init];
	titleLabel.text = NSLocalizedString(@"SupermarketTabShoppingCart", nil);
	
	titleLabel.textColor = [UIColor darkGrayColor];
	titleLabel.font = [UIFont systemFontOfSize:18];
	
	titleLabel.center = CGPointMake(self.view.center.x, (LZNaigationBarHeight - 20)/2.0 + 20);
	CGSize size = [titleLabel sizeThatFits:CGSizeMake(300, 44)];
	titleLabel.bounds = CGRectMake(0, 0, size.width + 20, size.height);
	
	titleLabel.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:titleLabel];
	
	NSArray *titles = @[@"线上购物车",@"线下购物车"];
	segment = [[UISegmentedControl alloc]initWithItems:titles];
	segment.tintColor = GreenColor;
	segment.frame = CGRectMake(0, 0, 180, 25);
	segment.center = CGPointMake(self.view.center.x, (LZNaigationBarHeight - 25)/2.0 + 20);
	//    [self.view addSubview:segment];
	
	//    _edit = [UIButton buttonWithType:UIButtonTypeCustom];
	//    [_edit setTitle:NSLocalizedString(@"SMShoppingCartEdit", nil) forState:UIControlStateNormal];
	//    [_edit setTitle:NSLocalizedString(@"SMShoppingCartFinish", nil) forState:UIControlStateSelected];
	//    _edit.titleLabel.font = [UIFont systemFontOfSize:14];
	//    [_edit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	//    _edit.frame = CGRectMake(APPScreenWidth - 50, backgroundView.frame.size.height-33, 50, 25);
	//    [_edit addTarget:self action:@selector(editAll:) forControlEvents:UIControlEventTouchUpInside];
	//    [self.view addSubview:_edit];
	
	//    if (_isPush) {
	//        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
	//        back.frame = CGRectMake(15, backgroundView.frame.size.height-33, 25, 25);
	//        [back setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
	//        [back addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
	//        [self.view addSubview:back];
	//    }
}

- (void)popController {
	[self.navigationController popViewControllerAnimated:YES];
}


//购物车编辑,删除或者移入收藏夹
- (void)editAll:(UIButton *)button {
	button.selected = !button.selected;
	if (button.selected == YES) {
		delete.hidden = NO;
		moveToCollection.hidden = NO;
		label.hidden = YES;
	} else {
		delete.hidden = YES;
		moveToCollection.hidden = YES;
		label.hidden = NO;
	}
	
}


#pragma mark -- 自定义底部视图
- (void)setupCustomBottomView {
	
	backgroundView = [[UIView alloc]init];
	backgroundView.backgroundColor = [UIColor whiteColor];
	backgroundView.tag = TAG_CartEmptyView + 1;
	[self.view addSubview:backgroundView];
	
	//当有tabBarController时,在tabBar的上面
	if (_isHasTabBarController == YES) {
		//        backgroundView.frame = CGRectMake(0, LZSCREEN_HEIGHT -  2*LZTabBarHeight, LZSCREEN_WIDTH, LZTabBarHeight);
		backgroundView.frame = CGRectMake(0, self.tabBarController.tabBar.frame.origin.y - LZTabBarHeight, LZSCREEN_WIDTH, LZTabBarHeight);
		
		NSLog(@"%f",self.tabBarController.tabBar.frame.origin.y);
		if (_isPush) {
			backgroundView.frame = CGRectMake(0, LZSCREEN_HEIGHT -  LZTabBarHeight, LZSCREEN_WIDTH, LZTabBarHeight);
		}
	} else {
		backgroundView.frame = CGRectMake(0, LZSCREEN_HEIGHT -  LZTabBarHeight, LZSCREEN_WIDTH, LZTabBarHeight);
	}
	
	UIView *lineView = [[UIView alloc]init];
	lineView.frame = CGRectMake(0, 0, LZSCREEN_WIDTH, 1);
	lineView.backgroundColor = [UIColor lightGrayColor];
	[backgroundView addSubview:lineView];
	
	//全选按钮
	UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
	selectAll.titleLabel.font = [UIFont systemFontOfSize:14];
	selectAll.frame = CGRectMake(10, 5, 80, LZTabBarHeight - 10);
	[selectAll setTitle:NSLocalizedString(@"SMMyCollectionChooseAll", nil) forState:UIControlStateNormal];
	[selectAll setImage:[UIImage imageNamed:lz_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
	[selectAll setImage:[UIImage imageNamed:lz_Bottom_SelectButtonString] forState:UIControlStateSelected];
	[selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[backgroundView addSubview:selectAll];
	self.allSellectedButton = selectAll;
	
	//结算按钮
	btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.backgroundColor = RGB(33, 192, 67);
	btn.layer.cornerRadius = 3.0f;
	btn.titleLabel.font = [UIFont systemFontOfSize:15];
	btn.frame = CGRectMake(LZSCREEN_WIDTH - 100 - 5, 5, 100, LZTabBarHeight - 10);
	[btn setTitle:NSLocalizedString(@"SMShoppingCartBuyNow", nil) forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(goToPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[backgroundView addSubview:btn];
	
	//删除按钮
	delete = [UIButton buttonWithType:UIButtonTypeCustom];
	delete.backgroundColor = [UIColor redColor];
	[delete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	delete.titleLabel.font = [UIFont systemFontOfSize:15];
	delete.frame = btn.frame;
	[delete addTarget:self action:@selector(deleteGoods:) forControlEvents:UIControlEventTouchUpInside];
	delete.hidden = YES;
	[delete setTitle:NSLocalizedString(@"SMDeleteTitle", nil) forState:UIControlStateNormal];
	[backgroundView addSubview:delete];
	
	//移到收藏夹
	moveToCollection = [UIButton buttonWithType:UIButtonTypeCustom];
	moveToCollection.backgroundColor = [UIColor orangeColor];
	[moveToCollection setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	moveToCollection.titleLabel.font = [UIFont systemFontOfSize:15];
	moveToCollection.frame = CGRectMake(CGRectGetMinX(delete.frame) - 10 - delete.frame.size.width, delete.frame.origin.y, delete.frame.size.width, delete.frame.size.height);
	[moveToCollection setTitle:NSLocalizedString(@"SMMoveToCollectionButtonTitle", nil) forState:UIControlStateNormal];
	moveToCollection.hidden = YES;
	[moveToCollection addTarget:self action:@selector(moveToCollection:) forControlEvents:UIControlEventTouchUpInside];
	[backgroundView addSubview:moveToCollection];
	
	//合计
	label = [[UILabel alloc]init];
	label.font = [UIFont systemFontOfSize:14];
	label.textColor = [UIColor redColor];
	[backgroundView addSubview:label];
	
	label.attributedText = [self LZSetString:@"¥0.00"];
	CGFloat maxWidth = LZSCREEN_WIDTH - selectAll.bounds.size.width - btn.bounds.size.width - 25;
	//    CGSize size = [label sizeThatFits:CGSizeMake(maxWidth, LZTabBarHeight)];
	label.frame = CGRectMake(selectAll.bounds.size.width + 20, 0, maxWidth - 10, LZTabBarHeight);
	self.totlePriceLabel = label;
	
	btn.hidden = NO;
	label.hidden = NO;
	
}

- (NSMutableAttributedString*)LZSetString:(NSString*)string {
	
	NSString *text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"SMShoppingCartTotalCount", nil),string];
	NSMutableAttributedString *LZString = [[NSMutableAttributedString alloc]initWithString:text];
	NSRange rang = [text rangeOfString:NSLocalizedString(@"SMShoppingCartTotalCount", nil)];
	[LZString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
	[LZString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:rang];
	return LZString;
}

- (void)reloadAllData {
	__weak typeof(self) weakself = self;

	[weakself requestShoppingCartData:^{
		
	}];

//	NSMutableArray *allShopModelArray = @[].mutableCopy;
//	for (LZShopModel *shopModel in self.dataArray) {
//		NSMutableArray *shopModelGoodsArray = shopModel.goodsArray;
//
//		NSMutableArray *shopModelSelectsArray = shopModel.selectedGoodsArray;
//		[shopModelGoodsArray removeObjectsInArray:shopModelSelectsArray];
//		shopModel.goodsArray = shopModelGoodsArray;
//		[allShopModelArray addObject:shopModel];
//
//	}
//	if (self.selectedArray.count > 0) {
//		[self.selectedArray removeAllObjects];
//
//	}
//
//	if (self.dataArray.count >0) {
//		[self.dataArray removeAllObjects];
//	}
//	if (allShopModelArray.count>0) {
//		[self.dataArray removeObjectsInArray:allShopModelArray];
//	}
//	[self.myTableView reloadData];
}

#pragma mark --- UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	LZShopModel *model = [self.dataArray objectAtIndex:section];
	return model.goodsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	LZCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZCartReusableCell"];
	
	if (cell == nil) {
		cell = [[LZCartTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LZCartReusableCell"];
	}
	
	LZShopModel *shopModel = self.dataArray[indexPath.section];
	LZCartModel *model = [shopModel.goodsArray objectAtIndex:indexPath.row];
	
	__block typeof(cell)wsCell = cell;
	
	[cell numberAddWithBlock:^(NSInteger number) {
		wsCell.lzNumber = number;
		model.number = number;
		
		[shopModel.goodsArray replaceObjectAtIndex:indexPath.row withObject:model];
		if ([self.selectedArray containsObject:model]) {
			[self.selectedArray removeObject:model];
			[self.selectedArray addObject:model];
			[self countPrice];
		}
		
		LZCartModel *model = shopModel.goodsArray[indexPath.row];
		NSMutableDictionary *params = @{}.mutableCopy;
		[params setObject:model.item_code forKey:@"item_code"];
		[params setObject:[NSString stringWithFormat:@"%ld",model.number] forKey:@"item_quantity"];
		[params setObject:model.divCode forKey:@"div_code"];
		
		NSArray *dataArr = [NSArray arrayWithObjects:params,nil];
		
		if (self.controllerType == ControllerTypeDepartmentStores) {
			
			[KLHttpTool editSupermarketShoppingCartWithDataArray:dataArr success:^(id response) {
			} failure:^(NSError *err) {
				
			}];
		} else {
			[KLHttpTool editSupermarketShoppingCartWithDataArray:dataArr success:^(id response) {
			} failure:^(NSError *err) {
				
			}];
		}
		
	}];
	
	[cell numberCutWithBlock:^(NSInteger number) {
		
		wsCell.lzNumber = number;
		model.number = number;
		
		[shopModel.goodsArray replaceObjectAtIndex:indexPath.row withObject:model];
		
		//判断已选择数组里有无该对象,有就删除  重新添加
		if ([self.selectedArray containsObject:model]) {
			[self.selectedArray removeObject:model];
			[self.selectedArray addObject:model];
			[self countPrice];
		}
		
		LZCartModel *model = shopModel.goodsArray[indexPath.row];
		NSMutableDictionary *params = @{}.mutableCopy;
		[params setObject:model.item_code forKey:@"item_code"];
		[params setObject:[NSString stringWithFormat:@"%ld",number] forKey:@"item_quantity"];
		[params setObject:model.divCode forKey:@"div_code"];
		
		if (self.controllerType == ControllerTypeDepartmentStores) {
			[KLHttpTool editSupermarketShoppingCartWithDataArray:@[params] success:^(id response) {
			} failure:^(NSError *err) {
				
			}];
		} else {
			[KLHttpTool editSupermarketShoppingCartWithDataArray:@[params] success:^(id response) {
				
			} failure:^(NSError *err) {
				
			}];
		}
		
	}];
	
	
	[cell cellSelectedWithBlock:^(BOOL select) {
		
		model.select = select;
		if (select) {
			[self.selectedArray addObject:model];
			[shopModel.selectedGoodsArray addObject:model];
			if (![self.selectedShopArray containsObject:shopModel]) {
				[self.selectedShopArray addObject:shopModel];
			}
		} else {
			[self.selectedArray removeObject:model];
			[shopModel.selectedGoodsArray removeObject:model];
			if (shopModel.selectedGoodsArray.count == 0) {
				[self.selectedShopArray removeObject:shopModel];
			}
		}
		
		[self verityAllSelectState];
		[self verityGroupSelectState:indexPath.section];
		
		[self countPrice];
	}];
	
	[cell reloadDataWithModel:model];
	return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return NSLocalizedString(@"SMDeleteTitle", nil);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	LZTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LZHeaderView"];
	view.contentView.backgroundColor = [UIColor whiteColor];
	
	LZShopModel *model = [self.dataArray objectAtIndex:section];
	
	view.title = model.shopName;
	view.selectShop = model.select;
	view.isEditingSelected = model.editing;
	view.lzClickBlock = ^(BOOL select) {
		model.select = select;
		if (select) {
			for (LZCartModel *good in model.goodsArray) {
				good.select = YES;
				if (![self.selectedArray containsObject:good]) {
					[self.selectedArray addObject:good];
				}
			}
		} else {
			for (LZCartModel *good in model.goodsArray) {
				good.select = NO;
				if ([self.selectedArray containsObject:good]) {
					[self.selectedArray removeObject:good];
				}
			}
		}
		[self verityAllSelectState];
		[tableView reloadData];
		[self countPrice];
	};
	
	//点击头视图编辑删除
	view.editClickBlock = ^(BOOL select) {
		model.editing = select;
		
		if (select) {
			for (LZCartModel *good in model.goodsArray) {
				good.isEditing = YES;
			}
		}
		else {
			for (LZCartModel *good in model.goodsArray) {
				good.isEditing = NO;
			}
		}
		[tableView reloadData];
	};
	
	return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	return LZTableViewHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	GoodsDetailController *goodsDetail = [[GoodsDetailController alloc] init];
	goodsDetail.controllerType = self.controllerType;
	goodsDetail.hidesBottomBarWhenPushed = YES;
	
	LZShopModel *shop = self.dataArray[indexPath.section];
	LZCartModel *goods = shop.goodsArray[indexPath.row];
	
	goodsDetail.item_code = goods.item_code;
	goodsDetail.divCode = goods.divCode;
	goodsDetail.shopCode = goods.sale_custom_code;
	
	[self.navigationController pushViewController:goodsDetail animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return  UITableViewCellEditingStyleDelete; // 要实现左滑删除的那一行的编辑风格必须是Delete风格
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	__weak typeof(self) weakself = self;
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SMAlertTitle", nil) message:NSLocalizedString(@"SMAlertDeleteCollectionMsg", nil) preferredStyle:1];
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertSureTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			
			LZShopModel *shop = [self.dataArray objectAtIndex:indexPath.section];
			LZCartModel *model = [shop.goodsArray objectAtIndex:indexPath.row];
			
			[shop.goodsArray removeObjectAtIndex:indexPath.row];
			//    删除
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			
			//判断删除的商品是否已选择
			if ([self.selectedArray containsObject:model]) {
				//从已选中删除,重新计算价格
				[self.selectedArray removeObject:model];
				[self countPrice];
			}
			
			if (self.selectedArray.count == self.dataArray.count) {
				_allSellectedButton.selected = YES;
			} else {
				_allSellectedButton.selected = NO;
			}
			
			if (self.controllerType == ControllerTypeDepartmentStores) {
				[KLHttpTool deleteSupermarketShoppingCartGoodsWithIDs:@[model.item_code] divCodes:@[model.divCode] SaleCustomCodes:@[model.sale_custom_code]  success:^(id response) {
					NSNumber *status = response[@"status"];
					if (status.integerValue == 1) {
						[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
						[weakself reloadAllData];
					}
					
				} failure:^(NSError *err) {
					
				}];
				
			}
			else {
				[KLHttpTool deleteSupermarketShoppingCartGoodsWithIDs:@[model.item_code] divCodes:@[model.divCode] SaleCustomCodes:@[model.sale_custom_code] success:^(id response) {
					NSNumber *status = response[@"status"];
					if (status.integerValue == 1) {
						[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
						[weakself reloadAllData];
					}
					
				} failure:^(NSError *err) {
					
				}];
			}
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 0.3)), dispatch_get_main_queue(), ^{
				[weakself.myTableView reloadData];
			});
		}];
		
		UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIAlertActionStyleCancel handler:nil];
		[alert addAction:okAction];
		[alert addAction:cancel];
		[self presentViewController:alert animated:YES completion:nil];
	}
}

#pragma mark --- DZNEmptyDelegate & DZNEmptyDataSource

-(UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
	if (!self.isloading) {
		LZCartEmptyView *empty = [[LZCartEmptyView alloc]init];
		__weak typeof(self) weakself = self;
		empty.RefreshAction = ^(){
			[weakself requestShoppingCartData:^{
				
			}];
		};
		return empty;
	}else {
		return nil;
	}
}

//- (void)reloadTable {
//    [self.myTableView reloadData];
//}
#pragma mark --- 返回按钮点击事件
- (void)backButtonClick:(UIButton*)button {
	if (_isHasNavitationController == NO) {
		[self dismissViewControllerAnimated:YES completion:nil];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)verityGroupSelectState:(NSInteger)section {
	
	// 判断某个区的商品是否全选
	LZShopModel *tempShop = self.dataArray[section];
	// 是否全选标示符
	BOOL isShopAllSelect = YES;
	for (LZCartModel *model in tempShop.goodsArray) {
		// 当有一个为NO的是时候,将标示符置为NO,并跳出循环
		if (model.select == NO) {
			isShopAllSelect = NO;
			break;
		}
	}
	
	LZTableHeaderView *header = (LZTableHeaderView *)[self.myTableView headerViewForSection:section];
	header.selectShop = isShopAllSelect;
}

- (void)verityAllSelectState {
	
	NSInteger count = 0;
	for (LZShopModel *shop in self.dataArray) {
		count += shop.goodsArray.count;
	}
	
	if (self.selectedArray.count == count) {
		_allSellectedButton.selected = YES;
	} else {
		_allSellectedButton.selected = NO;
	}
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
		
		for (LZShopModel *shop in self.dataArray) {
			
			shop.select = YES;
			for (LZCartModel *model in shop.goodsArray) {
				model.select = YES;
				[self.selectedArray addObject:model];
			}
		}
	} else {
		for (LZShopModel *shop in self.dataArray) {
			shop.select = NO;
			for (LZCartModel *model in shop.goodsArray) {
				model.select = NO;
				[self.selectedArray removeObject:model];
			}
		}
	}
	
	[self.myTableView reloadData];
	[self countPrice];
}
#pragma mark --- 确认选择,提交订单按钮点击事件
- (void)goToPayButtonClick:(UIButton*)button {
	if (self.selectedArray.count > 0) {
		LZCartModel *firstModel = self.selectedArray.firstObject;
		NSString *divCode = firstModel.divCode;
		for (LZCartModel *model in self.selectedArray) {
			NSLog(@"选择的商品>>%@>>>%ld",model,(long)model.number);
			if (![model.divCode isEqualToString:divCode]) {
				[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:NSLocalizedString(@"SMShoppingCartMsg", nil)];
				return;
			}
		}
		SupermarketConfrimOrderByNumbersController *confirm = [[SupermarketConfrimOrderByNumbersController alloc] init];
		confirm.controllerType = self.controllerType;
		confirm.hidesBottomBarWhenPushed = YES;
		confirm.divCode = self.divCode;
		float totalPrice = [self countPrice];
		confirm.totalPrice = totalPrice;
		confirm.dataArray = self.selectedArray;
		confirm.shopArray = self.selectedShopArray;
		[self.navigationController pushViewController:confirm animated:YES];
	} else {
		[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"没有选择任何商品"];
	}
	
}

#pragma mark -- 移动到收藏夹
- (void)moveToCollection:(UIButton *)button {
	for (LZCartModel *model in _selectedArray) {
		NSString *code = [NSString stringWithFormat:@"%@",model.item_code];
//		if (self.controllerType == ControllerTypeDepartmentStores) {
//			[KLHttpTool addGoodsToMyCollection:code divCode:model.divCode success:^(id response) {
//				NSNumber *status = response[@"status"];
//				if (status.integerValue == 1) {
//					[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
//				}
//			} failure:^(NSError *err) {
//
//			}];
//
//		} else {
//			[KLHttpTool addGoodsToMyCollection:code divCode:model.divCode success:^(id response) {
//				NSNumber *status = response[@"status"];
//				if (status.integerValue == 1) {
//					[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
//				}
//			} failure:^(NSError *err) {
//
//			}];
//		}
	}
}

#pragma mark - 批量删除
//底部删除方法
- (void)deleteGoods:(UIButton *)button {
	
	NSMutableArray *selectedGoodsIDs = @[].mutableCopy;
	for (LZCartModel *model in self.selectedArray) {
		[selectedGoodsIDs addObject:model.item_code];
	}
	
	NSMutableArray *selctedGoodsDivCods = @[].mutableCopy;
	for (LZCartModel *model in self.selectedArray) {
		[selctedGoodsDivCods addObject:model.divCode];
	}
	
	NSMutableArray *selctedGoodsSaleCustomCodes = @[].mutableCopy;
	for (LZCartModel *model in self.selectedArray) {
		[selctedGoodsSaleCustomCodes addObject:model.sale_custom_code];
	}
	
	if (selectedGoodsIDs.count == 0) {
		[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"没有选择任何商品"];
		return;
	}
	
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SMAlertTitle", nil) message:NSLocalizedString(@"SMAlertDeleteCollectionMsg", nil) preferredStyle:1];
	
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertSureTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
		__weak typeof(self) weakself = self;
		if (self.controllerType == ControllerTypeDepartmentStores) {
			[KLHttpTool deleteSupermarketShoppingCartGoodsWithIDs:selectedGoodsIDs divCodes:selctedGoodsDivCods SaleCustomCodes:selctedGoodsSaleCustomCodes  success:^(id response) {
				NSNumber *status = response[@"status"];
				if (status.integerValue == 1) {
					[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
				}
				[[NSOperationQueue mainQueue] addOperationWithBlock:^{
					[weakself reloadAllData];
				}];
			} failure:^(NSError *err) {
				
			}];
			
		} else {
			[KLHttpTool deleteSupermarketShoppingCartGoodsWithIDs:selectedGoodsIDs divCodes:selctedGoodsDivCods  SaleCustomCodes:selctedGoodsSaleCustomCodes success:^(id  response) {
				NSNumber *status = response[@"status"];
				if (status.integerValue == 1) {
					[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
					[[NSOperationQueue mainQueue] addOperationWithBlock:^{
						[weakself reloadAllData];
					}];
				}
				
			} failure:^(NSError *err) {
				
			}];
		}
		
	}];
	
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIAlertActionStyleCancel handler:nil];
	
	[alert addAction:okAction];
	[alert addAction:cancel];
	[self presentViewController:alert animated:YES completion:nil];
}

@end


