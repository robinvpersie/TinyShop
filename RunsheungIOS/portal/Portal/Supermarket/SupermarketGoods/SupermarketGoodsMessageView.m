//
//  SupermarketGoodsMessageView.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/8.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketGoodsMessageView.h"
#import "SupermarketGoodsModel.h"
#import "UILabel+WidthAndHeight.h"
#import "UILabel+WidthAndHeight.h"

@implementation SupermarketGoodsMessageView
{
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UILabel *_marketPriceLabel;
    UILabel *_stockAmountLabel;
    UILabel *_saleAmountLabel;
    UILabel *_additonalLabel;
    UILabel *_expressPriceLabel;//快递费
    UILabel *_location;
    UIButton *_addButton;
    UIButton *_cutButton;
    UIButton *_shareButton;
	UILabel *itemCodelabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width - 80, 40)];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor darkGrayColor];
    }
    [self addSubview:_titleLabel];
    
    if (_shareButton == nil) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(self.frame.size.width - 10 - 27, 10, 27, 27);
        [_shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
//    [self addSubview:_shareButton];
	
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_shareButton.frame) - 15, _shareButton.frame.origin.y, 1, _shareButton.frame.size.height)];
    line.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:line];
	
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame), 80, 35)];
        _priceLabel.textColor = RGB(246, 57, 55);
        _priceLabel.font = [UIFont systemFontOfSize:22];
    }
    [self addSubview:_priceLabel];
    
    if (_marketPriceLabel == nil) {
        _marketPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame), CGRectGetMaxY(_priceLabel.frame)-23, 120, 20)];
        _marketPriceLabel.textColor = [UIColor lightGrayColor];
        _marketPriceLabel.textColor = [UIColor lightGrayColor];
        _marketPriceLabel.font = [UIFont systemFontOfSize:12];
    }
    [self addSubview:_marketPriceLabel];
    
    if (_stockAmountLabel == nil) {
        _stockAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_priceLabel.frame), 100, 20)];
        _stockAmountLabel.textColor = [UIColor lightGrayColor];
        _stockAmountLabel.font = [UIFont systemFontOfSize:12];
    }
    [self addSubview:_stockAmountLabel];
    
    if (_expressPriceLabel == nil) {
        CGFloat width = [UILabel getWidthWithTitle:@"配送费:10元哈哈哈" font:[UIFont systemFontOfSize:12]];
        _expressPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_stockAmountLabel.frame), width, 20)];
        _expressPriceLabel.textColor = [UIColor lightGrayColor];
        _expressPriceLabel.font = [UIFont systemFontOfSize:12];
    }
    [self addSubview:_expressPriceLabel];
    
    if (_saleAmountLabel == nil) {
        _saleAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_expressPriceLabel.frame)+25, CGRectGetMaxY(_stockAmountLabel.frame), 100, 20)];
        _saleAmountLabel.textColor = [UIColor lightGrayColor];
        _saleAmountLabel.font = [UIFont systemFontOfSize:12];
    }
    [self addSubview:_saleAmountLabel];
    
    if (_location == nil) {
        _location = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 10 - 80, _saleAmountLabel.frame.origin.y, 80, 20)];
        _location.textAlignment = NSTextAlignmentRight;
        _location.textColor = [UIColor lightGrayColor];
        _location.font = [UIFont systemFontOfSize:12];
    }
//    [self addSubview:_location];
	
    if (_additonalLabel == nil) {
        _additonalLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_saleAmountLabel.frame)+5, 150, 20)];
        _additonalLabel.textColor = RGB(246, 57, 55);
        _additonalLabel.font = [UIFont systemFontOfSize:12];
    }
    [self addSubview:_additonalLabel];
    
    if (_addButton == nil) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(self.frame.size.width - 10 - 28, _additonalLabel.frame.origin.y, 28, 22);
        [_addButton setImage:[UIImage imageNamed:@"icon_+"] forState:UIControlStateNormal];
        _addButton.backgroundColor = RGB(227, 230, 230);
        [_addButton addTarget:self action:@selector(addAmount) forControlEvents:UIControlEventTouchUpInside];
    }
//    [self addSubview:_addButton];
    
    if (_buyAmountLabel == nil) {
        _buyAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_addButton.frame) - 4 - _addButton.frame.size.width, _addButton.frame.origin.y, _addButton.frame.size.width, _addButton.frame.size.height)];
        _buyAmountLabel.backgroundColor = RGB(227, 230, 230);
        _buyAmountLabel.textAlignment = NSTextAlignmentCenter;
        _buyAmountLabel.text = @"1";
    }
//    [self addSubview:_buyAmountLabel];
    
    if (_cutButton == nil) {
        _cutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cutButton.frame = CGRectMake(CGRectGetMinX(_buyAmountLabel.frame) - 4 - _addButton.frame.size.width, _addButton.frame.origin.y, _addButton.frame.size.width, _addButton.frame.size.height);
        [_cutButton setImage:[UIImage imageNamed:@"icon_-"] forState:UIControlStateNormal];
        _cutButton.backgroundColor = RGB(227, 230, 230);
        [_cutButton addTarget:self action:@selector(cutAmount) forControlEvents:UIControlEventTouchUpInside];
    }
