//
//  SupermarketChoseSizeView.m
//  Portal
//
//  Created by ifox on 2017/2/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketChoseSizeView.h"
#import "GSFilterView.h"
#import "GSMacros.h"
#import "UILabel+CreateLabel.h"
#import "GoodsOptionModel.h"

@interface SupermarketChoseSizeView ()<DKFilterViewDelegate>

@property(nonatomic, strong) UIView *contentView;
@property (nonatomic,strong) GSFilterView *filterView;

@property(nonatomic, strong) UIButton *addButton;
@property(nonatomic, strong) UITextField *buyAmountLabel;
@property(nonatomic, strong) UIButton *cutButton;
@property(nonatomic, assign) float totalPrice;
@property(nonatomic, assign) NSString *lastSelTitle;
@property(nonatomic, assign) float lastSelPrice;
@property(nonatomic, assign) float itemPrice;
@property(nonatomic, assign) float mutiTotalPrice;

@property(nonatomic, strong) UITapGestureRecognizer *hideKeyboard;
@end

@implementation SupermarketChoseSizeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5];
        _totalPrice = 0.0;
        _lastSelPrice = 0.0;
        _itemPrice = 0.0;
        _mutiTotalPrice = 0.0;
        
        [self setupBasicView];
        
        _hideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidekeyBoard)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyborWillHide) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyboardWillShow {
    [_filterView addGestureRecognizer:_hideKeyboard];
}

- (void)keyborWillHide {
    [_filterView removeGestureRecognizer:_hideKeyboard];
}

- (void)hidekeyBoard {
    [_buyAmountLabel resignFirstResponder];
}

- (void)setupBasicView {
    UITapGestureRecognizer *tapBackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    [self addGestureRecognizer:tapBackGesture];
    
    UIView *contentView = [[UIView alloc] initWithFrame:(CGRect){0, APPScreenHeight - APPScreenHeight*0.7, APPScreenWidth, APPScreenHeight*0.7}];
    contentView.backgroundColor = [UIColor whiteColor];
    // 添加手势，遮盖整个视图的手势，
    UITapGestureRecognizer *contentViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [contentView addGestureRecognizer:contentViewTapGesture];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UIView *iconBackView = [[UIView alloc] initWithFrame:(CGRect){15, -20, 100, 100}];
    iconBackView.backgroundColor = [UIColor whiteColor];
    iconBackView.layer.borderColor = [UIColor whiteColor].CGColor;
    iconBackView.layer.borderWidth = 1;
    iconBackView.layer.cornerRadius = 1.0f;
    [contentView addSubview:iconBackView];
    
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:(CGRect){1, 1, 98, 98}];
    [iconImgView setImage:[UIImage imageNamed:@"m.jpg"]];
    [iconBackView addSubview:iconImgView];
    self.iconImgView = iconImgView;
    
    //关闭按钮
    UIButton *XBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    XBtn.frame = CGRectMake(APPScreenWidth - 30, 10, 15, 15);
    [XBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [XBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:XBtn];
    
    //实际上用来显示价格
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = @"￥ 51555.00";
    priceLabel.textColor = [UIColor redColor];
    priceLabel.font = [UIFont systemFontOfSize:18];
    CGFloat goodsNameLblX = CGRectGetMaxX(iconBackView.frame) + 10;
    CGFloat goodsNameLblY = XBtn.frame.origin.y;
    CGSize size = [priceLabel.text sizeWithFont:priceLabel.font];
    priceLabel.frame = (CGRect){goodsNameLblX, goodsNameLblY, size};
    [contentView addSubview:priceLabel];
    self.goodsPriceLabel = priceLabel;
    
    //实际用来显示库存
    UILabel *remainLabel = [[UILabel alloc] initWithFrame:(CGRect){priceLabel.frame.origin.x, CGRectGetMaxY(priceLabel.frame)+5, 150, 15}];
    remainLabel.text = @"库存12345件";
    remainLabel.font = [UIFont systemFontOfSize:13];
    remainLabel.textColor = [UIColor darkcolor];
    [contentView addSubview:remainLabel];
    self.goodsStockLabel = remainLabel;
    
    //选择 尺寸 颜色 分类
    UILabel *choseSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.frame.origin.x, CGRectGetMaxY(remainLabel.frame)+5, 250, 15)];
    choseSizeLabel.textColor = remainLabel.textColor;
    choseSizeLabel.font = remainLabel.font;
    choseSizeLabel.text = NSLocalizedString(@"SMGoodsFilterMsg", nil);
    [contentView addSubview:choseSizeLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImgView.frame)+10, APPScreenWidth, 1)];
    line.backgroundColor = BGColor;
    [contentView addSubview:line];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = RGB(33, 192, 67);
    [sureBtn setTitle:NSLocalizedString(@"SMAlertSureTitle", nil) forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(0, contentView.frame.size.height - 45, APPScreenWidth, 45);
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sureBtn];
    
    NSArray *filterData =  @[@"白色苹果   12元",@"白色苹果   12元",@"白色苹果   12元",@"白色苹果   12元"];
    DKFilterModel *model = [[DKFilterModel alloc] initElement:filterData ofType:DK_SELECTION_SINGLE];
    model.title = NSLocalizedString(@"SMGoodsFilterSingleChoose", nil);
    model.style = DKFilterViewDefault;
    
