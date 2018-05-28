//
//  TinyMainViewController.m
//  Portal
//
//  Created by dlwpdlr on 2018/5/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "TinyMainViewController.h"
#import "ChoiceHeadView.h"
#import "ShowLocationView.h"
#import "SupermarketHomeViewController.h"
#import "SupermarketSearchController.h"
#import "TSearchViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "GroomCollectionView.h"
#import "SearchIfView.h"
#import "ChoiceTableViewCell.h"
#import "TSCategoryController.h"
#import "FavCollectionView.h"
#import "PopDomainInputView.h"

@interface TinyMainViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *mainTableview;
@property (nonatomic, strong)ChoiceHeadView *choiceHeadView;
@property (nonatomic, strong)ShowLocationView *locationView;
@property (nonatomic,retain)UIButton *domainBtn;
@property (nonatomic,retain)GroomCollectionView *groomCollectionview;
@property (nonatomic,retain)FavCollectionView *favCollectionview;

@property (nonatomic,retain)SearchIfView *searchView;
@property (nonatomic,retain)NSDictionary *imgDic;
@property (nonatomic,retain)NSDictionary *searchDic;
@property (nonatomic,retain)NSArray *storelists;
@property(nonatomic,retain)PopDomainInputView *popInputView;
@property (nonatomic,retain)NSMutableArray *numberdata;
@end

@implementation TinyMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setNaviBar];
	[self location];
	[self createLocationView];
	[self createTabeleview];
	[self loadResquestData];

}

- (void)createTabeleview{
	if (self.mainTableview == nil) {
		self.mainTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		[self.mainTableview registerNib:[UINib nibWithNibName:@"ChoiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChoiceTableViewCellID"];
		self.mainTableview.hidden = YES;
		self.mainTableview.separatorColor = RGB(221, 221, 221);
		self.mainTableview.delegate = self;
		self.mainTableview.dataSource = self;
		self.mainTableview.estimatedRowHeight = 0;
		self.mainTableview.estimatedSectionHeaderHeight = 0;
		self.mainTableview.estimatedSectionFooterHeight = 0;
		self.mainTableview.tableHeaderView = [self tableViewHeadView];
		[self.view addSubview:_mainTableview];
		[self.mainTableview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.view);
		}];
	}
}

- (UIView*)tableViewHeadView{
	UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2+60)];
	headview.backgroundColor = [UIColor whiteColor];
	
	UIButton *goBtn = [UIButton new];
	[goBtn setTitle:@"GO" forState:UIControlStateNormal];
	[goBtn addTarget:self action:@selector(goBtn:) forControlEvents:UIControlEventTouchUpInside];
	goBtn.tag = 0;
	goBtn.backgroundColor = RGB(33, 192, 67);
	goBtn.layer.cornerRadius = 5;
	goBtn.layer.masksToBounds = YES;
	[headview addSubview:goBtn];
    [goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-10);
        make.bottom.mas_equalTo(headview.mas_bottom).offset(-10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
	
	
	self.domainBtn = [UIButton new];
	self.domainBtn.tag = 1;
	self.domainBtn.layer.cornerRadius = 5;
	self.domainBtn.layer.masksToBounds = YES;
	self.domainBtn.backgroundColor = RGB(221, 221, 221);
	[self.domainBtn setTitleColor:RGB(45, 45, 45) forState:UIControlStateNormal];
	[self.domainBtn addTarget:self action:@selector(goBtn:) forControlEvents:UIControlEventTouchUpInside];

	[headview addSubview:self.domainBtn];
	[self.domainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		
		make.trailing.mas_equalTo(goBtn.mas_leading).offset(-10);
		make.bottom.mas_equalTo(-10);
		make.height.mas_equalTo(40);
        make.leading.mas_equalTo(10);
	}];
	
   
	
	UIImageView *headImageview = [UIImageView new];
	headImageview.image = [UIImage imageNamed:@"banner"];
	[headview addSubview:headImageview];
	[headImageview mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.domainBtn.mas_top).offset(-10);
		
	}];
	
	
	return headview;
}