//    [self addSubview:_cutButton];
    
    UILabel *indictor = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_cutButton.frame)-4 - 100, _addButton.frame.origin.y, 100, _addButton.frame.size.height)];
    indictor.font = [UIFont systemFontOfSize:12];
    indictor.textAlignment = NSTextAlignmentRight;
    indictor.textColor = [UIColor lightGrayColor];
    indictor.text = @"购买数量:";
//    [self addSubview:indictor];
	
	if (itemCodelabel == nil) {
		itemCodelabel = [UILabel new];
		itemCodelabel.textColor = RGB(171, 171, 201);
		itemCodelabel.font = [UIFont systemFontOfSize:12];
		[self addSubview:itemCodelabel];
		[itemCodelabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.mas_equalTo(_expressPriceLabel.mas_leading);
			make.height.mas_equalTo(30);
			make.top.mas_equalTo(_expressPriceLabel.mas_bottom);
			
		}];
	}
    
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(_additonalLabel.frame)+20;
    self.frame = frame;
}

- (void)shareAction:(UIButton *)button {
    if (_goodsModel != nil) {
        YCShareModel *shareModel = [[YCShareModel alloc] init];
        shareModel.action_type = @"share";
        shareModel.title = _goodsModel.title;
        shareModel.content = _goodsModel.title;
        NSDictionary *dic = _goodsModel.images.firstObject;
        shareModel.imageUrl = dic[@"url"];
        shareModel.type = @"2";
        shareModel.password = @"";
        shareModel.phone_number = @"";
        shareModel.token = @"";
        shareModel.item_code = _goodsModel.itemCode;
        shareModel.url = @"";
        
        NSString *shareUrl = [YCShareAddress getShareAddressWithShareModel:shareModel];
        shareUrl = [shareUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:shareUrl]]) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:shareUrl]];
            
        }else{
            UIAlertAction *sure = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertSureTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps:https://itunes.apple.com/us/app/%E9%BE%99%E8%81%8A/id1225896079?l=zh&ls=1&mt=8"]];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIAlertActionStyleDefault handler:nil];
            UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SMAlertTitle", nil) message:NSLocalizedString(@"GoDownloadMsg", nil) preferredStyle:UIAlertControllerStyleAlert];
            [alerVC addAction:cancel];
            [alerVC addAction:sure];
            [self.viewController presentViewController:alerVC animated:YES completion:nil];

        }
    }
}

- (void)addAmount {
    NSInteger currentBuy = [_buyAmountLabel.text integerValue];
    currentBuy++;
    if (currentBuy > self.goodsModel.stock.integerValue) {
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:3.0f text:@"商品库存不足"];
        return;
    }
    _buyAmountLabel.text = [NSString stringWithFormat:@"%ld",currentBuy];
}

- (void)cutAmount {
    NSInteger currentBuy = [_buyAmountLabel.text integerValue];
    if (currentBuy == 0) {
        return;
    }
    currentBuy--;
    _buyAmountLabel.text = [NSString stringWithFormat:@"%ld",currentBuy];
}

- (void)setGoodsModel:(SupermarketGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    _titleLabel.text = goodsModel.title;
//	_additonalLabel.text = NSLocalizedString(@"SMGoodsDetailAddtionMsg", nil);
//    _priceLabel.text = [NSString stringWithFormat:@"¥%@/%@",goodsModel.price,goodsModel.unit];
	//jake 170709
	_priceLabel.text = [NSString stringWithFormat:@"%.0f",[goodsModel.price doubleValue]];
    
    CGFloat priceWidth = [UILabel getWidthWithTitle:_priceLabel.text font:_priceLabel.font];
    CGRect priceFrame = _priceLabel.frame;
    priceFrame.size.width = priceWidth;
    _priceLabel.frame = priceFrame;
    
//    _marketPriceLabel.text = [NSString stringWithFormat:@"市场价格:￥%@/%@",goodsModel.marketPrice,goodsModel.unit];
	//jake 170709
	_marketPriceLabel.text = [NSString stringWithFormat:@"%@%.0f",NSLocalizedString(@"SMGoosDetailMarketPrice", nil),[goodsModel.marketPrice doubleValue]];
    _marketPriceLabel.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame), CGRectGetMaxY(_priceLabel.frame)-23, 150, 20);
    
    _stockAmountLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"SMGoodsStockAmount", nil),goodsModel.stock];
    _saleAmountLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"SMGoodsSaleAmount", nil),goodsModel.sold];
    _expressPriceLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"SMGoodsExpressMoney", nil),goodsModel.expressAmount];
    _location.text = goodsModel.city;
	
	itemCodelabel.text = [NSString stringWithFormat:@"商品编号:%@",_goodsModel.itemCode];
}

@end
