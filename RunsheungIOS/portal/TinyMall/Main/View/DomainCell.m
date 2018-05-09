//
//  DomainCell.m
//  Portal
//
//  Created by linpeng on 2018/4/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "DomainCell.h"
#import "NumDomainView.h"

@interface DomainCell()

@property (nonatomic, strong) NumDomainView *numberDomainView;

@end

@implementation DomainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.numberDomainView = [[NumDomainView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH, 3 * SCREEN_WIDTH / 5.0 + 60)];
        self.numberDomainView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.numberDomainView];
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
