//
//  SupermarketHomeViewController.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketHomeViewController.h"
#import "ZHSCorllHeader.h"
#import "SupermarketClassfictionView.h"
#import "SupermarketHomeAdview.h"
#import "SupermarketHomeWantBuyCollectionView.h"
#import "SupermarketHomeTasteNewCollectionView.h"
#import "SupermarketHomePanicBuyingCollectionView.h"
#import "CountTimeView.h"
#import "PYSearch.h"
#import "PYTempViewController.h"
#import "GoodsDetailController.h"
#import "NSDictionary+Decode.h"
#import "SupermarketHomePeopleLikeData.h"
#import "SupermarketHomeMostFreshData.h"
#import "SupermarketHomePurchaseData.h"
#import "SupermarketHomeTasteFreshBannerData.h"
#import "SupermarketHomeBannerData.h"
#import "SupermarketSearchResultViewController.h"
#import "SupermarketReleaseCommentController.h"
#import "HNScanViewController.h"
#import "LZCartViewController.h"
#import "SupermarketMyAddressViewController.h"
#import "SupermarketMyOrderController.h"
#import "SupermarketMostFreshController.h"
#import "SupermarketPopularFreshController.h"
#import "SupermarketOnSaleController.h"
#import "SupermarketTasteNewController.h"
#import "SupermarketLimitBuyController.h"
#import "SupermarketHomeADVData.h"
#import "IntergrationController.h"
#import "SupermarketCouponController.h"
#import "AllCouponViewController.h"
#import "UIButton+CreateButton.h"
#import "CustomerServiceController.h"
#import "SupermarketMyCollectionViewController.h"
#import "ZFScanViewController.h"
#import "Masonry.h"

#import "TinyShopDetailedView.h"
#import "TSShopDetailedCollectionView.h"

//#pragma mark -- 人生
#import "SuperMarketAddView.h"
#import "RSSpecialGoodsMedicineView.h"
#import "RSOtcCollectionView.h"
#import <SwiftLocation/SwiftLocation-Swift.h>

@interface SupermarketHomeViewController ()<PYSearchViewControllerDelegate,ClassificationViewDelegate, HNScanViewControllerDelegate,SupermarketHomeAdviewDelegate,ZHScrollHeaderTaped,DetailedDelegate>

@property(nonatomic, strong) UIScrollView *mainScrollView;
@property(nonatomic, strong) SuperMarketAddView *RsSingleAdview;
@property(nonatomic, strong) RSSpecialGoodsMedicineView *specialGoodsMedicineView;
@property(nonatomic, retain) RSOtcCollectionView *OtcCollectionView;

@property(nonatomic, strong) SupermarketHomePanicBuyingCollectionView *panicBuyCollectionView;
@property(nonatomic, strong) SupermarketHomeTasteNewCollectionView *tasteNewCollectionView;
@property(nonatomic, strong) SupermarketHomeWantBuyCollectionView *wantBuyCollectionView;
@property(nonatomic, strong) SupermarketHomeAdview *adView;
@property(nonatomic, strong) UIRefreshControl *refresh;

@property(nonatomic, assign) BOOL islogIn;//是否为登录状态

@property(nonatomic, assign) BOOL isRefresh;

@property(nonatomic, strong) CountTimeView *countTimeView;//倒计时


@property (nonatomic,retain)TinyShopDetailedView *tinyShopDetailView;

@property(nonatomic,retain)TSShopDetailedCollectionView *tsDetailedView;

@property (nonatomic,retain)UIView  *mallInfoView;


@property (nonatomic,retain)NSDictionary *responseDic;

@property (nonatomic,retain)UIButton *loveBtn;
@end