//    filterData = @[@"白色",@"更白的白色",@"比前一个更白的白色",@"没那么白",@"浅白色",@"最后一个白色"];
//    DKFilterModel *radioModel = [[DKFilterModel alloc] initElement:filterData ofType:DK_SELECTION_SINGLE];
//    radioModel.title = @"自适应标题单选展示";
//    radioModel.style = DKFilterViewDefault;
    
    filterData = @[@"多选",@"长一点的多选",@"多选不长的按钮",@"多选比较长",@"长",@"最长的多选?",@"非常长",@"忘记了",@"还有多长"];
    DKFilterModel *checkModel = [[DKFilterModel alloc] initElement:filterData ofType:DK_SELECTION_MULTIPLE];
    checkModel.title = NSLocalizedString(@"SMGoodsFilterMutiChoose", nil);
    checkModel.style = DKFilterViewDefault;
    
    self.filterView = [[GSFilterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), APPScreenWidth, CGRectGetMinY(sureBtn.frame) - CGRectGetMaxY(line.frame))];
    self.filterView.delegate = self;
//    [self.filterView setFilterModels:@[model,checkModel]];
    [contentView addSubview:self.filterView];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 200)];
    footer.backgroundColor = [UIColor whiteColor];
    
    UILabel *buyAmountTitle = [UILabel createLabelWithFrame:CGRectMake(10, 5, 100, 20) textColor:[UIColor darkcolor] font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"SMGoodsFilterBuyAmount", nil)];
    [footer addSubview:buyAmountTitle];
    
    if (_addButton == nil) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(self.frame.size.width - 10 - 28, buyAmountTitle.frame.origin.y, 28, 22);
        [_addButton setImage:[UIImage imageNamed:@"icon_+"] forState:UIControlStateNormal];
        _addButton.backgroundColor = RGB(227, 230, 230);
        
        [_addButton addTarget:self action:@selector(addAmount) forControlEvents:UIControlEventTouchUpInside];
    }
    [footer addSubview:_addButton];
    
    if (_buyAmountLabel == nil) {
        _buyAmountLabel = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_addButton.frame) - 4 - _addButton.frame.size.width, _addButton.frame.origin.y, _addButton.frame.size.width, _addButton.frame.size.height)];
        _buyAmountLabel.backgroundColor = RGB(227, 230, 230);
        _buyAmountLabel.textAlignment = NSTextAlignmentCenter;
        _buyAmountLabel.keyboardType = UIKeyboardTypeNumberPad;
        _buyAmountLabel.text = @"1";
    }
    [footer addSubview:_buyAmountLabel];
    
    if (_cutButton == nil) {
        _cutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cutButton.frame = CGRectMake(CGRectGetMinX(_buyAmountLabel.frame) - 4 - _addButton.frame.size.width, _addButton.frame.origin.y, _addButton.frame.size.width, _addButton.frame.size.height);
        [_cutButton setImage:[UIImage imageNamed:@"icon_-"] forState:UIControlStateNormal];
        _cutButton.backgroundColor = RGB(227, 230, 230);
        [_cutButton addTarget:self action:@selector(cutAmount) forControlEvents:UIControlEventTouchUpInside];
    }
    [footer addSubview:_cutButton];
    
    UIView *footerLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cutButton.frame)+10, APPScreenWidth, 1)];
    footerLine.backgroundColor = BGColor;
    [footer addSubview:footerLine];
    
    self.filterView.tableView.tableFooterView = footer;
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    NSArray *single;
    NSArray *muti;
    for (int i = 0; i < dataSource.count; i++) {
        if (i == 0) {
            id obj = dataSource[i];
            if ([obj isKindOfClass:[NSMutableArray class]]) {
                single = obj;
            }
        } else {
            id obj = dataSource[i];
            if ([obj isKindOfClass:[NSMutableArray class]]) {
                muti = obj;
            }
        }
    }
    NSMutableArray *singleTitle = @[].mutableCopy;
    if (single.count > 0) {
        for (GoodsOptionModel *option in single) {
            [singleTitle addObject:option.item_name];
        }
    }
    
    DKFilterModel *model;
    
    if (singleTitle.count > 0) {
       
        model = [[DKFilterModel alloc] initElement:singleTitle.copy ofType:DK_SELECTION_SINGLE];
        model.title = NSLocalizedString(@"SMGoodsFilterSingleChoose", nil);
        model.style = DKFilterViewDefault;
    }
    
    NSMutableArray *mutiTitle = @[].mutableCopy;
    if (muti.count > 0) {
        for (GoodsOptionModel *option in muti) {
            [mutiTitle addObject:option.item_name];
        }
    }
    
    DKFilterModel *mutiModel;
    if (mutiTitle.count > 0) {
        mutiModel = [[DKFilterModel alloc] initElement:mutiTitle.copy ofType:DK_SELECTION_MULTIPLE];
        mutiModel.title = NSLocalizedString(@"SMGoodsFilterMutiChoose", nil);
        mutiModel.style = DKFilterViewDefault;
    }
    
    NSMutableArray *filterModels = @[].mutableCopy;
    if (model != nil) {
        [filterModels addObject:model];
    }
    if (mutiModel != nil) {
        [filterModels addObject:mutiModel];
    }
    
    self.filterView.filterModels = filterModels.copy;
}

