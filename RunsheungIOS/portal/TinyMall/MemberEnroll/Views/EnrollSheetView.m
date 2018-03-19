//
//  EnrollSheetView.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "EnrollSheetView.h"

@implementation EnrollSheetView{
	UIViewController *superController;
	UIView *maskView ;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		
		[self initUI];
		
	}
	return self;
}

- (void)showSheetView {
	[superController.view addSubview:self];
	
	
}

- (void)hideSheetView {
	[maskView removeFromSuperview];
	[self removeFromSuperview];
	
	
}

- (void)initUI{
	
	self.backgroundColor = [UIColor whiteColor];

	maskView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].delegate.window.bounds];
	maskView.alpha = 0.4f;
	maskView.backgroundColor = [UIColor blackColor];
	[[UIApplication sharedApplication].delegate.window addSubview:maskView];
	[[UIApplication sharedApplication].delegate.window addSubview:self];
	
	UIButton*cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 15, 5, 10, 10)];
	[cancelBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//	cancelBtn
	
}
@end
