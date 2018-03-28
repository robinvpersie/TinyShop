//
//  StepOneMemEnrollController.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "StepSecMemEnrollController.h"
#include <CommonCrypto/CommonDigest.h>
#import "CompanyAuthController.h"


@interface StepSecMemEnrollController (){
	UIImageView *backImg ;
	UITextField *phonefield;
	UITextField *pwdfield;
	UITextField *emailfield;
	UITextField *customerfield;
	UITextField *delegateCodefield;
	UITextField *delegateheadfield;
	UITextField *delegatedetiledfield;
	
}
@end

@implementation StepSecMemEnrollController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self createSubviews];
	[self setNaviLineColor:self withColor:RGB(124, 251, 232)];
	
}

- (void)tapBack:(UIGestureRecognizer*)tap{
	[phonefield resignFirstResponder];
	[pwdfield resignFirstResponder];
	[emailfield resignFirstResponder];
	[customerfield resignFirstResponder];
	[delegateCodefield resignFirstResponder];
	[delegateheadfield resignFirstResponder];
	[delegatedetiledfield resignFirstResponder];
	
}

- (void)createSubviews{
	self.title = @"회원가입";
	backImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginbackView"]];
	backImg.frame = self.view.frame;
	UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBack:)];
	backImg.userInteractionEnabled = YES;
	[backImg addGestureRecognizer:taps];
	backImg.userInteractionEnabled = YES;
	[self.view addSubview:backImg];
	
	//昵称
	UILabel *phonetitle = [[UILabel alloc]initWithFrame:CGRectMake(40, 100, 200, 25)];
	phonetitle.text = @"昵称";
	phonetitle.font = [UIFont systemFontOfSize:14];
	[backImg addSubview: phonetitle];
	
	UIView *backview1 = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(phonetitle.frame), APPScreenWidth - 80, 35)];
	backview1.backgroundColor = [UIColor whiteColor];
	[backImg addSubview:backview1];
	
	phonefield = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, CGRectGetWidth(backview1.frame)-45, 35)];
	phonefield.placeholder = @"昵称";
	[backview1 addSubview:phonefield];
	
	UIButton *phoneCheck = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phonefield.frame), 0, 40, 35)];
	[phoneCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateNormal];
	[phoneCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateSelected];
	[backview1 addSubview:phoneCheck];
	
	
	//密码
	UILabel *pwdtitle = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(backview1.frame), 200, 25)];
	pwdtitle.text = @"密码";
	pwdtitle.font = [UIFont systemFontOfSize:14];
	[backImg addSubview:pwdtitle];
	
	UIView *backview2 = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(pwdtitle.frame), APPScreenWidth - 80, 35)];
	backview2.backgroundColor = [UIColor whiteColor];
	[backImg addSubview:backview2];
	
	pwdfield = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, CGRectGetWidth(backview2.frame)-45, 35)];
	pwdfield.placeholder = @"密码";
	[backview2 addSubview:pwdfield];
	
	UIButton *pwdCheck = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pwdfield.frame), 0, 40, 35)];
	[pwdCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateNormal];
	[pwdCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateSelected];
	[backview2 addSubview:pwdCheck];
	
	
	//电子邮件
	UILabel *emailtitle = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(backview2.frame), 200, 25)];
	emailtitle.text = @"电子邮件";
	emailtitle.font = [UIFont systemFontOfSize:14];
	[backImg addSubview:emailtitle];
	
	UIView *backview4 = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(emailtitle.frame), APPScreenWidth - 80, 35)];
	backview4.backgroundColor = [UIColor whiteColor];
	[backImg addSubview:backview4];
	
	emailfield = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, CGRectGetWidth(backview4.frame)-45, 35)];
	emailfield.placeholder = @"电子邮件";
	[backview4 addSubview:emailfield];
	
	UIButton *emailCheck = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(emailfield.frame), 0, 40, 35)];
	[emailCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateNormal];
	[emailCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateSelected];
	[backview4 addSubview:emailCheck];
	
	//顾客名称
	UILabel *customertitle = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(backview4.frame), 200, 25)];
	customertitle.text = @"顾客名称";
	customertitle.font = [UIFont systemFontOfSize:14];
	[backImg addSubview:customertitle];
	
	UIView *backview5 = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(customertitle.frame), APPScreenWidth - 80, 35)];
	backview5.backgroundColor = [UIColor whiteColor];
	[backImg addSubview:backview5];
	
	customerfield = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, CGRectGetWidth(backview5.frame)-45, 35)];
	customerfield.placeholder = @"顾客名称";
	[backview5 addSubview:customerfield];
	
	UIButton *customerCheck = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(customerfield.frame), 0, 40, 35)];
	[customerCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateNormal];
	[customerCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateSelected];
	[backview5 addSubview:customerCheck];
	
	//代表人邮编
	UILabel *delegateCodetitle = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(backview5.frame), 200, 25)];
	delegateCodetitle.text = @"代表人邮编";
	delegateCodetitle.font = [UIFont systemFontOfSize:14];
	[backImg addSubview:delegateCodetitle];
	
	UIView *backview6 = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(delegateCodetitle.frame), APPScreenWidth - 80, 35)];
	backview6.backgroundColor = [UIColor whiteColor];
	[backImg addSubview:backview6];
	
	delegateCodefield = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, CGRectGetWidth(backview6.frame)-45, 35)];
	delegateCodefield.placeholder = @"代表人邮编";
	[backview6 addSubview:delegateCodefield];
	
	UIButton *delegateCodeCheck = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(delegateCodefield.frame), 0, 40, 35)];
	[delegateCodeCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateNormal];
	[delegateCodeCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateSelected];
	[backview6 addSubview:delegateCodeCheck];
	
	//代表人地址
	UILabel *delegateheadtitle = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(backview6.frame), 200, 25)];
	delegateheadtitle.text = @"代表人地址";
	delegateheadtitle.font = [UIFont systemFontOfSize:14];
	[backImg addSubview:delegateheadtitle];
	
	UIView *backview7 = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(delegateheadtitle.frame), APPScreenWidth - 80, 35)];
	backview7.backgroundColor = [UIColor whiteColor];
	[backImg addSubview:backview7];
	
	delegateheadfield = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, CGRectGetWidth(backview7.frame)-45, 35)];
	delegateheadfield.placeholder = @"代表人地址";
	[backview7 addSubview:delegateheadfield];
	
	UIButton *delegateheadCheck = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(delegateheadfield.frame), 0, 40, 35)];
	[delegateheadCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateNormal];
	[delegateheadCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateSelected];
	[backview7 addSubview:delegateheadCheck];
	
	//代表人详细地址
	UILabel*delegatedetailedtitle = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(backview7.frame), 200, 25)];
	delegatedetailedtitle.text = @"代表人详细地址";
	delegatedetailedtitle.font = [UIFont systemFontOfSize:14];
	[backImg addSubview:delegatedetailedtitle];
	
	UIView *backview8 = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(delegatedetailedtitle.frame), APPScreenWidth - 80, 35)];
	backview8.backgroundColor = [UIColor whiteColor];
	[backImg addSubview:backview8];
	
	delegatedetiledfield = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, CGRectGetWidth(backview8.frame)-45, 35)];
	delegatedetiledfield.placeholder = @"代表人详细地址";
	[backview8 addSubview:delegatedetiledfield];
	
	UIButton *delegatedetailedCheck = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(delegateheadfield.frame), 0, 40, 35)];
	[delegatedetailedCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateNormal];
	[delegatedetailedCheck setImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateSelected];
	[backview8 addSubview:delegatedetailedCheck];

	UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(backview8.frame), CGRectGetMaxY(backview8.frame) +20, APPScreenWidth - 80, 40)];
	[submitBtn setBackgroundColor:RGB(33, 192, 67)];
	[submitBtn setTitle:@"다음" forState:UIControlStateNormal];
	[submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:submitBtn];

	
	
}

