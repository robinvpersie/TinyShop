//
//  CompanyAuthController.m
//  Portal
//
//  Created by 이정구 on 2018/3/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "CompanyAuthController.h"
#import "Masonry.h"
#import "InputFieldView.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>
#include <CommonCrypto/CommonDigest.h>
@interface CompanyAuthController ()

@property (nonatomic, strong) TPKeyboardAvoidingScrollView * scrollView;
@property (nonatomic, strong) InputFieldView * input1;
@property (nonatomic, strong) InputFieldView * input2;
@property (nonatomic, strong) InputFieldView * input3;
@property (nonatomic, strong) InputFieldView * input4;
@property (nonatomic, strong) InputFieldView * input5;
@property (nonatomic, strong) InputFieldView * input6;
@property (nonatomic, strong) InputFieldView * input7;
@property (nonatomic, strong) InputFieldView * input8;
@property (nonatomic, strong) InputFieldView * input9;
@property (nonatomic, strong) InputFieldView * input10;
@property (nonatomic, strong) InputFieldView * input11;
@property (nonatomic, strong) InputFieldView * input12;
@property (nonatomic, strong) InputFieldView * input13;
@property (nonatomic, strong) InputFieldView * input14;
@property (nonatomic, strong) InputFieldView * input15;
@property (nonatomic, strong) InputFieldView * input16;

@end

@implementation CompanyAuthController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage: [[UIImage imageNamed:@"icon_02_01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain
     target:self action:@selector(goBack)];
    
    [self makeUI];
    
    
   
}

-(void)goBack {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

-(void)makeUI {
    
    self.scrollView = [[TPKeyboardAvoidingScrollView alloc]init];
//    if (@available(iOS 11.0, *)) {
//        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//
//    }
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
    
    self.input1 = [[InputFieldView alloc] init];
    self.input1.placeHolder = @"第一个输入框";
    self.input1.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview: self.input1];
    [self.input1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView).with.multipliedBy(0.85);
        make.height.equalTo(@45);
        make.top.equalTo(self.scrollView).offset(20);
    }];
    
    self.input2 = [[InputFieldView alloc] init];
    self.input2.placeHolder = @"第二个输入框";
    self.input2.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.input2];
    [self.input2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.height.equalTo(self.input1);
        make.top.equalTo(self.input1.mas_bottom).with.offset(10);
    }];
    
    self.input3 = [[InputFieldView alloc]init];
    self.input3.placeHolder = @"第三个输入框";
    self.input3.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.input3];
    [self.input3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.height.equalTo(self.input1);
        make.top.equalTo(self.input2.mas_bottom).with.offset(10);
    }];
    
    self.input4 = [[InputFieldView alloc]init];
    self.input4.placeHolder = @"第四个输入框";
    self.input4.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.input4];
    [self.input4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.height.equalTo(self.input1);
        make.top.equalTo(self.input3.mas_bottom).with.offset(10);
    }];

    self.input5 = [[InputFieldView alloc]init];
    self.input5.placeHolder = @"第五个输入框";
    self.input5.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.input5];

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"假假按揭" forState:UIControlStateNormal];
    btn.backgroundColor = RGB(28, 141, 36);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:btn];

    [self.input5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.height.equalTo(self.input1);
        make.top.equalTo(self.input4.mas_bottom).with.offset(10);
        make.width.equalTo(btn);
    }];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.input5.mas_trailing).with.offset(5);
        make.width.height.equalTo(self.input5);
        make.trailing.equalTo(self.input1);
        make.top.equalTo(self.input4.mas_bottom).with.offset(10);
    }];

    self.input6 = [[InputFieldView alloc] init];
    self.input6.placeHolder = @"第六个输入框";
    self.input6.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.input6];
    [self.input6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.height.equalTo(self.input1);
        make.top.equalTo(self.input5.mas_bottom).with.offset(10);
    }];

    self.input7 = [[InputFieldView alloc]init];
    self.input7.placeHolder = @"第七个输入框";
    self.input7.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.input7];
    [self.input7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.height.equalTo(self.input1);
        make.top.equalTo(self.input6.mas_bottom).with.offset(10);
    }];

    UILabel *lb = [[UILabel alloc]init];
    lb.text = @"哈哈哈哈";
    lb.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.input1);
        make.top.equalTo(self.input7.mas_bottom).with.offset(10);
    }];

    self.input8 = [[InputFieldView alloc] init];
    self.input8.placeHolder = @"第8个输入框";
    self.input8.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.input8];
    [self.input8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.height.equalTo(self.input1);
        make.top.equalTo(lb.mas_bottom).with.offset(10);
    }];

    self.input9 = [[InputFieldView alloc] init];
    self.input9.placeHolder = @"第九个输入框";
    self.input9.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.input9];
    [self.input9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.height.equalTo(self.input1);
        make.top.equalTo(self.input8.mas_bottom).with.offset(10);
    }];

    self.input10 = [[InputFieldView alloc] init];
    self.input10.placeHolder = @"第十个输入框";
    self.input10.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.input10];
    [self.input10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.height.equalTo(self.input1);
        make.top.equalTo(self.input9.mas_bottom).with.offset(10);
    }];

    self.input11 = [[InputFieldView alloc] init];
    self.input11.placeHolder = @"第十一个输入框";
    self.input11.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.input11];
    [self.input11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.height.equalTo(self.input1);
        make.top.equalTo(self.input10.mas_bottom).with.offset(10);
    }];

    self.input12 = [[InputFieldView alloc] init];
    self.input12.placeHolder = @"第十二个输入框";
    self.input12.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.input12];
    [self.input12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.height.equalTo(self.input1);
        make.top.equalTo(self.input11.mas_bottom).with.offset(10);
    }];

    self.input13 = [[InputFieldView alloc] init];
    self.input13.placeHolder = @"第十三个输入框";
    self.input13.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.input13];
    
    UIButton * btn13 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn13 addTarget:self action:@selector(btn13) forControlEvents:UIControlEventTouchUpInside];
    [btn13 setTitle:@"按钮13" forState:UIControlStateNormal];
    [btn13 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn13.titleLabel.font = [UIFont systemFontOfSize:14];
    btn13.backgroundColor = RGB(28, 141, 36);
    [self.scrollView addSubview:btn13];
    
    [self.input13 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.height.equalTo(self.input1);
        make.top.equalTo(self.input12.mas_bottom).with.offset(10);
    }];
    
    [btn13 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.input13.mas_trailing).with.offset(5);
        make.top.width.height.equalTo(self.input13);
        make.trailing.equalTo(self.input1);
    }];

    self.input14 = [[InputFieldView alloc] init];
    self.input14.placeHolder = @"第十四个输入框";
    self.input14.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.input14];
    [self.input14 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.height.width.equalTo(self.input1);
        make.top.equalTo(self.input13.mas_bottom).with.offset(10);
    }];

    self.input15 = [[InputFieldView alloc] init];
    self.input15.placeHolder = @"第十五个输入框";
    self.input15.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.input15];
    [self.input15 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.height.equalTo(self.input1);
        make.top.equalTo(self.input14.mas_bottom).with.offset(10);
    }];

    self.input16 = [[InputFieldView alloc] init];
    self.input16.placeHolder = @"第十六个输入框";
    self.input16.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.input16];
    [self.input16 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.height.equalTo(self.input1);
        make.top.equalTo(self.input15.mas_bottom).with.offset(10);
//        make.bottom.mas_equalTo(self.scrollView.mas_bottom);
    }];