#pragma mark -- uitableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section == 3) {
		return self.storelists.count;
	}
	return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	
	return 4;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [UITableViewCell new];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if (indexPath.section == 0) {

		NSArray *dataFav = _imgDic[@"dataFav"];
		self.favCollectionview = [[FavCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/3.0f)];
		self.favCollectionview.datas = dataFav;
		[cell.contentView addSubview:self.favCollectionview];
		
		
	}else if (indexPath.section == 1) {
		
		    NSArray *grooms = _imgDic[@"data"];
			self.groomCollectionview = [[GroomCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ceil(grooms.count/5.0)*SCREEN_WIDTH/5.0)];
		    self.groomCollectionview.datas = _imgDic[@"data"];
			[cell.contentView addSubview:self.groomCollectionview];
		
	}else if (indexPath.section == 2){
			self.searchView = [SearchIfView new];
		__weak typeof(self) weakself = self;
			self.searchView.paramterdic = ^(NSMutableDictionary *dic) {
				[weakself orCorddingToIf:dic];
			};
			if (_searchDic !=nil) {
				self.searchView.dic = _searchDic;
			}
			[cell.contentView addSubview:self.searchView];
			[self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.edges.equalTo(cell.contentView);
			}];
	}else {
		ChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceTableViewCellID"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		NSDictionary *dic = self.storelists[indexPath.row];
		cell.starValue = [dic[@"score"] doubleValue];
		cell.dic = dic;
		
		return cell;
	}

	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) {
		return SCREEN_WIDTH/3.0f;
	}else if (indexPath.section == 1){
		NSArray *grrooms = _imgDic[@"data"];
		return ceil(grrooms.count/5.0f)*SCREEN_WIDTH/5;
	}else if (indexPath.section == 2){
		return 120;
	}
	return 120.0f;
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (section == 0) {
		return 6.0f;
	}
	return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	if (section == 1) {
		return 6.0f;
	}
	return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 3) {
		NSDictionary *dic = self.storelists[indexPath.row];
		BusinessHomeController *shopDetailed = [[BusinessHomeController alloc] init];
		shopDetailed.hidesBottomBarWhenPushed = YES;
		shopDetailed.dic = dic;
		[self.navigationController pushViewController:shopDetailed animated:YES];

	}
}
#pragma mark -- 设置导航栏
- (void)setNaviBar{
	
	UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_home_scan"] style:UIBarButtonItemStylePlain target:self action:@selector(scanQR)];
	rightItem1.tag = 1001;
	rightItem1.tintColor = [UIColor darkTextColor];
	
	UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_searchhotel"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
	rightItem2.tag = 1002;
	rightItem2.imageInsets = UIEdgeInsetsMake(0, 13, 0, -13);
	rightItem2.tintColor = [UIColor darkTextColor];
	[self.navigationItem setRightBarButtonItems:@[rightItem1,rightItem2]];
	
	UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
	[leftBtn setImage:[UIImage imageNamed:@"mainlogo.png"] forState:UIControlStateNormal];
	leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
	leftBtn.tag = 1003;
	[self.navigationItem setLeftBarButtonItem:leftItem];
	
	
	
}

- (void)createLocationView{
	
	self.choiceHeadView = [[ChoiceHeadView alloc]initWithFrame:CGRectMake(0, 0, 200, 30) withTextColor:RGB(253, 253, 253) withData:@[@"icon_location",@"icon_arrow_bottom"]];
	__weak typeof(self) weakSelf = self;
	self.choiceHeadView.showAction = ^{
		[weakSelf.locationView showInView:weakSelf.view.window];
		weakSelf.locationView.location = ^{
			//			[weakSelf location];
		};
		weakSelf.locationView.map = ^{
			AroundMapController * around = [[AroundMapController alloc] init];
			around.hidesBottomBarWhenPushed = YES;
			[weakSelf.navigationController pushViewController:around animated:YES];
		};
	};
	self.navigationItem.titleView = self.choiceHeadView;
	
}

