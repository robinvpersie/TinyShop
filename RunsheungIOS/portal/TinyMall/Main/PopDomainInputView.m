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
	title.text = @"디지털 도메인을 입력하다";
	title.textAlignment = NSTextAlignmentCenter;
	[self addSubview:title];
	[title mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(10);
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(30);
	}];
	
	NSArray*btns = @[@"취소",@"확인"];
	for (int i= 0;i<btns.count;i++) {
		
		UIButton *btn = [UIButton new];
		btn.layer.borderColor = RGB(221, 221, 221).CGColor;
		btn.layer.borderWidth = 1;
		btn.tag = i;
		[btn setTitleColor:RGB(45, 45, 45) forState:UIControlStateNormal];
		[btn setTitle:btns[i] forState:UIControlStateNormal];
		[self addSubview:btn];
		[btn addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];

		[btn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.mas_equalTo(i?i*(2*SCREEN_WIDTH/5.0-1):i*(2*SCREEN_WIDTH/5.0));
			make.width.mas_equalTo(2*SCREEN_WIDTH/5.0);
			make.height.mas_equalTo(SCREEN_WIDTH/8.0);
			make.bottom.mas_equalTo(0);
		}];
		
	}

	UIView *inputbg = [UIView new];
	[self addSubview:inputbg];
	[inputbg mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(23*SCREEN_WIDTH/35.0);
		make.height.mas_equalTo(SCREEN_WIDTH/8.0);
		make.top.mas_equalTo(3*SCREEN_WIDTH/16.0);
		make.leading.mas_equalTo(SCREEN_WIDTH/14.0);
	}];
	
	float wdis = 23*SCREEN_WIDTH/175.0;
	for (int i = 0;i<5;i++) {
		UITextField *field = [UITextField new];
		field.tag = i;
		if ((int)field.tag == 0) {
			[field becomeFirstResponder];
		}
		[self.fieldDatas addObject:field];
		field.textAlignment = NSTextAlignmentCenter;
		field.font = [UIFont systemFontOfSize:20];
		field.delegate = self;
		field.keyboardType = UIKeyboardTypeNumberPad;
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
#pragma mark-- UIFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	NSString *value = [NSString stringWithFormat:@"%@%@",textField.text,string];
	NSLog(@"tag:%d--text:%@--string:%@",(int)textField.tag,value,string);

	if (value.length > 3) {
		if ((int)textField.tag < 4) {
			UITextField *field = self.fieldDatas[(int)textField.tag +1];
			[field becomeFirstResponder];
		}
		return  NO;
	}
	return YES;
	
}
@end
