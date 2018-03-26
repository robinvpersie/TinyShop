//
//  SupermarketGoodsViewController.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/8.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketGoodsViewController.h"
#import "ZHSCorllHeader.h"
#import "SupermarketGoodsMessageView.h"
#import "SupermarketCheckView.h"
#import "SupermarketChangeBuyView.h"
#import "SupermarketConfirmOrderController.h"
#import "SupermarketGoodsModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "LZCartViewController.h"
#import "SupermarketChoseSizeView.h"
#import "GoodsOptionModel.h"
#import "CustomerServiceController.h"

#define kButtonWidth APPScreenWidth/5*2/3

@interface SupermarketGoodsViewController ()<ChoseSizeViewDelegate>

@property(nonatomic, strong) UIScrollView *mainScrollView;
@property(nonatomic, strong) ZHSCorllHeader *banner;
@property(nonatomic, strong) SupermarketGoodsMessageView *msgView;
@property(nonatomic, strong) SupermarketCheckView *checkView;
@property(nonatomic, strong) UIButton *collectionTitleButton;
@property(nonatomic, strong) UIButton *collectionButton;
@property(nonatomic, strong) SupermarketChoseSizeView *choseSizeView;
@property(nonatomic, strong) UIButton *buy;
@property(nonatomic, strong) UIButton *addToShoppingCart;
@property(nonatomic, strong) NSMutableArray *singleChooseArr;
@property(nonatomic, strong) NSMutableArray *mutiChoseArr;

@property(nonatomic, assign) NSInteger actionType;//0代表立即购买 1代表添加购物车

@end

@implementation SupermarketGoodsViewController {
	NSArray *_bottomImageNames;
	NSArray *_bottomSelectedImageNames;
	NSArray *_bottomTitles;
	
	SupermarketGoodsModel *goods;
	
	UILabel *store;
	UILabel *number;
	
	SupermarketChangeBuyView *changeView;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	_bottom.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	_bottom.hidden = NO;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_singleChooseArr = @[].mutableCopy;
	_mutiChoseArr = @[].mutableCopy;
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	_bottomImageNames = @[@"icon_customerservice_n",@"icon-_collection_n",@"icon-_shoppingcart_n"];
	_bottomSelectedImageNames = @[@"icon_customerservice_s",@"icon-_collection_s",@"icon-_shoppingcart_s"];
	_bottomTitles = @[NSLocalizedString(@"SMGoodsDetailService", nil),NSLocalizedString(@"SMGoodsDetailCollection", nil),NSLocalizedString(@"SupermarketTabShoppingCart", nil)];
	
	[self initView];
	
	[self initBottomView];
	
	[self requestData];
	// Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	_bottom.hidden = NO;
}

- (void)initView {
	_mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight)];
	_mainScrollView.contentSize = CGSizeMake(APPScreenWidth, APPScreenHeight*1.5);
	_mainScrollView.backgroundColor = RGB(242, 242, 242);
	[self.view addSubview:_mainScrollView];
	
	_banner = [[ZHSCorllHeader alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenWidth-50)];
	
	[_mainScrollView addSubview:_banner];
	
	UIImageView *shawdow = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_banner.frame), APPScreenWidth, 4)];
	shawdow.contentMode = UIViewContentModeScaleToFill;
	shawdow.backgroundColor = [UIColor whiteColor];
	shawdow.image = [UIImage imageNamed:@"img_banner_shadow"];
	[_mainScrollView addSubview:shawdow];
	
	_msgView = [[SupermarketGoodsMessageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(shawdow.frame), APPScreenWidth, 120)];
	_msgView.backgroundColor = [UIColor whiteColor];
	[_mainScrollView addSubview:_msgView];
	
	_checkView = [[SupermarketCheckView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_msgView.frame), APPScreenWidth, 30)];
	[_mainScrollView addSubview:_checkView];
	
	changeView = [[SupermarketChangeBuyView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_checkView.frame)+15, APPScreenWidth, 40)];
	changeView.backgroundColor = [UIColor whiteColor];
	[_mainScrollView addSubview:changeView];
	
	store = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(changeView.frame)+5, 100, 20)];
	store.textColor = RGB(153, 153, 153);
	store.font = [UIFont systemFontOfSize:12];
	[_mainScrollView addSubview:store];
	
	number = [[UILabel alloc] initWithFrame:CGRectMake(APPScreenWidth/2, store.frame.origin.y, 250, store.frame.size.height)];
	number.textColor = RGB(153, 153, 153);
	number.font = [UIFont systemFontOfSize:12];
	[_mainScrollView addSubview:number];
	
	CGSize size = _mainScrollView.contentSize;
	size.height = CGRectGetMaxY(number.frame)+120;
	_mainScrollView.contentSize = size;
	
	if (_choseSizeView == nil) {
		_choseSizeView = [[SupermarketChoseSizeView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight)];
		_choseSizeView.delegate = self;
	}
	
}