@implementation SupermarketHomeViewController {
    ZHSCorllHeader *banner;
    
    SupermarketHomeTasteFreshBannerData *_tasteFreshBannerData;
    
    UILabel *tasteNew;
    
    NSMutableArray *_bannerDataArray;
    
    NSMutableArray *_adViewArray;//三个广告
    NSMutableArray *_mostFreshArray;//新品尝鲜
    NSMutableArray *_purchaseArray;
    NSMutableArray *_peopleLikeArray;//大家都爱买
    NSMutableArray *_tasteFreshArray;
    
    UIImageView *recommendNewPic;
    
    UIImageView *otcImgview;//大家都喜欢买标题
    
    NSString *peopleLikeBuyTitle;//解析数据后大家都喜欢买标题
    NSString *peopleLikeBuyAdId;//大家都喜欢买id;
    
    UIButton *locationName;
    SupermarketClassfictionView *classfictionView;
	
	UIButton *callPhoneBtn;
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOk:) name:@"YCAccountIsLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseDivCode:) name:@"ChooseDivCode" object:nil];
    _isRefresh = NO;
    
    _islogIn = [YCAccountModel islogin];
    
    [self initNavigation];
    
    [self initView];
    
//    [self requestData];
	[self requesTinyShopDetailData];
    
    [self locationCityName];
}
//进入页面开始定位当前所在的城市
- (void)locationCityName{
        
    
}
- (void)goDetail:(NSNotification *)notification {
    NSString *itemCode = notification.object;
    GoodsDetailController *detail = [[GoodsDetailController alloc]init];
    detail.item_code = itemCode;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)loginOk:(NSNotification *)notification {
    _islogIn = YES;
}

- (void)chooseDivCode:(NSNotification *)notification {
    NSArray *arr = notification.object;
    NSLog(@"%@",arr);
    self.divCode = arr.firstObject;
    self.divName = arr.lastObject;
    
    [locationName setTitle:self.divName forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.divCode forKey:DivCodeDefault];
}

- (void)initNavigation {
	
	self.loveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 16, 6)];
	
	[self.loveBtn setImage:[UIImage imageNamed:@"icon-_collection_s"] forState:UIControlStateSelected];
	[self.loveBtn setImage:[UIImage imageNamed:@"icon-_collection_n"] forState:UIControlStateNormal];
	[self.loveBtn addTarget:self action:@selector(LoveAction:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *loveitem = [[UIBarButtonItem alloc]initWithCustomView:self.loveBtn];
//		self.navigationItem.rightBarButtonItem = loveitem;
	
    UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dismis)];
    dismiss.tintColor = [UIColor darkcolor];
	
    locationName = [UIButton createButtonWithFrame:CGRectMake(0, 0, 60, 20) title:self.divName titleColor:[UIColor darkcolor] titleFont:[UIFont systemFontOfSize:12] backgroundColor:[UIColor clearColor]];
    locationName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [locationName addTarget:self action:@selector(goLocation) forControlEvents:UIControlEventTouchUpInside];
    UIButton *titlebtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    
    [titlebtn setTitle:_dic[@"custom_name"] forState:UIControlStateNormal];
    [titlebtn setTitleColor:RGB(16, 16, 16) forState:UIControlStateNormal];
	
	self.navigationItem.titleView = titlebtn;
    
    UIBarButtonItem *locationNameItem = [[UIBarButtonItem alloc] initWithCustomView:locationName];
    locationNameItem.tintColor = [UIColor darkcolor];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:self action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.leftBarButtonItems = @[dismiss];
    
}



