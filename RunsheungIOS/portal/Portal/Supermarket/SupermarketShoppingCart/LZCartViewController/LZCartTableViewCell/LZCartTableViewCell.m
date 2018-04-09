//
//  LZCartTableViewCell.m
//  LZCartViewController
//
//  Created by LQQ on 16/5/18.
//  Copyright © 2016年 LQQ. All rights reserved.
//  https://github.com/LQQZYY/CartDemo
//  http://blog.csdn.net/lqq200912408
//  QQ交流: 302934443

#import "LZCartTableViewCell.h"
#import "LZConfigFile.h"
#import "LZCartModel.h"
#import "UIImageView+ImageCache.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface LZCartTableViewCell ()
{
    LZNumberChangedBlock numberAddBlock;
    LZNumberChangedBlock numberCutBlock;
    LZCellSelectedBlock cellSelectedBlock;
}
//选中按钮
@property (nonatomic,retain) UIButton *selectBtn;
//显示照片
@property (nonatomic,retain) UIImageView *lzImageView;
//商品名
@property (nonatomic,retain) UILabel *nameLabel;
//尺寸
@property (nonatomic,retain) UILabel *sizeLabel;
//时间
@property (nonatomic,retain) UILabel *dateLabel;
//价格
@property (nonatomic,retain) UILabel *priceLabel;
//数量
@property (nonatomic,retain)UILabel *numberLabel;

@property (nonatomic,retain) UIButton *addButton;

@property (nonatomic, retain) UIButton *cutButton;

@end

@implementation LZCartTableViewCell {
    UIButton *choseSizeBtn;
    UIButton *delete;
    UIView *bgView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupMainView];
    }
    return self;
}
#pragma mark - public method
- (void)reloadDataWithModel:(LZCartModel*)model {
    
    self.lzImageView.image = model.image;
    
    [UIImageView setimageWithImageView:self.lzImageView UrlString:model.image_url imageVersion:nil];
    
    self.nameLabel.text = model.nameStr;
	self.priceLabel.text = [NSString stringWithFormat:@"%.f",[model.price doubleValue]];
    self.dateLabel.text = model.dateStr;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)model.number];
    self.sizeLabel.text = model.sizeStr;
    self.selectBtn.selected = model.select;
    
    if (model.isEditing == YES) {
        self.isEditing = YES;
    } else {
        self.isEditing = NO;
    }
}


- (void)configureWithModel: (NewCartModel *)model {
    [self.lzImageView sd_setImageWithURL:[NSURL URLWithString:model.shopthumnail]];
    self.numberLabel.text = model.salecustomcnt;
    self.dateLabel.text = model.distance;
    self.sizeLabel.text = model.score;
}


- (void)numberAddWithBlock:(LZNumberChangedBlock)block {
    numberAddBlock = block;
}

- (void)numberCutWithBlock:(LZNumberChangedBlock)block {
    numberCutBlock = block;
}

- (void)cellSelectedWithBlock:(LZCellSelectedBlock)block {
    cellSelectedBlock = block;
}
#pragma mark - 重写setter方法
- (void)setLzNumber:(NSInteger)lzNumber {
    _lzNumber = lzNumber;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)lzNumber];
}

- (void)setLzSelected:(BOOL)lzSelected {
    _lzSelected = lzSelected;
    self.selectBtn.selected = lzSelected;
}
#pragma mark - 按钮点击方法
- (void)selectBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    if (cellSelectedBlock) {
        cellSelectedBlock(button.selected);
    }
}

- (void)addBtnClick:(UIButton*)button {
    
    NSInteger count = [self.numberLabel.text integerValue];
    count++;
    
    if (numberAddBlock) {
        numberAddBlock(count);
    }
}

- (void)cutBtnClick:(UIButton*)button {
    NSInteger count = [self.numberLabel.text integerValue];
    count--;
    if(count <= 0){
        return ;
    }

    if (numberCutBlock) {
        numberCutBlock(count);
    }
}

- (void)setIsCollection:(BOOL)isCollection {
    _isCollection = isCollection;
    if (isCollection) {
        self.numberLabel.hidden = YES;
        self.addButton.hidden = YES;
        self.cutButton.hidden = YES;
    }
    else {
        self.numberLabel.hidden = NO;
        self.addButton.hidden = NO;
        self.cutButton.hidden = NO;
    }
}

#pragma mark - 布局主视图
-(void)setupMainView {
    //白色背景
    bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, LZSCREEN_WIDTH, lz_CartRowHeight);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = LZColorFromHex(0xEEEEEE).CGColor;
    bgView.layer.borderWidth = 1;
    [self addSubview:bgView];
    
    //选中按钮
    UIButton* selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.center = CGPointMake(30, bgView.height/2.0);
    selectBtn.bounds = CGRectMake(0, 0, 30, 30);
    [selectBtn setImage:[UIImage imageNamed:lz_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:lz_Bottom_SelectButtonString] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selectBtn];
    self.selectBtn = selectBtn;
    
    //照片背景
    UIView *imageBgView = [[UIView alloc]init];
    imageBgView.frame = CGRectMake(selectBtn.right + 5, 5, bgView.height - 10, bgView.height - 10);