- (void)submitAction:(UIButton *)sender{
	NSString *joinkind = [[NSUserDefaults standardUserDefaults]objectForKey:@"joinKinds"];
	
	if ([joinkind isEqualToString:@"0"]) {
		[KLHttpTool TinyResgisterwithPhone:[[NSUserDefaults standardUserDefaults] objectForKey:@"joinphone"] withmempwd:[self sha512:pwdfield.text ] withnickname:phonefield.text withemail:emailfield.text witheAuthNum:[[NSUserDefaults standardUserDefaults] objectForKey:@"joinauthnum"] withcustom_name:customerfield.text withtop_zip_code:delegateCodefield.text withtop_addr_head:delegateheadfield.text withtop_addr_detail:delegatedetiledfield.text withbusiness_type:@"1" withlang_type:@"kor" withcomp_class:nil withcomp_type:nil withcompany_num:nil withzip_code:nil withkor_addr:nil withkor_addr_detail:nil withtelephon:nil success:^(id response) {
			MBProgressHUD *hud12 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
			hud12.mode = MBProgressHUDModeText;
			
			if ([response[@"status"] intValue] == 1) {
				hud12.label.text = @"注册成功！";
				[self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
			}else{
				
				hud12.label.text = response[@"msg"];
			}
			[hud12 hideAnimated:YES afterDelay:2];
		} failure:^(NSError *err) {
			
		} ];

	} else {
	
		CompanyAuthController *vc = [CompanyAuthController new];
		vc.mempwd = pwdfield.text;
		vc.nickname = phonefield.text;
		vc.email = emailfield.text;
		vc.custom_name = customerfield.text;
		vc.top_zip_code = delegateCodefield.text;
		vc.top_addr_head = delegateheadfield.text;
		vc.top_addr_detail = delegatedetiledfield.text;
		UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
		
		[self presentViewController:navi animated:YES completion:nil];
		

	}
}

- (void)pop:(UIButton *)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString*)sha512:(NSString*)input {
	const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:input.length];
	
	uint8_t digest[CC_SHA512_DIGEST_LENGTH];
	
	CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
	
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
	
	for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
	
	return output;
	
}

@end