//
    UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn setTitle:@"哈哈" forState:UIControlStateNormal];
    [bottomBtn setTintColor:[UIColor whiteColor]];
    bottomBtn.backgroundColor = RGB(28, 141, 36);
    [bottomBtn addTarget:self action:@selector(didBottom) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.height.equalTo(self.input1);
        make.top.equalTo(self.input16.mas_bottom).offset(10);
        make.bottom.equalTo(self.scrollView.mas_bottom).with.offset(-10);
    }];
    
    
}

-(void)btn13 {
    
}

-(void)didBottom {
	
	[KLHttpTool TinyResgisterwithPhone:[[NSUserDefaults standardUserDefaults] objectForKey:@"joinphone"] withmempwd:[self sha512:self.mempwd ] withnickname:self.nickname withemail:self.email witheAuthNum:[[NSUserDefaults standardUserDefaults] objectForKey:@"joinauthnum"] withcustom_name:self.custom_name withtop_zip_code:self.top_zip_code withtop_addr_head:self.top_addr_head withtop_addr_detail:self.top_addr_detail withbusiness_type:[[NSUserDefaults standardUserDefaults] objectForKey:@"joinKinds"] withlang_type:@"kor" withcomp_class:_input1.text withcomp_type:_input2.text  withcompany_num:_input3.text  withzip_code:_input4.text  withkor_addr:_input5.text  withkor_addr_detail:_input6.text  withtelephon:_input7.text  success:^(id response) {
		
		MBProgressHUD *hud12 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hud12.mode = MBProgressHUDModeText;
		
		if ([response[@"status"] intValue] == 1) {
			hud12.label.text = @"注册成功！";
			
		}else{
			
			hud12.label.text = response[@"msg"];
		}
		[hud12 hideAnimated:YES afterDelay:2];
	} failure:^(NSError *err) {
		
	} ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
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
