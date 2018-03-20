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
	NSArray *titleData;
}

- (instancetype)initWithFrame:(CGRect)frame withBtntitles:(NSArray*)titles{
	self = [super initWithFrame:frame];
	if (self) {
		titleData = titles;
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

	maskView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].delegate.window.bounds];
	maskView.alpha = 0.4f;
	maskView.backgroundColor = [UIColor blackColor];
	[[UIApplication sharedApplication].delegate.window addSubview:maskView];
	[[UIApplication sharedApplication].delegate.window addSubview:self];
	
	UIButton*cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 20, 5, 14, 14)];
	[cancelBtn setImage:[UIImage imageNamed:@"icon_deleteone"] forState:UIControlStateNormal];
	[cancelBtn addTarget:self action:@selector(cancelaction:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:cancelBtn];
	
	UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 24, self.frame.size.width, 150)];
	whiteView.backgroundColor = RGB(254, 254, 252);
	[self addSubview:whiteView];
	
	UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
	titleLab.backgroundColor = RGB(33, 192, 67);
	titleLab.textColor = RGB(254, 254, 254);
	titleLab.text = titleData.firstObject;
	titleLab.textAlignment = NSTextAlignmentCenter;
	[whiteView addSubview:titleLab];
	
	
	UIButton*signleBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab.frame)+40, 100, 35)];
	signleBtn.layer.cornerRadius = 4;
	signleBtn.tag = 1001;
	signleBtn.layer.masksToBounds = YES;
	[signleBtn setBackgroundColor:RGB(33, 192, 67)];
	[signleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[signleBtn setTitle:titleData[1] forState:UIControlStateNormal];
	[signleBtn addTarget:self action:@selector(choiceaction:) forControlEvents:UIControlEventTouchUpInside];
	[whiteView addSubview:signleBtn];


	UIButton*teamBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 120, CGRectGetMaxY(titleLab.frame)+40, 100, 35)];
	[teamBtn setTitle:titleData.lastObject forState:UIControlStateNormal];
	teamBtn.layer.cornerRadius = 4;
	teamBtn.tag = 1002;
	teamBtn.layer.masksToBounds = YES;
	[teamBtn setBackgroundColor:RGB(201	, 201, 201)];
	[teamBtn addTarget:self action:@selector(choiceaction:) forControlEvents:UIControlEventTouchUpInside];
	[teamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[whiteView addSubview:teamBtn];
	
}

- (void)choiceaction:(UIButton*)sender{
	[self hideSheetView];

	if ([self.delegate respondsToSelector:@selector(click: selfTag:)]) {
		[self.delegate click:(int)sender.tag selfTag:(int)self.tag];
	}
}

- (void)cancelaction:(UIButton*)sender{
	[self hideSheetView];
	
}
@end