-(void)location {
	
	[YCLocationService turnOn];
	[YCLocationService singleUpdate:^(CLLocation * location) {
		
		//保存定位经纬度
		CLLocationCoordinate2D location2d = location.coordinate;
		NSString *latitude = [NSString stringWithFormat:@"%f",location2d.latitude] ;
		NSString *longtitude =  [NSString stringWithFormat:@"%f",location2d.longitude];
		SetUserDefault(@"latitude", latitude);
		SetUserDefault(@"longtitude", longtitude);
		
		[YCLocationService turnOff];
		CLGeocoder *geocoder = [[CLGeocoder alloc] init];
		[geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
			if (placemarks.count > 0) {
				NSString *address = placemarks.firstObject.name;
				
				SetUserDefault(@"Address", address);
				self.choiceHeadView.addressName = address;
//				if (first) {
//					[self loadMainDataWithType:topRefresh finish:^{ }];
//					first = NO;
//				}
			} else {
				self.choiceHeadView.addressName =  NSLocalizedString(@"定位失败", nil) ;
			};
		}];
	} failure:^(NSError * error) {
		[YCLocationService turnOff];
		self.choiceHeadView.addressName = NSLocalizedString(@"定位失败", nil) ;
	}];
}

-(ShowLocationView *)locationView {
	if (_locationView == nil) {
		_locationView = [[ShowLocationView alloc] init];
	}
	return _locationView;
}


- (void)searchAction:(UIButton*)sender{
	
	//创建热搜的数组
	NSArray *hotSeaches = [NSArray array];
	//创建搜索结果的控制器
	PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"搜索关键字", nil)  didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText)
													{
														TSearchViewController *searchResultVC = [[TSearchViewController alloc] init];
														searchResultVC.searchKeyWord = searchText;
														searchResultVC.navigationItem.title = NSLocalizedString(@"搜索结果", nil) ;
														[searchViewController.navigationController pushViewController:searchResultVC animated:YES];
													}];
	//创建搜索的控制器
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
	[self presentViewController:nav  animated:NO completion:nil];
	
	
}



//扫码
- (void)scanQR{
	ZFScanViewController *scanVC = [[ZFScanViewController alloc] init];
	scanVC.autoGoBack = YES;
	__weak typeof(self) weakself = self;
	scanVC.returnScanBarCodeValue = ^(NSString *barCodeString) {
		NSURLComponents *components = [[NSURLComponents alloc] initWithString:barCodeString];
		if ([components.scheme isEqualToString:@"giga"]) {
			if ([components.host isEqualToString:@"qrPay"]) {
				NSString *numcode = components.query;
				InputAmountController *input = [[InputAmountController alloc] init];
				input.hidesBottomBarWhenPushed = YES;
				input.numcode = numcode;
				input.payCompletion = ^(BOOL state) {
					if (state) {
						[weakself.navigationController popViewControllerAnimated:YES];
					}
				};
				[weakself.navigationController pushViewController:input animated:YES];
			}
		}
		
	};
	[self presentViewController:scanVC animated:YES completion:nil];
	
}

- (void)clickMainImg:(UIButton*)sender{
	NSLog(@"%d",(int)sender.tag);
	NSArray *dat = _imgDic[@"dataFav"];
	NSDictionary *dic = dat[(int)sender.tag];
	TSCategoryController *cateVC = [[TSCategoryController alloc]init];
	cateVC.hidesBottomBarWhenPushed = YES;
	cateVC.leves = @[dic[@"level1"],@"1",@"1"].mutableCopy;
	[self.navigationController pushViewController:cateVC animated:YES];

}