- (void)initView {
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height - 114)];
    _mainScrollView.contentSize = CGSizeMake(APPScreenWidth, APPScreenHeight*5);
    _mainScrollView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self.view addSubview:_mainScrollView];
    
    banner = [[ZHSCorllHeader alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenWidth/2)];
    banner.delegate = self;
    [_mainScrollView addSubview:banner];
	
	//创建头部图片显示
	if (self.tinyShopDetailView == nil) {
		self.tinyShopDetailView = [[TinyShopDetailedView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(banner.frame), SCREEN_WIDTH, 120)];
		self.tinyShopDetailView.delegete = self;
		self.tinyShopDetailView.dic = self.dic;
		self.tinyShopDetailView.hidden = YES;
		[_mainScrollView addSubview:self.tinyShopDetailView];
	}

	if (self.tsDetailedView == nil) {
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.scrollDirection = UICollectionViewScrollDirectionVertical;
		
		self.tsDetailedView = [[TSShopDetailedCollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tinyShopDetailView.frame), SCREEN_WIDTH, 0) collectionViewLayout:layout];
		self.tsDetailedView.showsVerticalScrollIndicator = NO;
		self.tsDetailedView.scrollEnabled = NO;
		self.tsDetailedView.shopDic = self.dic;
		[self.view addSubview:self.tsDetailedView];
		[_mainScrollView addSubview:self.tsDetailedView];
		_mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.tsDetailedView.frame));
		
	}
	
	//添加打电话的按钮
	if (callPhoneBtn == nil) {
		
		callPhoneBtn = [[UIButton alloc]initWithFrame:CGRectZero];
		[callPhoneBtn setBackgroundColor:RGB(0,128, 48)];
		[callPhoneBtn addTarget:self action:@selector(callPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
		[callPhoneBtn setImage:[UIImage imageNamed:@"icon_call_order"] forState:UIControlStateNormal];
		[self.view addSubview:callPhoneBtn];
		[callPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.trailing.bottom.equalTo(self.view);
			make.height.equalTo(@50);
		}];
		[_mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.view).with.offset(0);
			make.top.equalTo(self.view).with.offset(0);
			make.right.equalTo(self.view).with.offset(0);
			make.bottom.equalTo(callPhoneBtn.mas_top);
		}];

	}
}

- (void)requesTinyShopDetailData{
	YCAccountModel *accountmodel = [YCAccountModel getAccount];
	NSString *latitude = [[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"];
	NSString *longitude = [[NSUserDefaults standardUserDefaults]objectForKey:@"longtitude"];
	
	[KLHttpTool TinyRequestStoreItemDetailwithsaleCustomCode:self.dic[@"custom_code"] withLatitude:latitude withLongitude:longitude withCustomCode:accountmodel.customCode withPagesize:@"10" withPg:@"1" success:^(id response) {
		self.responseDic =  (NSDictionary *)response;

		if ([self.responseDic[@"status"] intValue] == 1) {
			self.tinyShopDetailView.hidden = NO;
			NSArray *storeItem = self.responseDic[@"Storeitems"];
			self.tsDetailedView.dataArray = storeItem;
			[self.tsDetailedView reloadData];
			
			self.mainScrollView.contentSize = CGSizeMake(APPScreenWidth,CGRectGetMaxY(self.tsDetailedView.frame));
			
			if ([self.responseDic[@"favorites"] isEqualToString:@"False"]) {
				self.loveBtn.selected = NO;
			}else{
				self.loveBtn.selected = YES;
			}
			
			_bannerDataArray = @[].mutableCopy;
			[_bannerDataArray addObject:self.responseDic[@"shop_thumnail_image"]];
			banner.urlImagesArray = _bannerDataArray;

		}
		
	} failure:^(NSError *err) {
		
	}];
}

- (void)requestData {
    if (!_isRefresh) {
        [MBProgressHUD showWithView:self.view];
    }
    NSString *div;
//  NSString *divCode = [[NSUserDefaults standardUserDefaults] objectForKey:DivCodeDefault];
	
	NSString *divCode = @"2";
    if (divCode.length > 0) {
        div = divCode;
    }
    
    [KLHttpTool getSupermarketHomaDataWithUrl:nil divCode:div success:^(id response) {
        NSLog(@"%@",response);
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        NSNumber *status = response[@"status"];
        //成功
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            
            [classfictionView reloadWithVersion:self.version state:self.state];
            
            if (_bannerDataArray == nil) {
                _bannerDataArray = @[].mutableCopy;
            } else {
                [_bannerDataArray removeAllObjects];
            }
            
            NSArray *banners = data[@"bannerAD"];
            
            if (banners.count > 0) {
                for (NSDictionary *dic in banners) {
                    SupermarketHomeBannerData *data = [NSDictionary getSupermarketBannerWithDic:dic];
                    [_bannerDataArray addObject:data];
                }
            }
            
            if (_adViewArray == nil) {
                _adViewArray = @[].mutableCopy;
            } else {
                [_adViewArray removeAllObjects];
            }
            
            NSArray *eventAD = data[@"eventAD"];
            if (eventAD.count > 0) {
                for (NSDictionary *dic in eventAD) {
                    SupermarketHomeADVData *data = [NSDictionary getSupermarketHomeADDataWithDic:dic];
                    [_adViewArray addObject:data];
                }
            }
            
            if (_mostFreshArray == nil) {
                _mostFreshArray = @[].mutableCopy;
            } else {
                [_mostFreshArray removeAllObjects];
            }
            NSDictionary *newAD = data[@"newAD"];
            _tasteFreshBannerData = [[SupermarketHomeTasteFreshBannerData alloc] init];
            _tasteFreshBannerData.ad_id = newAD[@"ad_id"];
            _tasteFreshBannerData.title = newAD[@"title"];
            _tasteFreshBannerData.ad_image = newAD[@"ad_image"];
            _tasteFreshBannerData.link_url = newAD[@"link_url"];
            _tasteFreshBannerData.ver = newAD[@"ver"];
            
            NSArray *list = newAD[@"list"];
            if (list.count > 0) {
                for (NSDictionary *dic in list) {
                    SupermarketHomeMostFreshData *data = [NSDictionary getSupermarketHomeMostFreshDataWithDic:dic];
                    [_mostFreshArray addObject:data];
                }
            }
            NSDictionary *likeAD = data[@"likeAD"];
            peopleLikeBuyTitle = likeAD[@"title"];
            peopleLikeBuyAdId = likeAD[@"ad_id"];
            NSArray *likeList = likeAD[@"list"];
            
            if (_peopleLikeArray == nil) {
                _peopleLikeArray = @[].mutableCopy;
            } else {
                [_peopleLikeArray removeAllObjects];
            }
            
            if (likeList.count > 0) {
                for (NSDictionary *dic in likeList) {
                    SupermarketHomePeopleLikeData *data = [NSDictionary getSupermarketHomePeopleLikeDataWithDic:dic];
                    [_peopleLikeArray addObject:data];
                }
            }
            
            
            [self reloadUI];
            
            [_refresh endRefreshing];
        } else if (status.integerValue < 0) {
            [MBProgressHUD hideAfterDelayWithView:self.view interval:2 text:response[@"message"]];
        }
    } failure:^(NSError *err) {
        [_mainScrollView removeFromSuperview];
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"没有数据"];
        
    }];
}

