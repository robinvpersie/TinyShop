//
//  TeamEnrollController.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "TeamEnrollController.h"
#import "EnrollSheetView.h"
@interface TeamEnrollController ()

@property (nonatomic,retain)EnrollSheetView *sheetView;
@end

@implementation TeamEnrollController

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self showAlert];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self initSuv];
	
}



#pragma mark -- 初始化
- (void)initSuv{
	self.title = @"회원가입";
	UIImageView *backImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
	backImg.frame = self.view.frame;
	backImg.userInteractionEnabled = YES;
	backImg.backgroundColor = RGB(132, 252, 232);
	[self.view addSubview:backImg];
	
	//设置导航栏背景图片为一个空的image，这样就透明了
	[self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
	
	UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(50, 100, APPScreenWidth - 100, 30)];
	title.text = @"회원 유형을 선택해 주세요";
	title.textAlignment = NSTextAlignmentCenter;
	[backImg addSubview:title];
	
	
	NSArray *imageS = @[@"icon_member01",@"icon_member02",@"icon_member03",@"icon_member04",@"icon_member05",@"icon_member06"];
	NSArray *title1S = @[@"개인회원",@"사업자 회원",@"생산자 회원",@"가맹점 회원",@"단체 회원",@"상품관리자 회원"];
	NSArray *title2S = @[@"회원 유형을 선택해 주세요",@"만 14세 이상 가입가능",@"사업자등록번호를 보유하고 있는 회원",@"생산업에 종사하고 있는 회원",@"회사 또는 학교, 동아리 등 단체 회원가입",@"상품을 관리하고 있는 회원"];
	for (int i =0; i<3; i++) {
		for (int j = 0; j< 2; j++) {
			UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20 +j*( APPScreenWidth/2.0f-10),CGRectGetMaxY(title.frame)+ 30+(APPScreenWidth/2.0f-30)*i , APPScreenWidth/2.0f-30, APPScreenWidth/2.0f-50 )];
			btn.backgroundColor = RGB(254, 254, 254);
			[backImg addSubview:btn];
			
			UIImageView *iconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageS[i*2+j]]];
			iconImg.frame = CGRectMake(3*CGRectGetWidth(btn.frame)/8.0f, CGRectGetWidth(btn.frame)/8, CGRectGetWidth(btn.frame)/4.0f, CGRectGetWidth(btn.frame)/4.0f);
			[btn addSubview:iconImg];
			
			UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImg.frame), CGRectGetWidth(btn.frame), 30)];
			title1.textAlignment =NSTextAlignmentCenter;
			title1.text = title1S[i*2+j];
			title1.font = [UIFont systemFontOfSize:15];
			[btn addSubview:title1];
			
			UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(title1.frame), CGRectGetWidth(btn.frame), 30)];
			title2.textAlignment =NSTextAlignmentCenter;
			title2.text = title2S[i*2+j];
			title2.font = [UIFont systemFontOfSize:10];
			title2.textColor = RGB(201, 201, 201);
			[btn addSubview:title2];

		}
	}
	


	
	
	
}

- (void)showAlert {
	if (self.sheetView == nil) {
		self.sheetView = [[EnrollSheetView alloc]initWithFrame:CGRectMake(50, APPScreenHeight/ 3.0f, APPScreenWidth - 100,  APPScreenHeight/ 3.0f)];
		
	}
	
}
- (void)pop:(UIButton *)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
