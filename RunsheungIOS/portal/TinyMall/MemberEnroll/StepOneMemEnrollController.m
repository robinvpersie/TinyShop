//
//  StepOneMemEnrollController.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "StepOneMemEnrollController.h"
#import "StepSecMemEnrollController.h"

@interface StepOneMemEnrollController ()
{
	UITextField *pwdfield;
	UITextField *phonefield;
}
@end

@implementation StepOneMemEnrollController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self createSubviews];
	[self setNaviLineColor:self withColor:RGB(124, 251, 232)];

}
- (void)createSubviews{
	self.title = @"회원가입";
	UIImageView *backImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginbackView"]];
	backImg.frame = self.view.frame;
	backImg.userInteractionEnabled = YES;
	[self.view addSubview:backImg];
	
	UILabel *phonetitle = [[UILabel alloc]initWithFrame:CGRectMake(40, 100, 200, 30)];
	phonetitle.text = @"휴대전화";
	phonetitle.font = [UIFont systemFontOfSize:14];
	[backImg addSubview: phonetitle];
	
	UIView *backview1 = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(phonetitle.frame), APPScreenWidth - 80, 40)];
	backview1.backgroundColor = [UIColor whiteColor];
	[backImg addSubview:backview1];
	
	phonefield = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, CGRectGetWidth(backview1.frame)-45, 40)];
	phonefield.placeholder = @"010-1234-5678";
	[backview1 addSubview:phonefield];
	
	UIButton *phoneCheck = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phonefield.frame), 0, 40, 40)];
	[phoneCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateNormal];
	[phoneCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateSelected];
	[backview1 addSubview:phoneCheck];
	
	
	UILabel *pwdtitle = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(backview1.frame), 200, 30)];
	pwdtitle.text = @"인증번호";
	pwdtitle.font = [UIFont systemFontOfSize:14];
	[backImg addSubview:pwdtitle];
	
	UIView *backview2 = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(pwdtitle.frame), APPScreenWidth - 80, 40)];
	backview2.backgroundColor = [UIColor whiteColor];
	[backImg addSubview:backview2];
	
	pwdfield = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, CGRectGetWidth(backview2.frame)-45, 40)];
	pwdfield.placeholder = @"1234";
	[backview2 addSubview:pwdfield];
	
	UIButton *pwdCheck = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pwdfield.frame), 0, 40, 40)];
	[pwdCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateNormal];
	[pwdCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateSelected];
	[backview2 addSubview:pwdCheck];
	
	
	UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(backview2.frame), CGRectGetMaxY(backview2.frame) +20, APPScreenWidth - 80, 40)];
	submitBtn.layer.cornerRadius = 5;
	submitBtn.layer.masksToBounds = YES;
	[submitBtn setBackgroundColor:RGB(33, 192, 67)];
	[submitBtn setTitle:@"다음" forState:UIControlStateNormal];
	[submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:submitBtn];
	

	UIButton *forget = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth/2 -100, CGRectGetMaxY(submitBtn.frame) +20, 200, 40)];
	forget.layer.cornerRadius = 5;
	forget.layer.masksToBounds = YES;
	forget.titleLabel.font = [UIFont systemFontOfSize:14];
	[forget setTitle:@"인증번호 다시받기" forState:UIControlStateNormal];
	[forget setTitleColor:RGB(45, 45, 45) forState:UIControlStateNormal];
	[backImg addSubview:forget];
	

}

- (void)submitAction:(UIButton *)sender{
	
	StepSecMemEnrollController *step1 = [StepSecMemEnrollController new];
	[[NSUserDefaults standardUserDefaults]setObject:phonefield.text forKey:@"joinphone"];
	[[NSUserDefaults standardUserDefaults]setObject:pwdfield.text forKey:@"joinauthnum"];
	UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:step1];
	
	[self presentViewController:navi animated:YES completion:nil];
	
}

- (void)pop:(UIButton *)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}



@end
