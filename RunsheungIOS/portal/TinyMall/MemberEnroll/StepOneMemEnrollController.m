//
//  StepOneMemEnrollController.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "StepOneMemEnrollController.h"
#import "StepSecMemEnrollController.h"
#import "InputFieldView.h"


@interface StepOneMemEnrollController ()

@property (nonatomic, strong) InputFieldView * phoneInput;
@property (nonatomic, strong) InputFieldView * codeInput;
@end

@implementation StepOneMemEnrollController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self createSubviews];
	[self setNaviLineColor:self withColor:RGB(124, 251, 232)];

}
- (void)createSubviews{
	
	UILabel *titleview = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
	titleview.font = [UIFont systemFontOfSize:15];
	titleview.text = @"회원가입";
	titleview.textColor = [UIColor whiteColor];
	self.navigationItem.titleView = titleview;
	
	UIImageView *backImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginbackView"]];
	backImg.frame = self.view.frame;
	backImg.userInteractionEnabled = YES;
	[self.view addSubview:backImg];
	
	self.phoneInput = [[InputFieldView alloc] initWithFrame:CGRectMake(20, 100, APPScreenWidth- 40, 50)];
	self.phoneInput.placeHolder = NSLocalizedString(@"请输入您的手机号码", nil) ;
	self.phoneInput.font = [UIFont systemFontOfSize:14];
	[backImg addSubview: self.phoneInput];
	
	self.codeInput = [[InputFieldView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.phoneInput.frame), CGRectGetMaxY(self.phoneInput.frame)+15, APPScreenWidth- 180, 50)];
	self.codeInput.placeHolder = NSLocalizedString(@"请输入短信验证码", nil);
	self.codeInput.font = [UIFont systemFontOfSize:14];
	[backImg addSubview: self.codeInput];
	
	UIButton *getVerfiyBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.codeInput.frame)+3, CGRectGetMinY(self.codeInput.frame), APPScreenWidth - CGRectGetMaxX(self.codeInput.frame)-23, 50)];
	[getVerfiyBtn setBackgroundColor:RGB(33, 192, 67)];
	[getVerfiyBtn setTitle:NSLocalizedString(@"接收验证码", nil)  forState:UIControlStateNormal];
	[getVerfiyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
	[getVerfiyBtn addTarget:self action:@selector(getVerfiyBtn:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:getVerfiyBtn];

	
	UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.phoneInput.frame), CGRectGetMaxY(self.codeInput.frame) +20, APPScreenWidth - 40, 50)];
	[submitBtn setBackgroundColor:RGB(33, 192, 67)];
	[submitBtn setTitle:@"다음" forState:UIControlStateNormal];
	[submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:submitBtn];
	

	UIButton *forget = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth/2 -100, CGRectGetMaxY(submitBtn.frame) +20, 200, 40)];
	forget.layer.cornerRadius = 5;
	forget.layer.masksToBounds = YES;
	forget.titleLabel.font = [UIFont systemFontOfSize:14];
	[forget setTitle:@"인증번호 다시받기" forState:UIControlStateNormal];
	[forget setTitleColor:RGB(254, 254, 254) forState:UIControlStateNormal];
	[backImg addSubview:forget];
	

}

- (void)submitAction:(UIButton *)sender{
	
	StepSecMemEnrollController *step1 = [StepSecMemEnrollController new];
	SetUserDefault(@"joinphone", self.phoneInput.text);
	SetUserDefault(@"joinauthnum", self.codeInput.text);
	UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:step1];
	
	[self presentViewController:navi animated:YES completion:nil];
	
}

- (void)getVerfiyBtn:(UIButton*)sender{
	
}

- (void)pop:(UIButton *)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}



@end
