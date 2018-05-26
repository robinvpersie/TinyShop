//
//  PopDomainInputView.m
//  Portal
//
//  Created by dlwpdlr on 2018/5/27.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "PopDomainInputView.h"

@implementation PopDomainInputView

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		self.fieldDatas = @[].mutableCopy;
		[self createSubviews];
	}
	return self;
}

- (void)createSubviews{
	
	if (self.coverView == nil) {
		self.coverView = [UIView new];
		self.coverView.backgroundColor = [UIColor blackColor];
		self.coverView.alpha = 0.3f;
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
		[self.coverView addGestureRecognizer:tap];
		[[UIApplication sharedApplication].delegate.window addSubview:self.coverView];
		[self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo([UIApplication sharedApplication].delegate.window);
		}];
	}
	self.layer.cornerRadius = 10;
	self.layer.masksToBounds = YES;
	self.backgroundColor = RGB(253, 253, 253);
	UILabel *title = [UILabel new];
	title.text = @"输入数字域名";
	title.textAlignment = NSTextAlignmentCenter;
	[self addSubview:title];
	[title mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(10);
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(30);
	}];
	
	NSArray*btns = @[@"取消",@"确认"];
	for (int i= 0;i<btns.count;i++) {
		UIButton *btn = [UIButton new];
		btn.layer.borderColor = RGB(221, 221, 221).CGColor;
		btn.layer.borderWidth = 1;
		btn.tag = i;
		[btn setTitleColor:RGB(45, 45, 45) forState:UIControlStateNormal];
		[btn setTitle:btns[i] forState:UIControlStateNormal];
		[self addSubview:btn];
		if (i == 1) {
			btn.backgroundColor = RGB(33, 192, 67);
		}
		[btn addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
		
		[btn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.mas_equalTo(i*(SCREEN_WIDTH/2.0 - 30));
			make.width.mas_equalTo(SCREEN_WIDTH/2.0 - 30);
			make.height.mas_equalTo(50);
			make.bottom.mas_equalTo(0);
		}];
	}
	
	
     	UIView *inputbg = [UIView new];
		[self addSubview:inputbg];
		[inputbg mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.mas_equalTo(SCREEN_WIDTH-120);
			make.height.mas_equalTo(40);
			make.top.mas_equalTo(80);
			make.leading.mas_equalTo(30);
		}];
	float wdis = (SCREEN_WIDTH-120)/5.0f;
	for (int i = 0;i<5;i++) {
		UITextField *field = [UITextField new];
		[self.fieldDatas addObject:field];
		field.textAlignment = NSTextAlignmentCenter;
		field.font = [UIFont systemFontOfSize:20];
		field.backgroundColor = RGB(242, 242, 242);
		[inputbg addSubview:field];
		[field mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.mas_equalTo(i*wdis);
			make.width.height.mas_equalTo(wdis - 5);
			make.top.mas_equalTo(0);
			
		}];
	}
}
- (void)click:(UITapGestureRecognizer*)tap{
	self.hidden = YES;
	[self removeFromSuperview];
	self.coverView.hidden = YES;
	[self.coverView removeFromSuperview];
	self.coverView = nil;

}
- (void)finishAction:(UIButton*)sender{
	
	self.hidden = YES;
	[self removeFromSuperview];
	self.coverView.hidden = YES;
	[self.coverView removeFromSuperview];
	self.coverView = nil;
	NSMutableArray *data = [NSMutableArray array];
	if ((int)sender.tag == 1) {
		for (int i = 0;i<self.fieldDatas.count;i++) {
			UITextField *field = self.fieldDatas[i];
			[data addObject:field.text];
		}
		if (self.submitblock) {
			self.submitblock(data);
		}
	}
	
	
}
@end