- (void)reloadUI {
 
    if (_bannerDataArray.count > 0) {
        banner.imageDataArray = _bannerDataArray;
    }

    tasteNew.text = _tasteFreshBannerData.title;
    NSMutableArray *testData = @[].mutableCopy;
    NSMutableArray *otcData = @[].mutableCopy;
    for (int i =0 ;i<_peopleLikeArray.count;i++) {
        id model = _peopleLikeArray[i];
        if (i<10) {
            
            [testData addObject:model];
        }else{
            [otcData addObject:model];
        }
    }
//    _tasteNewCollectionView.dataArray = testData;
	
//	self.tsDetailedView.dataArray = testData;
    if (testData.count > 0) {
     
        self.tsDetailedView.dataArray = testData;
		int colum =  (testData.count/2.0f - (int)(testData.count/2.0f) )>0?(int)(testData.count/2.0f)+1:(int)(testData.count/2.0f);
		CGRect frames = self.tsDetailedView.frame;
        frames.size.height = colum *(SCREEN_WIDTH/2 - 5);
        _tsDetailedView.frame = frames;
        CGSize size = _mainScrollView.contentSize;
        size.height = CGRectGetMaxY(_tsDetailedView.frame);
        _mainScrollView.contentSize = size;
        
    }
}

- (void)setDivName:(NSString *)divName {
    _divName = divName;
    [locationName setTitle:divName forState:UIControlStateNormal];
}


#pragma mark - 刷新数据
- (void)refreshData:(UIRefreshControl *)refreshControl {
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"SMHomeRefreshing", nil)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [NSThread sleepForTimeInterval:3];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            NSString *lastUpdate = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"SMHomeLastRefresh", nil),[formatter stringFromDate:[NSDate date]]];
            
            refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
            
            NSLog(@"refresh end");
            _isRefresh = YES;
			[self requesTinyShopDetailData];
