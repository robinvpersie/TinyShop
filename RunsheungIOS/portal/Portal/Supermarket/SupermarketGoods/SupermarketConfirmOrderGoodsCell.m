//
//  SupermarketConfirmOrderGoodsCell.m
//  Portal
//
//  Created by ifox on 2016/12/26.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketConfirmOrderGoodsCell.h"
#import "SupermarketApplyRefundController.h"
#import "UIView+ViewController.h"
#import "UIButton+CreateButton.h"
#import "UIImageView+ImageCache.h"

@implementation SupermarketConfirmOrderGoodsCell {
    UIImageView *goodsImage;
    UILabel *title;
    UILabel *price;
    UILabel *amount;
    
    UIButton *refund;
    UIButton *cancleRefund;
    UIButton *addExpress;//填写快递
    UIButton *checkProgress;//查看进程
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 100, 100)];
    goodsImage.image = [UIImage imageNamed:@"img_001"];
    goodsImage.contentMode = UIViewContentModeScaleAspectFit;
    goodsImage.clipsToBounds = YES;
    [self.contentView addSubview:goodsImage];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImage.frame)+10, goodsImage.frame.origin.y, APPScreenWidth - 100 - 10 - 15 - 10, 45)];
    title.textColor = [UIColor darkGrayColor];
    title.text = @"挪威新鲜无公害精选无公害果干无公害果干";
    title.numberOfLines = 2;
    title.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:title];
    
    price = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(title.frame), 110 - 10 - 20, 120, 20)];
    price.textColor = [UIColor redColor];
    price.font = [UIFont systemFontOfSize:14];
    price.text = @"￥8.9/kg";
    [self.contentView addSubview:price];
    
    amount = [[UILabel alloc] initWithFrame:CGRectMake(APPScreenWidth - 10 - 80, price.frame.origin.y, 80, 20)];
    amount.textAlignment = NSTextAlignmentRight;
    amount.textColor = [UIColor darkGrayColor];
    amount.text = @"x1";
    amount.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:amount];
    
    if (refund == nil) {
        refund = [UIButton createButtonWithFrame:CGRectMake(APPScreenWidth - 80 - 10, price.frame.origin.y-3, 80, 23) title:NSLocalizedString(@"SMOrderRefundTitle", nil) titleColor:[UIColor darkGrayColor] titleFont:[UIFont systemFontOfSize:14] backgroundColor:[UIColor whiteColor]];
        refund.hidden = YES;
        refund.layer.borderWidth = 1.0f;
        refund.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [refund addTarget:self action:@selector(goApplyRefund) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.contentView addSubview:refund];
    
    if (cancleRefund == nil) {
        cancleRefund = [UIButton createButtonWithFrame:refund.frame title:NSLocalizedString(@"SMOrderCancelRefund", nil) titleColor:[UIColor darkGrayColor]  titleFont:refund.titleLabel.font backgroundColor:refund.backgroundColor];
        cancleRefund.hidden = YES;
        cancleRefund.layer.borderWidth = 1.0f;
        cancleRefund.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [cancleRefund addTarget:self action:@selector(cancelRefund) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.contentView addSubview:cancleRefund];
    
    if(addExpress == nil) {
        addExpress = [UIButton createButtonWithFrame:refund.frame title:NSLocalizedString(@"SMOrderRefundAddExpress", nil) titleColor:[UIColor darkGrayColor]  titleFont:refund.titleLabel.font backgroundColor:refund.backgroundColor];
        addExpress.hidden = YES;
        addExpress.layer.borderWidth = 1.0f;
        addExpress.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [addExpress addTarget:self action:@selector(addExpress) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.contentView addSubview:addExpress];
    
    if(checkProgress == nil) {
        checkProgress = [UIButton createButtonWithFrame:refund.frame title:NSLocalizedString(@"SMOrderRefundAddExpress", nil) titleColor:[UIColor darkGrayColor]  titleFont:refund.titleLabel.font backgroundColor:refund.backgroundColor];
        checkProgress.hidden = YES;
        checkProgress.layer.borderWidth = 1.0f;
        checkProgress.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [checkProgress addTarget:self action:@selector(checkProgress) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.contentView addSubview:checkProgress];
    
}

- (void)setGoods:(SupermarketOrderGoodsData *)goods {
    _goods = goods;
    [UIImageView setimageWithImageView:goodsImage UrlString:_goods.image_url imageVersion:_goods.ver];
    title.text = goods.title;
//    price.text = [NSString stringWithFormat:@"¥%@/%@",goods.price,goods.stockUnit];
    price.text = [NSString stringWithFormat:@"¥%@",goods.price];
    amount.text = [NSString stringWithFormat:@"x%@",goods.amount];
    
    switch (goods.refundStatus) {
        case RefundStatus0:
            if (_orderStatus == 3) {
                refund.hidden = NO;
            }
            break;
        case RefundStatus1:
//            cancleRefund.hidden = NO;
                        break;
        case RefundStatus2:
            if (_orderStatus == 3) {
                refund.hidden = NO;
            }

            break;
        case RefundStatus3:
//            addExpress.hidden = NO;
            break;
        case RefundStatus4:
//            checkProgress.hidden = NO;
            break;
        case RefundStatus5:
            
            break;
        case RefundStatus6:
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - ButoonActions
- (void)goApplyRefund {
    SupermarketApplyRefundController *vc = [[SupermarketApplyRefundController alloc] init];
    vc.goods = self.goods;
    vc.orderNum = self.order_num;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)cancelRefund {
    
}

- (void)addExpress {
    
}

- (void)checkProgress {
    
}

- (void)setCellType:(NSInteger)cellType {
    _cellType = cellType;
    if (cellType == 1) {
//        refund.hidden = NO;
        CGRect titleFrame = title.frame;
        titleFrame.size.width -= 80;
        title.frame = titleFrame;
        
        amount.frame = price.frame;
        amount.textAlignment = NSTextAlignmentLeft;
        
        price.frame = CGRectMake(APPScreenWidth - 10 - 80, title.frame.origin.y+3, 80, 20);
        price.textAlignment = NSTextAlignmentRight;
    }
}

@end
