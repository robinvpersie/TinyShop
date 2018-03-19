//
//  StepOneMemEnrollController.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "StepOneMemEnrollController.h"

@interface StepOneMemEnrollController ()

@end

@implementation StepOneMemEnrollController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self createSubviews];
	[self setNaviLineColor:self withColor:RGB(124, 251, 232)];

}
- (void)createSubviews{
	self.title = @"회원가입";
	UIImageView *backImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
	backImg.frame = self.view.frame;
	backImg.backgroundColor = RGB(124, 251, 232);
	backImg.userInteractionEnabled = YES;
	[self.view addSubview:backImg];
	
	UILabel *phonetitle = [[UILabel alloc]initWithFrame:CGRectMake(40, 100, 200, 30)];
	phonetitle.text = @"휴대전화";
	phonetitle.font = [UIFont systemFontOfSize:14];
	[backImg addSubview: phonetitle];
	
	UIView *backview1 = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(phonetitle.frame), APPScreenWidth - 80, 40)];
	backview1.backgroundColor = [UIColor whiteColor];
	backview1.layer.cornerRadius = 5;
	backview1.layer.masksToBounds = YES;
	[backImg addSubview:backview1];
	
	UITextField *phonefield = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, CGRectGetWidth(backview1.frame)-45, 40)];
	phonefield.placeholder = @"010-1234-5678";
	[backview1 addSubview:phonefield];
	
	UIButton *phoneCheck = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phonefield.frame), 0, 40, 40)];
	[phoneCheck setImage:[UIImage imageNamed:@"icon_checkbox_default"] forState:UIControlStateNormal];
	[phoneCheck setImage:[UIImage imageNamed:@"icon_checkbox_green"] forState:UIControlStateSelected];
	[backview1 addSubview:phoneCheck];
	
	
	UILabel *pwdtitle = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(backview1.frame), 200, 30)];
	pwdtitle.text = @"인증번호";
	pwdtitle.font = [UIFont systemFontOfSize:14];
	[backImg addSubview:pwdtitle];
	
	UIView *backview2 = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(pwdtitle.frame), APPScreenWidth - 80, 40)];
	backview2.layer.cornerRadius = 5;
	backview2.layer.masksToBounds = YES;
	backview2.backgroundColor = [UIColor whiteColor];
	[backImg addSubview:backview2];
	
	UITextField *pwdfield = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, CGRectGetWidth(backview2.frame)-45, 40)];
	pwdfield.placeholder = @"1234";
	[backview2 addSubview:pwdfield];
	
	UIButton *pwdCheck = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pwdfield.frame), 0, 40, 40)];
	[pwdCheck setImage:[UIImage imageNamed:@"icon_checkbox_default"] forState:UIControlStateNormal];
	[pwdCheck setImage:[UIImage imageNamed:@"icon_checkbox_green"] forState:UIControlStateSelected];
	[backview2 addSubview:pwdCheck];
	
	
	UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(backview2.frame), CGRectGetMaxY(backview2.frame) +20, APPScreenWidth - 80, 40)];
	submitBtn.layer.cornerRadius = 5;
	submitBtn.layer.masksToBounds = YES;
	[submitBtn setBackgroundColor:RGB(33, 192, 67)];
	[submitBtn setTitle:@"다음" forState:UIControlStateNormal];
	[backImg addSubview:submitBtn];

	
	UIButton *forget = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth/2 -100, CGRectGetMaxY(submitBtn.frame) +20, 200, 40)];
	forget.layer.cornerRadius = 5;
	forget.layer.masksToBounds = YES;
	forget.titleLabel.font = [UIFont systemFontOfSize:14];
	[forget setTitle:@"인증번호 다시받기" forState:UIControlStateNormal];
	[forget setTitleColor:RGB(45, 45, 45) forState:UIControlStateNormal];
	[backImg addSubview:forget];
	
	
	
	

}

- (void)pop:(UIButton *)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}



@end
