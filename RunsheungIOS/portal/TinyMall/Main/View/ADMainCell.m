//
//  ADMainCell.m
//  Portal
//
//  Created by linpeng on 2018/4/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "ADMainCell.h"

@interface ADMainCell()

@property (nonatomic, strong) UIImageView *adView;

@end

@implementation ADMainCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = RGB(245, 245, 245);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.adView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.adView];
        [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic {
    [self.adView sd_setImageWithURL:dic[@"shop_thumnail_image"] placeholderImage: [UIImage imageNamed:@"no_search"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