- (void)addAmount {
    NSInteger currentBuy = [_buyAmountLabel.text integerValue];
    
    currentBuy++;
    
//    if (currentBuy > self.goodsModel.stock.integerValue) {
//        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:3.0f text:@"商品库存不足"];
//        return;
//    }
    
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

- (void)didClickAtModel:(DKFilterModel *)data {
    NSLog(@"%@",data);
    
    NSString *title = data.clickedButtonText;
    
    float mutiPrice = 0.0;
    
    if (data.type == DK_SELECTION_SINGLE) {
        if (data.isSelected == YES) {
            for (GoodsOptionModel *model in _dataSource.firstObject) {
                if ([model.item_name isEqualToString:title]) {
                    
                    if ([_lastSelTitle isEqualToString:model.item_name]) {
                        _itemPrice = model.item_price.floatValue;
                    }
                    else {
                        _totalPrice = _totalPrice - _lastSelPrice;
                        _itemPrice = model.item_price.floatValue;
                    }
                    _lastSelTitle = model.item_name;
                    _lastSelPrice = _itemPrice;
                }
            }
        } else {
            for (GoodsOptionModel *model in _dataSource.firstObject) {
                if ([model.item_name isEqualToString:title]) {
                    if ([_lastSelTitle isEqualToString:model.item_name]) {
                        _itemPrice = 0;
                        _lastSelPrice = 0;
                    }
                    else {
                        _totalPrice = _totalPrice - _lastSelPrice;
                        _itemPrice = model.item_price.floatValue;
                    }
                    _lastSelTitle = model.item_name;
                }
            }
        }
       
    }
    
    
    if (data.type == DK_SELECTION_MULTIPLE) {
        if (data.isSelected == YES) {
            for (GoodsOptionModel *model in _dataSource.lastObject) {
                if ([model.item_name isEqualToString:title]) {
                    mutiPrice = model.item_price.floatValue;
                }
            }
        } else {
            for (GoodsOptionModel *model in _dataSource.lastObject) {
                if ([model.item_name isEqualToString:title]) {
                    mutiPrice = -model.item_price.floatValue;
                }
            }

        }
        
        _mutiTotalPrice = _mutiTotalPrice + mutiPrice;
    }
    
    _totalPrice = _mutiTotalPrice + _itemPrice;
    //    NSArray *result = [self.filterView.filterModels.firstObject getFilterResult];
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥ %.2f",_totalPrice];
}


- (void)sureBtnClick {
    NSLog(@"%@",self.filterView.filterModels);
    NSString *result = @"";
    NSMutableArray *chosedTitles = @[].mutableCopy;
    for (DKFilterModel *model in self.filterView.filterModels) {
        NSArray *array = [model getFilterResult];
        [chosedTitles addObjectsFromArray:array];
    }

    
    if ([self.delegate respondsToSelector:@selector(choseSizeViewSureButtonClicked:)]) {
        [_delegate choseSizeViewSureButtonClicked:chosedTitles];
    }
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    __weak typeof(self) _weakSelf = self;
    self.contentView.frame = CGRectMake(0, APPScreenHeight, APPScreenWidth, APPScreenHeight*0.7);
    
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _weakSelf.contentView.frame = CGRectMake(0, APPScreenHeight - APPScreenHeight*0.7, APPScreenWidth, APPScreenHeight*0.7);
    }completion:^(BOOL finished) {
        
    }];
    
}

- (NSInteger)buyAmount {
    _buyAmount = self.buyAmountLabel.text.integerValue;
    return _buyAmount;
}

- (void)removeView {
    __weak typeof(self) _weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        _weakSelf.backgroundColor = [UIColor clearColor];
        _weakSelf.contentView.frame = CGRectMake(0, APPScreenHeight, APPScreenWidth, APPScreenHeight*0.7);
        
    } completion:^(BOOL finished) {
        [_weakSelf removeFromSuperview];
    }];
}

@end
