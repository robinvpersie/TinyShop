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
		self.contentView.backgroundColor = RGB(242, 244, 246);
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.numberDomainView = [[NumDomainView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH,SCREEN_WIDTH + 100)];
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
