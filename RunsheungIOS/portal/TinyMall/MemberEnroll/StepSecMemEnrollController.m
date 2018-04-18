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
#import "InputFieldView.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>

@interface StepSecMemEnrollController ()

@property (nonatomic, strong) TPKeyboardAvoidingScrollView * scrollView;
@property (nonatomic, strong) UIImageView * backImgView;

@property (nonatomic, strong) InputFieldView * nickinput;
@property (nonatomic, strong) InputFieldView * passwordinput;
@property (nonatomic, strong) InputFieldView * emailedinput;
@property (nonatomic, strong) InputFieldView * customernameinput;
@property (nonatomic, strong) InputFieldView * delegatecodeinput;
@property (nonatomic, strong) InputFieldView * delegatecityinput;
@property (nonatomic, strong) InputFieldView * delegateAddressinput;

@end

@implementation StepSecMemEnrollController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setNaviLineColor:self withColor:RGB(124, 251, 232)];
	[self createInputView];
	
}


- (void)createInputView{
	UILabel *titleview = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
	titleview.font = [UIFont systemFontOfSize:15];
	titleview.text = @"회원가입";
	titleview.textAlignment = NSTextAlignmentCenter;
	titleview.textColor = [UIColor whiteColor];
	self.navigationItem.titleView = titleview;

	self.scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectZero];
	[self.view addSubview:self.scrollView];
	[self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	self.backImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginbackView"]];
	UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBack:)];
	self.backImgView.userInteractionEnabled = YES;
	[self.backImgView addGestureRecognizer:taps];
	[self.scrollView addSubview:self.backImgView];
	[self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	self.nickinput = [[InputFieldView alloc] initWithFrame:CGRectMake(20, 80, APPScreenWidth- 40, 50)];
	self.nickinput.placeHolder = NSLocalizedString(@"请输入昵称", nil);
	self.nickinput.font = [UIFont systemFontOfSize:14];
	[self.scrollView addSubview: self.nickinput];
	
	self.passwordinput = [[InputFieldView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.nickinput.frame)+10, APPScreenWidth- 40, 50)];
	self.passwordinput.placeHolder = NSLocalizedString(@"请输入密码", nil) ;
	self.passwordinput.secureEntry = YES;
	self.passwordinput.font = [UIFont systemFontOfSize:14];
	
	[self.scrollView addSubview: self.passwordinput];
	
	self.emailedinput = [[InputFieldView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.passwordinput.frame)+10, APPScreenWidth- 40, 50)];
	self.emailedinput.placeHolder =  NSLocalizedString(@"请输入电子邮件", nil);
	self.emailedinput.font = [UIFont systemFontOfSize:14];
	[self.scrollView addSubview: self.emailedinput];
	
	self.customernameinput = [[InputFieldView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.emailedinput.frame)+10, APPScreenWidth- 40, 50)];
	self.customernameinput.placeHolder =  NSLocalizedString(@"请输入顾客姓名", nil);
	self.customernameinput.font = [UIFont systemFontOfSize:14];
	[self.scrollView addSubview: self.customernameinput];
	
	self.delegatecodeinput = [[InputFieldView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.customernameinput.frame)+10, APPScreenWidth- 160, 50)];
	self.delegatecodeinput.enEdit = NO;
	self.delegatecodeinput.textcolor = RGB(169, 169, 169);
	self.delegatecodeinput.placeHolder =  NSLocalizedString(@"请输入代理编码", nil);
	self.delegatecodeinput.font = [UIFont systemFontOfSize:14];
	[self.scrollView addSubview: self.delegatecodeinput];
	
	UIButton *findAddressBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.delegatecodeinput.frame)+3, CGRectGetMinY(self.delegatecodeinput.frame), APPScreenWidth - CGRectGetMaxX(self.delegatecodeinput.frame)-23, 50)];
	[findAddressBtn setBackgroundColor:RGB(33, 192, 67)];
	[findAddressBtn setTitle:NSLocalizedString(@"查找地址", nil)  forState:UIControlStateNormal];
	[findAddressBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
	[findAddressBtn addTarget:self action:@selector(findAddressBtn:) forControlEvents:UIControlEventTouchUpInside];
	[self.scrollView addSubview:findAddressBtn];
	
	self.delegatecityinput = [[InputFieldView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.delegatecodeinput.frame)+10, APPScreenWidth- 40, 50)];
	self.delegatecityinput.enEdit = NO;
	self.delegatecityinput.textcolor = RGB(169, 169, 169);
	self.delegatecityinput.placeHolder =  NSLocalizedString(@"请输入编码地址", nil);
	self.delegatecityinput.font = [UIFont systemFontOfSize:14];
	[self.scrollView addSubview: self.delegatecityinput];
	
	
	self.delegateAddressinput = [[InputFieldView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.delegatecityinput.frame)+10, APPScreenWidth- 40, 50)];
	self.delegateAddressinput.placeHolder = NSLocalizedString(@"请输入详细地址", nil);
	self.delegateAddressinput.font = [UIFont systemFontOfSize:14];
	[self.scrollView addSubview: self.delegateAddressinput];
	
	UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.delegateAddressinput.frame) +20, APPScreenWidth - 40, 50)];
	[submitBtn setBackgroundColor:RGB(33, 192, 67)];
	[submitBtn setTitle:@"다음" forState:UIControlStateNormal];
	[submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
	[self.scrollView addSubview:submitBtn];


	
}
- (void)tapBack:(UIGestureRecognizer*)tap{
	
	NSArray *imagesuvs = self.backImgView.subviews;
	for (UIView*suv in imagesuvs) {
		if ([suv isKindOfClass:[InputFieldView class]]) {
			[suv resignFirstResponder];
		}
	}

}

