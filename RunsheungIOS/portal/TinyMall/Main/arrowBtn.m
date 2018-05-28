//
//  arrowBtn.m
//  Portal
//
//  Created by dlwpdlr on 2018/5/26.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "arrowBtn.h"

@implementation arrowBtn

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		self.layer.cornerRadius = 4;
		self.layer.masksToBounds = YES;
		self.layer.borderColor = RGB(101, 101, 101).CGColor;
		self.layer.borderWidth = 1.0f;
		[self addTarget:self action:@selector(popChoiceView:) forControlEvents:UIControlEventTouchUpInside];
	}
	return self;
}

- (void)setData:(NSArray *)data{
	_data = data;
	[self createSubviews];

}

- (void)createSubviews{
	self.values = [NSMutableArray array];
	_value = [UILabel new];
	NSDictionary *dic = _data.firstObject;
	if ([dic.allKeys containsObject:@"level_name"]) {
		
		_value.text = dic[@"level_name"];
		for (NSDictionary*dics in _data) {
			[self.values addObject:dics[@"level_name"]];
		}
	} else 	if ([dic.allKeys containsObject:@"VoucherVl"]) {
		_value.text = dic[@"VoucherVl"];
		for (NSDictionary*dics in _data) {
			[self.values addObject:dics[@"VoucherVl"]];
		}

	}else if ([dic.allKeys containsObject:@"OrderByVl"]) {
		_value.text = dic[@"OrderByVl"];
		for (NSDictionary*dics in _data) {
			[self.values addObject:dics[@"OrderByVl"]];
		}

	}else if ([dic.allKeys containsObject:@"DeliveryVl"]) {
		_value.text = dic[@"DeliveryVl"];
		for (NSDictionary*dics in _data) {
			[self.values addObject:dics[@"DeliveryVl"]];
		}

	}else if ([dic.allKeys containsObject:@"EventVl"]) {
		_value.text = dic[@"EventVl"];
		for (NSDictionary*dics in _data) {
			[self.values addObject:dics[@"EventVl"]];
		}

	}

	
	_value.textColor = RGB(71, 71, 71);
	_value.font = [UIFont systemFontOfSize:14];
	[self addSubview:_value];
	[_value mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(5);
		make.bottom.mas_equalTo(-5);
	}];
	
	UIImageView *arrow = [UIImageView new];
	arrow.image = [UIImage imageNamed:@"icon_location00"];
	[self addSubview:arrow];
	[arrow mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(14);
		make.trailing.bottom.mas_equalTo(-8);
		make.top.mas_equalTo(8);
	}];
	
	
	
}

- (void)popChoiceView:(UIButton*)sender{
	if (self.popTableView == nil) {
		NSLog(@"%d",(int)sender.tag);
		_cover = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
		_cover.backgroundColor = [UIColor blackColor];
		_cover.alpha = 0.3f;
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDiss:)];
		[_cover addGestureRecognizer:tap];
		[[UIApplication sharedApplication].delegate.window addSubview:_cover];
		
		CGRect newFrame = [self convertRect:self.bounds toView:[UIApplication sharedApplication].delegate.window ];
		self.popTableView = [[UITableView alloc]initWithFrame:CGRectMake(newFrame.origin.x, CGRectGetMaxY(newFrame)+5, CGRectGetWidth(self.frame), (_data.count>3?6:_data.count)*30 ) style:UITableViewStylePlain];
		self.popTableView.layer.cornerRadius = 5;
		self.popTableView.layer.masksToBounds = YES;
		self.popTableView.delegate = self;
		self.popTableView.separatorColor = [UIColor whiteColor];
		self.popTableView.dataSource = self;
		self.popTableView.estimatedRowHeight = 0;
		self.popTableView.estimatedSectionHeaderHeight = 0;
		self.popTableView.estimatedSectionFooterHeight = 0;
		[[UIApplication sharedApplication].delegate.window addSubview:_popTableView];
		
	}
}

- (void)tapDiss:(UIGestureRecognizer*)gesture{
	[_cover removeFromSuperview];
	[self.popTableView removeFromSuperview];
	_cover = nil;
	self.popTableView = nil;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.values.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [UITableViewCell new];
	cell.textLabel.font = [UIFont systemFontOfSize:13];
	cell.textLabel.text = self.values[indexPath.row];
	UILabel *seperatorline = [UILabel new];
	seperatorline.backgroundColor = RGB(222, 222, 222);
	[cell.contentView addSubview:seperatorline];
	[seperatorline mas_makeConstraints:^(MASConstraintMaker *make) {
		
	}];
	
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 30;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	self.value.text = self.values[indexPath.row];
	if (self.choiceblock) {
		self.choiceblock(self.value.text,(int)self.tag,indexPath.row);
	}
	[_cover removeFromSuperview];
	[self.popTableView removeFromSuperview];
	_cover = nil;
	self.popTableView = nil;

}


@end