/**
 底部加入购物车 收藏 立即购买 等
 */
- (void)initBottomView {
	UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
	_bottom = [[UIView alloc] initWithFrame:CGRectMake(0, APPScreenHeight-50, APPScreenWidth, 50)];
	_bottom.backgroundColor = [UIColor whiteColor];
	[keyWindow addSubview:_bottom];
	
	UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 1)];
	line.backgroundColor = RGB(235, 235, 235);
	[_bottom addSubview:line];
	
	UIButton *buy = [UIButton buttonWithType:UIButtonTypeCustom];
	buy.frame = CGRectMake(APPScreenWidth - APPScreenWidth/5*3/2, 5, APPScreenWidth/5*3/2 - 6, _bottom.frame.size.height-1 - 8);
	buy.backgroundColor = RGB(33, 192, 67);
	[buy setTitle:NSLocalizedString(@"SMGoodsClickToBuy", nil) forState:UIControlStateNormal];
	buy.layer.cornerRadius = 2.0f;
	[buy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[buy addTarget: self action:@selector(clickBuy) forControlEvents:UIControlEventTouchUpInside];
	buy.titleLabel.font = [UIFont systemFontOfSize:14];
	[_bottom addSubview:buy];
	self.buy = buy;
	
	UIButton *addShoppingCart = [UIButton buttonWithType:UIButtonTypeCustom];
	addShoppingCart.frame = CGRectMake(CGRectGetMinX(buy.frame) - APPScreenWidth/5*3/2, 5, APPScreenWidth/5*3/2-6, _bottom.frame.size.height-1 - 8);
	[addShoppingCart setTitle:NSLocalizedString(@"SMGoodsAddToCarts", nil) forState:UIControlStateNormal];
	addShoppingCart.layer.cornerRadius = 2.0f;
	[addShoppingCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	addShoppingCart.backgroundColor = RGB(225, 198, 0);
	[addShoppingCart addTarget:self action:@selector(addShoppingCart) forControlEvents:UIControlEventTouchUpInside];
	addShoppingCart.titleLabel.font = [UIFont systemFontOfSize:14];
	self.addToShoppingCart = addShoppingCart;
	[_bottom addSubview:addShoppingCart];
	
	for (int i = 0; i < 3; i++) {
		UIView *view = [self bottomButton:_bottomTitles[i] andimageName:_bottomImageNames[i] selectedImage:_bottomSelectedImageNames[i] index:i];
		[_bottom addSubview:view];
	}
}

- (UIView *)bottomButton:(NSString *)title andimageName:(NSString *)imageName selectedImage:(NSString *)selectImage index:(NSInteger)index {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(index * kButtonWidth , 1, kButtonWidth, _bottom.frame.size.height - 1)];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	[button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
	
	button.frame = CGRectMake(kButtonWidth/2-10, view.frame.size.height/2-15, 20, 20);
	if (selectImage != nil) {
		[button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
	}
	[view addSubview:button];
	
	UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
	titleButton.frame = CGRectMake(button.frame.origin.x - 5, CGRectGetMaxY(button.frame), button.frame.size.width + 10, 15);
	titleButton.titleLabel.font = [UIFont systemFontOfSize:8];
	[titleButton setTitle:title forState:UIControlStateNormal];
	[titleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	[view addSubview:titleButton];
	
	if (index == 1) {
		[titleButton setTitle:NSLocalizedString(@"SMGoodsCollectioned", nil) forState:UIControlStateSelected];
		[titleButton setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
		_collectionButton = button;
		_collectionTitleButton = titleButton;
	}
	
	switch (index) {
		case 0:
			[button addTarget:self action:@selector(goSever) forControlEvents:UIControlEventTouchUpInside];
			[titleButton addTarget:self action:@selector(goSever) forControlEvents:UIControlEventTouchUpInside];
			break;
		case 1:
			[button addTarget:self action:@selector(collectionGoods:) forControlEvents:UIControlEventTouchUpInside];
			[titleButton addTarget:self action:@selector(collectionGoods:) forControlEvents:UIControlEventTouchUpInside];
			break;
			
		case 2:
			[button addTarget:self action:@selector(goShoppingCart) forControlEvents:UIControlEventTouchUpInside];
			[titleButton addTarget:self action:@selector(goShoppingCart) forControlEvents:UIControlEventTouchUpInside];
			break;
		default:
			break;
	}
	
	return view;
}

- (void)requestData {
	
	[MBProgressHUD showWithView:self.view];
	
	if (self.item_code == nil) {
		self.item_code = @"6901285991271";
	}
	
	[KLHttpTool getSupermarketGoodsMsgWithItemCode:self.item_code shopCode:@"2" saleCustomCode:self.divCode success:^(id response) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		NSNumber *status = response[@"status"];
		if (status.integerValue == 1) {
			goods = [NSDictionary getGoodsMsgDataWithDic:response[@"data"]];
			
			NSDictionary *data = response[@"data"];
			NSArray *attachOptionList = data[@"attachOptionList"];
			if (attachOptionList.count > 0) {
				for (NSDictionary *option in attachOptionList) {
					GoodsOptionModel *optionModel = [NSDictionary getGoodsOptionModelWithDic:option];
					[_mutiChoseArr addObject:optionModel];
				}
			}
			NSArray *justOptionList = data[@"justOptionList"];
			if (justOptionList.count > 0) {
				for (NSDictionary *option in justOptionList) {
					GoodsOptionModel *optionModel = [NSDictionary getGoodsOptionModelWithDic:option];
					[_singleChooseArr addObject:optionModel];
				}
			}
			[self reloaUI];
		} else {
			NSString *msg = response[@"message"];
			
			MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
			hud.label.text = msg;
			
			// 再设置模式
			hud.mode = MBProgressHUDModeCustomView;
			
			// 隐藏时候从父控件中移除
			hud.removeFromSuperViewOnHide = YES;
			
			// 1秒之后再消失
			[hud hideAnimated:YES afterDelay:1.5];
			
			[self performSelector:@selector(popController) withObject:nil afterDelay:1.5];
			
		}
		
	} failure:^(NSError *err) {
		
	}];
}

- (void)reloaUI {
	NSMutableArray *imageArray = @[].mutableCopy;
	for (NSDictionary *dic in goods.images) {
		[imageArray addObject:dic[@"url"]];
	}
	_banner.urlImagesArray = imageArray;
	
	if (goods.hasCollection.integerValue == 1) {
		_collectionButton.selected = YES;
		_collectionTitleButton.selected = YES;
	}
	
	if (goods.hasChangeBuy.integerValue == 1) {
		changeView.changeBuyTitle = goods.changeBuyTitle;
	} else {
		
		CGRect changeViewFrame = changeView.frame;
		changeViewFrame.size.height = 0;
		changeView.frame = changeViewFrame;
		changeView.hidden = YES;
		
		[self resetFrame];
	}
	
	_msgView.goodsModel = goods;
	
	_checkView.msgArray = goods.features;
	
	store.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"SMGoodsStockWay", nil),goods.storage];
	number.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"SMGoodsGoodsCode", nil),goods.itemCode];
	
	if (goods.stock.integerValue == 0) {
		self.buy.backgroundColor = [UIColor lightGrayColor];
		[self.buy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		self.buy.userInteractionEnabled = NO;
		
		self.addToShoppingCart.backgroundColor = [UIColor lightGrayColor];
		[self.addToShoppingCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		self.addToShoppingCart.userInteractionEnabled = NO;
	}
	
	if ([goods.linkUrl isEqual:[NSNull null]]) {
		return;
	}
	
	if (goods.linkUrl.length > 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"GoodsDetailUrl" object:goods.linkUrl];
	}
}