- (void)findAddressBtn:(UIButton*)sender{
	SearchKoreaAddress *search = [[SearchKoreaAddress alloc] init];
	search.selectAction = ^(KoreaPlaceModel * dic) {
        self.delegatecodeinput.text = dic.postcd;
		self.delegateAddressinput.text = dic.address;
	};
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:search];
	[self presentViewController:nav animated:YES completion:nil];

}

- (void)submitAction:(UIButton *)sender{
	NSString *joinkind = GetUserDefault(@"joinKinds");
	if (self.passwordinput.text.length && self.nickinput.text.length && self.nickinput.text.length && self.emailedinput.text.length && self.customernameinput.text.length && self.delegatecodeinput.text.length && self.delegatecityinput.text.length && self.delegateAddressinput.text.length) {
		
		if ([joinkind isEqualToString:@"1"]) {
			[KLHttpTool TinyResgisterwithPhone:GetUserDefault(@"joinphone")
                                    withmempwd:[self sha512:self.passwordinput.text ]
                                  withnickname:self.nickinput.text
                                     withemail:self.emailedinput.text
                                  witheAuthNum:GetUserDefault(@"joinauthnum")
                               withcustom_name:self.customernameinput.text
                              withtop_zip_code:self.delegatecodeinput.text
                             withtop_addr_head:self.delegatecityinput.text
                           withtop_addr_detail:self.delegateAddressinput.text
                             withbusiness_type:@"1"
                                 withlang_type:@"kor"
                                withcomp_class:nil
                                 withcomp_type:nil
                               withcompany_num:nil
                                  withzip_code:nil
                                  withkor_addr:nil
                           withkor_addr_detail:nil
                                  withtelephon:nil
                                       success:^(id response) {
				MBProgressHUD *hud12 = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
				hud12.mode = MBProgressHUDModeText;
				
				if ([response[@"status"] intValue] == 1) {
					hud12.label.text = NSLocalizedString(@"注册成功", nil);
					[self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
				}else{
					
					hud12.label.text = response[@"msg"];
				}
				[hud12 hideAnimated:YES afterDelay:2];
			} failure:^(NSError *err) {
				
			} ];
			
		} else {
			
			CompanyAuthController *vc = [CompanyAuthController new];
			vc.mempwd = self.passwordinput.text;
			vc.nickname = self.nickinput.text;
			vc.email = self.emailedinput.text;
			vc.custom_name = self.customernameinput.text;
			vc.top_zip_code = self.delegatecodeinput.text;
			vc.top_addr_head = self.delegatecityinput.text;
			vc.top_addr_detail = self.delegateAddressinput.text;
			UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
			[self presentViewController:navi animated:YES completion:nil];
			
		}

	}else{
		MBProgressHUD *hudview = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hudview.mode = MBProgressHUDModeText;
		hudview.label.text =  NSLocalizedString(@"填写完整资料进入下一步", nil);
		[hudview hideAnimated:YES afterDelay:2.f];
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