//            [self requestData];
        });
    });
    
}

- (void)goTasteNew:(UIGestureRecognizer *)tap {
    SupermarketTasteNewController *tasteNewVC = [[SupermarketTasteNewController alloc] init];
    tasteNewVC.hidesBottomBarWhenPushed = YES;
    tasteNewVC.divCode = self.divCode;
    tasteNewVC.actionID = _tasteFreshBannerData.ad_id;
    [self.navigationController pushViewController:tasteNewVC animated:YES];
}

- (void)goLimitBuy:(UITapGestureRecognizer *)tap {
    SupermarketLimitBuyController *limitBuy = [[SupermarketLimitBuyController alloc] init];
    limitBuy.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:limitBuy animated:YES];
}

#pragma mark - Search

- (void)searchAction {
    // 1.创建热门搜索
    //    NSArray *hotSeaches = @[@"外套男 青少年", @"外套男冬装", @"pro衫", @"运动套装", @"牛仔衣", @"秋冬季卫衣", @"海澜之家", @"李宁"];
    // 2. 创建控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:NSLocalizedString(@"SMHomeSearchPlaceHolder", nil) didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // 开始搜索执行以下代码
        // 如：跳转到指定控制器
        SupermarketSearchResultViewController *result = [[SupermarketSearchResultViewController alloc] init];
        result.searchKeyWord = searchText;
        
        [searchViewController.navigationController pushViewController:result animated:YES];
        //        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[SupermarketSearchResultViewController alloc] init]];
        //        [searchViewController presentViewController:nav animated:NO completion:nil];
    }];
    searchViewController.searchType = PYSearchTypeSupermarket;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    searchViewController.hidesBottomBarWhenPushed = YES;
    // 4. 设置代理
    searchViewController.delegate = self;
    // 5. 跳转到搜索控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}