- (void)popController {
	_bottom.hidden = YES;
	[_bottom removeFromSuperview];
	_bottom = nil;
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)resetFrame {
	store.frame = CGRectMake(15, CGRectGetMaxY(changeView.frame)+5, 100, 20);
	number.frame = CGRectMake(APPScreenWidth/2, store.frame.origin.y, 250, store.frame.size.height);
	
	CGSize size = _mainScrollView.contentSize;
	size.height = CGRectGetMaxY(number.frame)+120;
	_mainScrollView.contentSize = size;
}

#pragma mark - 底部按钮事件

- (void)clickBuy {
	NSLog(@"单选:%@",_singleChooseArr);
	NSLog(@"多选%@",_mutiChoseArr);
	[_choseSizeView showInView:KEYWINDOW];
	[UIImageView setimageWithImageView:_choseSizeView.iconImgView UrlString:goods.images.firstObject[@"url"] imageVersion:nil];
	_choseSizeView.goodsPriceLabel.text = [NSString stringWithFormat:@"￥ %@",goods.price];
	_choseSizeView.goodsStockLabel.text = [NSString stringWithFormat:@"库存 %@%@",goods.stock,goods.unit];
	_choseSizeView.dataSource = @[_singleChooseArr,_mutiChoseArr];
	self.actionType = 0;
	
}