- (void)goBtn:(UIButton*)sender{
	if (sender.tag == 1) {
		__weak typeof(self) weakself = self;
		self.popInputView = [PopDomainInputView new];
		self.popInputView.submitblock = ^(NSMutableArray *data) {
			weakself.numberdata = data;
			NSString *addstr = data.firstObject;
			for (int i = 0;i<4;i++) {
				NSString *str = data[i+1];
				addstr = [NSString stringWithFormat:@"%@-%@",addstr,str];
			}

			[weakself.domainBtn setTitle:addstr forState:UIControlStateNormal];
			
		};
		[[UIApplication sharedApplication].delegate.window addSubview:self.popInputView];
		[self.popInputView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.mas_equalTo(30);
			make.trailing.mas_equalTo(-30);
			make.height.mas_equalTo(200);
            make.bottom.mas_equalTo(-SCREEN_HEIGHT/2.0f);
			
		}];
	} else {
		[self loadInputDomain:self.numberdata];

	}
	
	
		
}

- (void)loadResquestData{
	
	MBProgressHUD *showhud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[showhud showAnimated:YES];
	YCAccountModel *account = [YCAccountModel getAccount];
	NSString *token = account.token;
	NSString*userid = account.customCode;
	dispatch_async(dispatch_get_global_queue(0, 0), ^{

		[KLHttpTool getMainPicturewithUri:@"StoreCate/requestStoreCate1FavList" withUserId:(userid.length?userid:@"") withToken:(token.length?token:@"") success:^(id response) {
			if ([response[@"status"] intValue] == 1) {
				_imgDic = response;
				[KLHttpTool getDisKindswithUri:@"StoreCate/requestStoreCate1Where" success:^(id response) {
					if ([response[@"status"] intValue] == 1) {
						_searchDic = response;
						dispatch_async(dispatch_get_main_queue(), ^{
							[showhud hideAnimated:YES];
							self.mainTableview.hidden = NO;
							[self.mainTableview reloadData];
		
						});
		
					}
				} failure:^(NSError *err) {
		
				}];


			}
		} failure:^(NSError *err) {
			
		}];
		
		
		
	});
	
	
	
}
- (void)orCorddingToIf:(NSMutableDictionary*)dic{

	YCAccountModel *account = [YCAccountModel getAccount];
	NSString *token = account.token;
	NSString*userid = account.customCode;
	NSString *commbine = account.combineToken;
	[KLHttpTool getStoreListWithIfWithUri:@"StoreCate/requestStoreSearchList" withUserId:(userid.length?userid:@"") withToken:(token.length?token:@"") withPg:@"1" withPageSize:@"5" withLatitude:GetUserDefault(@"latitude") withlongitude:GetUserDefault(@"longtitude") withParamter:dic success:^(id response) {
		if ([response[@"status"] intValue]==1) {
			self.storelists = response[@"storelist"];
			NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:3];
			[self.mainTableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

		}
	} failure:^(NSError *err) {
		
	}];
}

- (void)loadInputDomain:(NSMutableArray*)data{
	NSString *addstr = data.firstObject;
	for (int i = 0;i<4;i++) {
		NSString *str = data[i+1];
		addstr = [NSString stringWithFormat:@"%@-%@",addstr,str];
	}

	[KLHttpTool getInputDomainViewwithUri:nil withad_num:addstr witht_num:data.firstObject withl_num:data[1] withr_num:data[2] withb_num:data[3] withc_num:data[4] withlatitude:GetUserDefault(@"latitude") withlongitude:GetUserDefault(@"longtitude") success:^(id response) {
		if ([response[@"status"] intValue] == 1) {
			NSDictionary *dic = response[@"data"];
			BusinessHomeController *shopDetailed = [[BusinessHomeController alloc] init];
			shopDetailed.hidesBottomBarWhenPushed = YES;
			shopDetailed.dic = dic;
			[self.navigationController pushViewController:shopDetailed animated:YES];
		}
	} failure:^(NSError *err) {
		
	}];
}
@end