- (void)clickAtIndex:(NSInteger)index {
    if (index == 0 || index == 1 || index == 3 || index == 4 || index == 5) {
        if (_islogIn == NO) {
            MemberEnrollController *loginVC = [[MemberEnrollController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:nav animated:YES completion:nil];
            return;
        }
    }
    
    //jake - 170708
    
    if (index == 0) {
        SupermarketMyOrderController *myOrder = [SupermarketMyOrderController new];
        myOrder.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myOrder animated:YES];
    } else if (index == 1) {
        
        SupermarketMyAddressViewController *collection = [[SupermarketMyAddressViewController alloc] init];
        collection.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collection animated:YES];
    } else if (index == 2){//钱包

        BOOL isLogIn = [YCAccountModel islogin];
        if (isLogIn) {
           
            YCAccountModel *model = [YCAccountModel getAccount];
            NSString *appurl = [NSString stringWithFormat:@"ycapp://wallet$%@$$%@",model.customId,model.token];
            appurl = [appurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appurl]]) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:appurl]];
           
            }else{
                
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps:https://itunes.apple.com/us/app/%E9%BE%99%E8%81%8A/id1225896079?l=zh&ls=1&mt=8"]];
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"龙聊暂未安装,是否前往AppStroe下载?" preferredStyle:UIAlertControllerStyleAlert];
                    [alerVC addAction:cancel];
                    [alerVC addAction:sure];
                    [self presentViewController:alerVC animated:YES completion:nil];
            }
            
        }else{
            MemberEnrollController *logInController = [[MemberEnrollController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logInController];
            [self presentViewController:nav animated:YES completion:nil];
            
        }
       

        
        
    }
    else if (index == 3) {//在线客服
        
        RSCustomerService *vc = [[RSCustomerService alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }  else if (index == 4) {
        SupermarketMyAddressViewController *address = [[SupermarketMyAddressViewController alloc] init];
        address.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:address animated:YES];
        
    } else if (index == 5) {
        CustomerServiceController *vc = [[CustomerServiceController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (index == 7) {
        
    }else if (index == 6) {
        
    }
}

- (void)goDownload {
    //    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps:https://itunes.apple.com/us/app/%E9%BE%99%E8%81%8A/id1225896079?l=zh&ls=1&mt=8"]];
    //    }];
    //    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    //    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"龙聊暂未安装,是否前往AppStroe下载?" preferredStyle:UIAlertControllerStyleAlert];
    //    [alerVC addAction:cancel];
    //    [alerVC addAction:sure];
    //    [self presentViewController:alerVC animated:YES completion:nil];
}

- (void)dismis {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goLocation {
    OrderLocationController *locations = [[OrderLocationController alloc] init];
    locations.locationSuccessClosure = ^(NSString *locationCity ){
        [locationName setTitle:locationCity forState:UIControlStateNormal];
    };
    locations.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:locations animated:YES];
}

- (void)clickAdViewIndex:(NSInteger)index {
    if (index == 0) {
        SupermarketMostFreshController *mostFresh = [SupermarketMostFreshController new];
        mostFresh.hidesBottomBarWhenPushed = YES;
        SupermarketHomeADVData *data = _adViewArray[0];
        mostFresh.actionID = data.ad_id;
        mostFresh.divCode = self.divCode;
        [self.navigationController pushViewController:mostFresh animated:YES];
    }
    if (index == 1) {
        SupermarketPopularFreshController *popularFresh = [[SupermarketPopularFreshController alloc] init];
        popularFresh.hidesBottomBarWhenPushed = YES;
        SupermarketHomeADVData *data = _adViewArray[1];
        popularFresh.actionID = data.ad_id;
        popularFresh.divCode = self.divCode;
        [self.navigationController pushViewController:popularFresh animated:YES];
    }
    if (index == 2) {
        SupermarketOnSaleController *onSale = [[SupermarketOnSaleController alloc] init];
        SupermarketHomeADVData *data = _adViewArray[2];
        onSale.actionID = data.ad_id;
        onSale.actionTitle = data.ad_title;
        onSale.divCode = self.divCode;
        onSale.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:onSale animated:YES];
    }
}

- (void)scanViewController:(HNScanViewController *)scanViewController didScanResult:(NSString *)result {
    NSLog(@"%@",result);
    //    [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2.0 text:result];
    GoodsDetailController *goodDetail = [[GoodsDetailController alloc] init];
    goodDetail.item_code = result;
    goodDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodDetail animated:YES];
}

- (void)scrollHeaderTapAtIndex:(NSInteger)index {
    SupermarketHomeBannerData *data = _bannerDataArray[index];
    
    GoodsDetailController *vc = [GoodsDetailController new];
    vc.item_code = data.item_code;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---  DetailedDelegate
- (void)clickSegment:(int)index{
	if (index == 0) {
		self.tsDetailedView.hidden = NO;
		self.mallInfoView.hidden = YES;
		self.mainScrollView.contentSize = CGSizeMake(APPScreenWidth, CGRectGetMaxY(self.tsDetailedView.frame)+50);
		
	}else{
		
		self.tsDetailedView.hidden = YES;
		if (self.mallInfoView == nil) {
			[self createShopInfomations];

		}else{
			self.mainScrollView.hidden = NO;
		}
	}
	
}

- (void)createShopInfomations{
	
	if (self.mallInfoView == nil) {
		self.mallInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tinyShopDetailView.frame), APPScreenWidth, APPScreenHeight - CGRectGetMaxY(self.tinyShopDetailView.frame))];
		self.mallInfoView.backgroundColor = [UIColor whiteColor];
		[self.mainScrollView addSubview:self.mallInfoView];
		self.mainScrollView.contentSize = CGSizeMake(APPScreenWidth, CGRectGetMaxY(self.mallInfoView.frame));
		
		

	}
}

- (void)callPhoneBtn:(UIButton*)sender{
	NSURL *url = [NSURL URLWithString:@"telprompt://13142252288"];
	[[UIApplication sharedApplication] openURL:url];
}

- (void)LoveAction:(UIButton*)sender{
	sender.selected = !sender.selected;
	
}
@end