- (void)addShoppingCart {
	[_choseSizeView showInView:KEYWINDOW];
	[UIImageView setimageWithImageView:_choseSizeView.iconImgView UrlString:goods.images.firstObject[@"url"] imageVersion:nil];
	_choseSizeView.goodsPriceLabel.text = [NSString stringWithFormat:@"￥ %@",goods.price];
	_choseSizeView.goodsStockLabel.text = [NSString stringWithFormat:@"%@ %@%@",NSLocalizedString(@"SMGoodsStocks", nil),goods.stock,goods.unit];
	_choseSizeView.dataSource = @[_singleChooseArr,_mutiChoseArr];
	self.actionType = 1;
}

- (void)goSever {
	
	RSCustomerService *vc = [[RSCustomerService alloc] init];
	UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
	[self presentViewController:navi animated:YES completion:nil];
	_bottom.hidden = YES;
}

- (void)collectionGoods:(UIButton *)button {
	
	//    [KLHttpTool getToken:^(id token) {
	//        if (token) {
	button.selected = !button.selected;
	if (button == self.collectionTitleButton) {
		self.collectionButton.selected = button.selected;
		
		if (button.selected == YES) {
			[KLHttpTool addGoodsToMyCollection:goods.itemCode divCode:goods.business_code success:^(id response) {
				NSNumber *status = response[@"status"];
				if (status.integerValue == 1) {
					[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
				}
			} failure:^(NSError *err) {
				
			}];
		} else {
			[KLHttpTool addGoodsToMyCollection:goods.itemCode divCode:goods.business_code success:^(id response) {
				NSNumber *status = response[@"status"];
				if (status.integerValue == 1) {
					[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
				}
				
			} failure:^(NSError *err) {
				
			}];
		}
		
	} else {
		self.collectionTitleButton.selected = button.selected;
		if (button.selected == YES) {
			[KLHttpTool addGoodsToMyCollection:goods.itemCode divCode:goods.business_code success:^(id response) {
				NSNumber *status = response[@"status"];
				if (status.integerValue == 1) {
					[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
				}
			} failure:^(NSError *err) {
				
			}];
		} else {
			[KLHttpTool addGoodsToMyCollection:goods.itemCode divCode:goods.business_code success:^(id response) {
				NSNumber *status = response[@"status"];
				if (status.integerValue == 1) {
					[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
				}
			} failure:^(NSError *err) {
				
			}];
		}
	}
	//        }
	//    } failure:^(NSError *errToken) {
	//
	//    }];
}

- (void)goShoppingCart {
	
	//    [KLHttpTool getToken:^(id token) {
	//        if (token) {
	LZCartViewController *shoppingCart = [[LZCartViewController alloc] init];
	//    shoppingCart.type = ShoppingCartController;
	shoppingCart.isPush = YES;
	shoppingCart.hidesBottomBarWhenPushed = YES;
	shoppingCart.controllerType = self.controllerType;
	_bottom.hidden = YES;
	[self.navigationController pushViewController:shoppingCart animated:YES];
	
	//        }
	//    } failure:^(NSError *errToken) {
	//
	//    }];
}


- (void)choseSizeViewSureButtonClicked:(NSArray *)choseTitles {
	
	NSString *singleTitle = choseTitles.firstObject;
	GoodsOptionModel *singleChosedOneModel;//单选被选中的那个
	for (GoodsOptionModel *option in _singleChooseArr) {
		NSString *title = option.item_name;
		if ([title isEqualToString:singleTitle]) {
			singleChosedOneModel = option;
		}
	}
	
	if (singleChosedOneModel == nil) {
		[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:NSLocalizedString(@"SMGoodsShowMsg", nil)];
		return;
	}
	
	if (self.choseSizeView.buyAmount == 0) {
		[MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:NSLocalizedString(@"SMGoodsNoZeroMsg", nil)];
		return;
	}
	
	NSMutableArray *mutiTitle = [NSMutableArray arrayWithArray:choseTitles];
	[mutiTitle removeObject:singleChosedOneModel.item_name];
	
	NSMutableArray *mutiChosedModelArr = @[].mutableCopy;
	if (mutiTitle.count > 0) {
		for (NSString *title in mutiTitle) {
			for (GoodsOptionModel *option in _mutiChoseArr) {
				if ([title isEqualToString:option.item_name]) {
					[mutiChosedModelArr addObject:option];
				}
			}
		}
	}
	
	[self.choseSizeView removeView];
	
	[KLHttpTool getToken:^(id token) {
		if (token) {
			if (self.actionType == 0) {
				SupermarketConfirmOrderController *confirmOrder = [[SupermarketConfirmOrderController alloc] init];
				confirmOrder.controllerType = self.controllerType;
				if (goods != nil) {
					
					if (goods.stock.integerValue == 0) {
						[MBProgressHUD hideAfterDelayWithView:self.view interval:2 text:@"库存为0"];
						return;
					}
					goods.itemCode = singleChosedOneModel.item_code;
					confirmOrder.goodsModel = goods;
					confirmOrder.amout = self.choseSizeView.buyAmount;
					confirmOrder.attachGoods = mutiChosedModelArr;
					[self.navigationController pushViewController:confirmOrder animated:YES];
					_bottom.hidden = YES;
				}
			} else if(self.actionType == 1){
				
				[KLHttpTool addGoodsToShoppingCartWithGoodsID:goods.itemCode shopID:goods.business_code applyID:goods.supplier_code numbers:_choseSizeView.buyAmount success:^(id response) {
					NSNumber *status = response[@"status"];
					if (status.integerValue == 1) {
						
						MBProgressHUD *hudsuccess = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
						hudsuccess.mode = MBProgressHUDModeText;
						hudsuccess.label.text = @"加入购物车成功!";
						[hudsuccess hideAnimated:YES afterDelay:1.0f];
						
						if (self.isScan) {
							UIAlertAction *continueBuy = [UIAlertAction actionWithTitle:@"继续购物" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
								
								ZFScanViewController * vc = [[ZFScanViewController alloc] init];
								vc.returnScanBarCodeValue = ^(NSString * barCodeString){
									
									NSLog(@"扫描结果的字符串======%@",barCodeString);
									GoodsDetailController *goodDetail = [[GoodsDetailController alloc] init];
									goodDetail.item_code = barCodeString;
									goodDetail.hidesBottomBarWhenPushed = YES;
									goodDetail.isScan = YES;
									[self.navigationController pushViewController:goodDetail animated:YES];
									
								};
								
								[self presentViewController:vc animated:YES completion:nil];
								
							}];
							UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"暂时不去" style:UIAlertActionStyleCancel handler:nil];
							UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加入购物车成功,是否回到扫描页面继续购物" preferredStyle:UIAlertControllerStyleAlert];
							[alert addAction:continueBuy];
							[alert addAction:cancel];
							[self presentViewController:alert animated:YES completion:nil];
						}
					}
					
				} failure:^(NSError *err) {
					
				}];
			}
		}
	} failure:^(NSError *errToken) {
		
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

