//
//  ADHeaderCell.m
//  Portal
//
//  Created by linpeng on 2018/5/9.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "ADHeaderCell.h"
#import "ADView.h"

@interface ADHeaderCell()

@end

@implementation ADHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        ADView *adone = [[ADView alloc] init];
        adone.image = [UIImage imageNamed:@"icon_home_scan"];
        adone.title = @"QR코드";
        [self.contentView addSubview:adone];
        
        ADView *adtwo = [[ADView alloc] init];
        adtwo.image = [UIImage imageNamed:@"icon_home_sns"];
        adtwo.title = @"sns";
        [self.contentView addSubview:adtwo];
        
        ADView *adthree = [[ADView alloc] init];
        adthree.image = [UIImage imageNamed:@"icon_home_live"];
        adthree.title = @"방송";
        [self.contentView addSubview:adthree];
        
        UIStackView *stack = [[UIStackView alloc] init];
        stack.axis = UILayoutConstraintAxisHorizontal;
        stack.alignment = UIStackViewAlignmentFill;
        stack.spacing = 20;
        stack.distribution = UIStackViewDistributionFillEqually;
        stack.translatesAutoresizingMaskIntoConstraints = false;
        [stack addArrangedSubview:adone];
        [stack addArrangedSubview:adtwo];
        [stack addArrangedSubview:adthree];
        [self.contentView addSubview:stack];
        
        [stack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.height.equalTo(self.contentView);
            make.width.equalTo(self.contentView).multipliedBy(0.8);
        }];
        
    }
    return self;
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
