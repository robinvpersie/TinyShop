//
//  SupermarketMyOrderGoodView.m
//  Portal
//
//  Created by ifox on 2016/12/23.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketMyOrderGoodView.h"
#import "UILabel+CreateLabel.h"
#import "UIImageView+ImageCache.h"

#define ImageHeight 80
#define CellHeight  110

@implementation SupermarketMyOrderGoodView {
    UIImageView *_icon;
    UILabel *_title;
    UILabel *_price;
    UILabel *_buyAmout;
    UIButton *_reFundButton;
    UILabel *_refundLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createView {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, ImageHeight, ImageHeight)];
        _icon.clipsToBounds = YES;
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        _icon.image = [UIImage imageNamed:@"img_001"];
    }
    [self addSubview:_icon];
    
    if (_title == nil) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+10, _icon.frame.origin.y, self.frame.size.width - 15 - 10 - 10 - ImageHeight, 40)];
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = [UIColor darkGrayColor];
        _title.numberOfLines = 0;
        _title.text = @"挪威新鲜无公害精选核桃无公害健康果干";
    }
    [self addSubview:_title];
    
    if (_price == nil) {
        _price = [[UILabel alloc] initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_icon.frame)-25, 100, 25)];
        _price.textColor = [UIColor darkGrayColor];
        _price.font = [UIFont systemFontOfSize:15];
        _price.text = @"8.9/Kg";
    }
    [self addSubview:_price];
    
    if (_buyAmout == nil) {
        _buyAmout = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 10 - 50, _price.frame.origin.y, 50, _price.frame.size.height)];
        _buyAmout.textAlignment = NSTextAlignmentRight;
        _buyAmout.textColor = [UIColor darkGrayColor];
        _buyAmout.font = [UIFont systemFontOfSize:13];
        _buyAmout.text = @"x2";
    }
    [self addSubview:_buyAmout];
    
    if (_reFundButton == nil) {
        _reFundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    if (_refundLabel == nil) {
        _refundLabel = [UILabel createLabelWithFrame:CGRectMake(APPScreenWidth - 10 - 80, CGRectGetMaxY(_buyAmout.frame), 80, 25) textColor:RGB(245, 150, 27) font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentRight text:@"退款中"];
    }
    [self addSubview:_refundLabel];
}

- (void)setData:(SupermarketOrderGoodsData *)data {
    _data = data;
    if ([data isKindOfClass:[SupermarketOrderGoodsData class]]) {
        if (data.amount != nil) {
            _buyAmout.text = [NSString stringWithFormat:@"x%@",data.amount];
        }
        
        if (data.stockUnit != nil) {
            _price.text = [NSString stringWithFormat:@"%.f%@",data.price.floatValue,data.stockUnit];
        }
        
        if (data.title != nil) {
            _title.text = data.title;
        }
        [_title sizeToFit];
        
        if (data.image_url != nil) {
            [UIImageView setimageWithImageView:_icon UrlString:data.image_url imageVersion:nil];
        }
        
        switch (data.refundStatus) {
            case RefundStatus0:
                _refundLabel.hidden = YES;
                break;
            case RefundStatus1:
                _refundLabel.text = @"退款中";
                break;
            case RefundStatus2:
                _refundLabel.text = @"退款完成";
                break;
            case RefundStatus3:
                
                break;
            case RefundStatus4:
                
                break;
            case RefundStatus5:
                
                break;
            case RefundStatus6:
                
                break;
                
            default:
                break;
        }
        
    }
}

@end
