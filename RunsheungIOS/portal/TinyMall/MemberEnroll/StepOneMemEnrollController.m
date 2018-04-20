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
@property (nonatomic, strong) UIButton *getVerfiyBtn;
@property (nonatomic, assign)int countNumber;
@property (nonatomic ,strong) NSTimer *timer;
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
	titleview.textAlignment = NSTextAlignmentCenter;
	self.navigationItem.titleView = titleview;
	
	UIImageView *backImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginbackView"]];
	backImg.userInteractionEnabled = YES;
	[self.view addSubview:backImg];
	[backImg mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	self.phoneInput = [[InputFieldView alloc] initWithFrame:CGRectMake(20, 100, APPScreenWidth- 40, 50)];
	self.phoneInput.placeHolder = NSLocalizedString(@"请输入您的手机号码", nil) ;
	self.phoneInput.font = [UIFont systemFontOfSize:14];
	[backImg addSubview: self.phoneInput];
	
	self.codeInput = [[InputFieldView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.phoneInput.frame), CGRectGetMaxY(self.phoneInput.frame)+15, APPScreenWidth- 180, 50)];
	self.codeInput.placeHolder = NSLocalizedString(@"请输入短信验证码", nil);
	self.codeInput.font = [UIFont systemFontOfSize:14];
	[backImg addSubview: self.codeInput];
	
	self.getVerfiyBtn = [UIButton new];
	[self.getVerfiyBtn setBackgroundColor:RGB(33, 192, 67)];
	[self.getVerfiyBtn setTitle:NSLocalizedString(@"接收验证码", nil)  forState:UIControlStateNormal];
	[self.getVerfiyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
	[self.getVerfiyBtn addTarget:self action:@selector(getVerfiyBtn:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:self.getVerfiyBtn];
	[self.getVerfiyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(self.codeInput.mas_height);
		make.top.mas_equalTo(self.codeInput.mas_top);
		make.trailing.mas_equalTo(-20);
		make.leading.mas_equalTo(self.codeInput.mas_trailing).offset(3);
		
	}];

	UIButton *submitBtn = [UIButton new];
	[submitBtn setBackgroundColor:RGB(33, 192, 67)];
	[submitBtn setTitle:@"다음" forState:UIControlStateNormal];
	[submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:submitBtn];
	[submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@50);
		make.leading.equalTo(self.phoneInput.mas_leading);
		make.trailing.equalTo(self.phoneInput.mas_trailing);
		make.top.equalTo(self.codeInput.mas_bottom).offset(20);
		
	}];
	

//	UIButton *forget = [UIButton new];
//	forget.layer.cornerRadius = 5;
//	forget.layer.masksToBounds = YES;
//	forget.titleLabel.font = [UIFont systemFontOfSize:14];
//	[forget setTitle:@"인증번호 다시받기" forState:UIControlStateNormal];
//	[forget setTitleColor:RGB(254, 254, 254) forState:UIControlStateNormal];
//	[backImg addSubview:forget];
//	[forget mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.height.equalTo(@40);
//		make.height.equalTo(@100);
//		make.top.equalTo(submitBtn.mas_bottom).offset(20);
//		make.centerX.equalTo(submitBtn.mas_centerX);
//	}];
	

}

- (void)submitAction:(UIButton *)sender{
	if (self.phoneInput.text.length && self.codeInput.text.length) {
		StepSecMemEnrollController *step1 = [StepSecMemEnrollController new];
		SetUserDefault(@"joinphone", self.phoneInput.text);
		SetUserDefault(@"joinauthnum", self.codeInput.text);
		UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:step1];
		
		[self presentViewController:navi animated:YES completion:nil];

	}else{
		MBProgressHUD *hudview = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hudview.mode = MBProgressHUDModeText;
		hudview.label.text = NSLocalizedString(@"填写完整资料进入下一步", nil);
		[hudview hideAnimated:YES afterDelay:2.f];
	}

	
	
}

- (void)getVerfiyBtn:(UIButton*)sender{
	if (self.phoneInput.text.length) {
		[KLHttpTool TinySMSloginWithPhone:self.phoneInput.text Success:^(id response) {
			if ([response[@"status"] intValue] == 1) {
				
				self.countNumber = 60;
				_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reverseCount) userInfo:nil  repeats:YES];
				[_timer fireDate];
				[self.getVerfiyBtn setTitle:[NSString stringWithFormat:@"%@%ds",NSLocalizedString(@"还剩", nil),self.countNumber] forState:UIControlStateNormal];
			}
			
		} failure:^(NSError *err) {
			
		}];

	}else{
		MBProgressHUD*code = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		code.mode = MBProgressHUDModeText;
		code.label.text = NSLocalizedString(@"请输入您的手机号码", nil);
		[code hideAnimated:YES afterDelay:1.2f];
	}

}

- (void)reverseCount{
	if (_countNumber > 1) {
		--_countNumber ;
		[self.getVerfiyBtn setTitle:[NSString stringWithFormat:@"%@%ds",NSLocalizedString(@"还剩", nil),self.countNumber] forState:UIControlStateNormal];
		
	}else {
		[self.getVerfiyBtn setTitle:NSLocalizedString(@"接收验证码", nil) forState:UIControlStateNormal];
		[_timer invalidate];
	}
}

- (void)pop:(UIButton *)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}



@end
