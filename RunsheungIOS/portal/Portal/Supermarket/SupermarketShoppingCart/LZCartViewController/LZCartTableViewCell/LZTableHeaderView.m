//
//  LZTableHeaderView.m
//  LZCartViewController
//
//  Created by Artron_LQQ on 16/5/31.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZTableHeaderView.h"
#import "LZConfigFile.h"
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"

@interface LZTableHeaderView ()

@property (strong,nonatomic)YYLabel *titleLabel;
@property (strong,nonatomic)UIButton *button;
@property (strong,nonatomic)UIButton *edit;

@end
@implementation LZTableHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(7, 5, 50, 30);
    
    [button setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    self.button = button;
    
    UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
    [edit setTitle:@"编辑" forState:UIControlStateNormal];
    [edit setTitle:@"完成" forState:UIControlStateSelected];
    edit.frame = CGRectMake(APPScreenWidth - 50, 5, 50, 30);
    edit.titleLabel.font = [UIFont systemFontOfSize:12];
    [edit setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [edit addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:edit];
    edit.hidden = YES;
    self.edit = edit;
    
    YYLabel *label = [[YYLabel alloc]init];
    label.frame = CGRectMake(CGRectGetMaxX(button.frame)-10, 5, LZSCREEN_WIDTH - 100, 30);
    label.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label];
    self.titleLabel = label;
}
- (void)buttonClick:(UIButton*)button {
    button.selected = !button.selected;
    
    if (self.lzClickBlock) {
        self.lzClickBlock(button.selected);
    }
}

- (void)editClick:(UIButton *)button {
    button.selected = !button.selected;
    
    if (self.editClickBlock) {
        self.editClickBlock(button.selected);
    }
}

//- (void)setSelect:(BOOL)select {
//    
//    self.button.selected = select;
//    _select = select;
//}

- (void)setSelectShop:(BOOL)selectShop {
    self.button.selected = selectShop;
    _selectShop = selectShop;
}

- (void)setIsEditingSelected:(BOOL)isEditingSelected {
    self.edit.selected = isEditingSelected;
    _isEditingSelected = isEditingSelected;
}

- (void)setTitle:(NSString *)title {
    NSString *total = [NSString stringWithFormat:@"%@  >",title];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:total];
    string.yy_color = [UIColor lightGrayColor];
    [string yy_setTextHighlightRange:NSMakeRange(0, title.length) color:[UIColor blackColor] backgroundColor:[UIColor whiteColor] tapAction:nil];
    [self.titleLabel setAttributedText:string];
    _title = title;
}

@end