//    imageBgView.backgroundColor = LZColorFromHex(0xF3F3F3);
    [bgView addSubview:imageBgView];
    
    //显示照片
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"default_pic_1"];
    imageView.frame = imageBgView.frame;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:imageView];
    self.lzImageView = imageView;
    
//    CGFloat width = (bgView.width - imageBgView.right - 30)/2.0;
    CGFloat width = (bgView.width - imageBgView.right - 15);
    //价格
    UILabel* priceLabel = [[UILabel alloc]init];
//    priceLabel.frame = CGRectMake(bgView.width - width - 10, 10, width, 30);
    priceLabel.frame = CGRectMake(imageBgView.right+10, bgView.height - 30, 100, 20);
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textColor = BASECOLOR_RED;
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    //商品名
    UILabel* nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(imageBgView.right + 10, 10, width, 35);
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.numberOfLines = 2;
    nameLabel.textColor = [UIColor darkGrayColor];
    [bgView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //尺寸
    UILabel* sizeLabel = [[UILabel alloc]init];
    sizeLabel.frame = CGRectMake(nameLabel.left, nameLabel.bottom + 5, width, 20);
    sizeLabel.textColor = LZColorFromRGB(132, 132, 132);
    sizeLabel.font = [UIFont systemFontOfSize:12];
//    [bgView addSubview:sizeLabel];
    self.sizeLabel = sizeLabel;
    
    //时间
    UILabel* dateLabel = [[UILabel alloc]init];
    dateLabel.frame = CGRectMake(nameLabel.left, sizeLabel.bottom , width, 20);
    dateLabel.font = [UIFont systemFontOfSize:10];
    dateLabel.textColor = LZColorFromRGB(132, 132, 132);
//    [bgView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    //数量加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(bgView.width - 35, bgView.height - 35, 22, 22);
    [addBtn setImage:[UIImage imageNamed:@"icon_+"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"cart_addBtn_highlight"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.addButton = addBtn;
    [bgView addSubview:addBtn];
    
    //数量显示
    UILabel* numberLabel = [[UILabel alloc]init];
    numberLabel.frame = CGRectMake(addBtn.left - 25, addBtn.top, 25, 22);
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = @"1";
    numberLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:numberLabel];
    self.numberLabel = numberLabel;
    
    //数量减按钮
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cutBtn.frame = CGRectMake(numberLabel.left - 25, addBtn.top, 25, 25);
    [cutBtn setImage:[UIImage imageNamed:@"icon_-"] forState:UIControlStateNormal];
    [cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_highlight"] forState:UIControlStateHighlighted];
    [cutBtn addTarget:self action:@selector(cutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cutButton = cutBtn;
    [bgView addSubview:cutBtn];
    
    //选择尺寸
    choseSizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    choseSizeBtn.frame = CGRectMake(APPScreenWidth - 50 - 25 - 10, sizeLabel.frame.origin.y, 25, 25);
    [choseSizeBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    choseSizeBtn.hidden = YES;
//    [choseSizeBtn addTarget:self action:@selector(choseSize:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:choseSizeBtn];
    
    //删除按钮
    delete = [UIButton buttonWithType:UIButtonTypeCustom];
    delete.frame = CGRectMake(bgView.frame.size.width - 45,bgView.frame.origin.y, 45, bgView.frame.size.height);
    delete.titleLabel.font = [UIFont systemFontOfSize:14];
    delete.backgroundColor = [UIColor redColor];
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    [delete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    delete.hidden = YES;
//    [delete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delete];
    
    if (_isCollection == YES) {
        addBtn.hidden = YES;
        numberLabel.hidden = YES;
        cutBtn.hidden = YES;
    } else {
        addBtn.hidden = NO;
        numberLabel.hidden = NO;
        cutBtn.hidden = NO;

    }
}

- (void)setIsEditing:(BOOL)isEditing {
    _isEditing = isEditing;
    if (isEditing == YES) {
        [UIView animateWithDuration:0.35f animations:^{
            delete.hidden = NO;
            choseSizeBtn.hidden = NO;
            
            _nameLabel.frame = CGRectMake(_lzImageView.right + 10, 10, APPScreenWidth - _lzImageView.right - 20 - 40, 35);
            _addButton.frame = CGRectMake(bgView.width - 35 - 20 - 5, bgView.height - 30, 20, 20);
            _numberLabel.frame = CGRectMake(_addButton.left - 25, _addButton.top, 20, 20);
            _cutButton.frame = CGRectMake(_numberLabel.left - 20, _addButton.top, 20, 20);
        }];
    } else {
        [UIView animateWithDuration:0.35f animations:^{
            delete.hidden = YES;
            choseSizeBtn.hidden = YES;
            
            _nameLabel.frame = CGRectMake(_lzImageView.right + 10, 10, APPScreenWidth - _lzImageView.right - 20, 35);
            _addButton.frame = CGRectMake(bgView.width - 35, bgView.height - 30, 22, 22);
            _numberLabel.frame = CGRectMake(_addButton.left - 25, _addButton.top, 25, 22);
            _cutButton.frame = CGRectMake(_numberLabel.left - 22, _addButton.top, 22, 22);

        }];
    }
}

@end
