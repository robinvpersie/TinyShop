//
//  ProtectItemsController.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "ProtectItemsController.h"
#import "StepOneMemEnrollController.h"
@interface ProtectItemsController ()

@property (nonatomic,retain)NSMutableArray *choiceBtnArray;
@end

@implementation ProtectItemsController

- (void)viewDidLoad {
    [super viewDidLoad];

	[self createSubviews];
}

- (void)createSubviews{
	
	UIImageView *backImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clause_bg"]];
	backImg.frame = self.view.frame;
	backImg.userInteractionEnabled = YES;
	[self.view addSubview:backImg];
	
	UIImageView *cancel = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_deleteone"]];
	cancel.frame = CGRectMake(APPScreenWidth - 30,25, 14, 14);
	cancel.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelaction:)];
	[cancel addGestureRecognizer:tap];
	[backImg addSubview:cancel];
	
	//disgreeItem
	UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, APPScreenHeight *0.4, 200, 30)];
	titleLab.text = @"어서오세요";
	titleLab.font = [UIFont systemFontOfSize:20];
	titleLab.textColor = [UIColor whiteColor];
	[backImg addSubview:titleLab];
	
	UILabel *allChoiceLab = [[UILabel alloc]initWithFrame:CGRectMake(15, APPScreenHeight *0.4 +30, 200, 30)];
	allChoiceLab.text = @"약관동의가 필요합니다 ";
	allChoiceLab.font = [UIFont systemFontOfSize:20];
	allChoiceLab.textColor = [UIColor whiteColor];
	[backImg addSubview:allChoiceLab];
	
	UIButton *allchoiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth - 45, CGRectGetMinY(allChoiceLab.frame), 30, 30)];
	[allchoiceBtn setImage:[UIImage imageNamed:@"btn_all_ok_default"] forState:UIControlStateNormal];
	[allchoiceBtn setImage:[UIImage imageNamed:@"btn_all_ok_activation"] forState:UIControlStateSelected];
	[allchoiceBtn addTarget:self action:@selector(allchoiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:allchoiceBtn];
	
	UILabel *butonTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(allchoiceBtn.frame)-85, CGRectGetMinY(allChoiceLab.frame), 80, 30)];
	butonTitleLab.text = @"전체동의";
	butonTitleLab.textAlignment = NSTextAlignmentRight;
	butonTitleLab.font = [UIFont systemFontOfSize:12];
	butonTitleLab.textColor = RGB(235, 235, 235);
	[backImg addSubview:butonTitleLab];

	
	UIButton *item1 = [self bottomLinebutton:@"함께가게 이용약관 동의" withFrame:CGRectMake(15, CGRectGetMaxY(allChoiceLab.frame), 120, 30)];
	[backImg addSubview: item1];
	
	UIButton *check1 = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth - 45, CGRectGetMinY(item1.frame), 30, 30)];
	[check1 setImage:[UIImage imageNamed:@"icon_checkbox_default"] forState:UIControlStateNormal];
	[check1 setImage:[UIImage imageNamed:@"icon_checkbox_green"] forState:UIControlStateSelected];
	[check1 addTarget:self action:@selector(SinglechoiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:check1];
	
	
	UIButton *item2 = [self bottomLinebutton:@"전자금융거래 이용약관 동의" withFrame:CGRectMake(15, CGRectGetMaxY(item1.frame), 145, 30)];
	[backImg addSubview: item2];

	UIButton *check2 = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth - 45, CGRectGetMinY(item2.frame), 30, 30)];
	[check2 setImage:[UIImage imageNamed:@"icon_checkbox_default"] forState:UIControlStateNormal];
	[check2 setImage:[UIImage imageNamed:@"icon_checkbox_green"] forState:UIControlStateSelected];
	[check2 addTarget:self action:@selector(SinglechoiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:check2];
	
	
	UIButton *item3 = [self bottomLinebutton:@"개인정보 수집 이용동의" withFrame:CGRectMake(15, CGRectGetMaxY(item2.frame), 125, 30)];
	[backImg addSubview: item3];
	
	UIButton *check3 = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth - 45, CGRectGetMinY(item3.frame), 30, 30)];
	[check3 setImage:[UIImage imageNamed:@"icon_checkbox_default"] forState:UIControlStateNormal];
	[check3 setImage:[UIImage imageNamed:@"icon_checkbox_green"] forState:UIControlStateSelected];
	[check3 addTarget:self action:@selector(SinglechoiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:check3];


	UIButton *item4 = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(item3.frame), 210, 30)];
	[item4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[item4 setTitle:@"마케팅 정보 메일, SMS 수신동의(선택)" forState:UIControlStateNormal];
	item4.titleLabel.font = [UIFont systemFontOfSize:13];
	[backImg addSubview:item4];
	
	UIButton *check4 = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth - 45, CGRectGetMinY(item4.frame), 30, 30)];
	[check4 setImage:[UIImage imageNamed:@"icon_checkbox_default"] forState:UIControlStateNormal];
	[check4 setImage:[UIImage imageNamed:@"icon_checkbox_green"] forState:UIControlStateSelected];
	[check4 addTarget:self action:@selector(SinglechoiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:check4];

	
	UILabel *lastlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(item4.frame), 200, 30)];
	lastlabel.text = @"만 14세 이상 고객만 가입 가능합니다.";
	lastlabel.textAlignment = NSTextAlignmentLeft;
	lastlabel.font = [UIFont systemFontOfSize:13];
	lastlabel.textColor = [UIColor whiteColor];
	[backImg addSubview:lastlabel];
	
	
	UIButton *enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth - 55,APPScreenHeight - 75, 40, 40)];
	[enterBtn setImage:[UIImage imageNamed:@"btn_next_activation"] forState:UIControlStateNormal];
	[enterBtn setImage:[UIImage imageNamed:@"btn_next_activation"] forState:UIControlStateSelected];
	[enterBtn addTarget:self action:@selector(enterBtn:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:enterBtn];

	UILabel *enterlabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(enterBtn.frame) - 100,APPScreenHeight - 70, 90, 30)];
	enterlabel.text = @"다음으로";
	enterlabel.textAlignment = NSTextAlignmentRight;
	enterlabel.textColor = RGB(232, 232, 232);
	[backImg addSubview:enterlabel];

	self.choiceBtnArray = @[check1,check2,check3,check4].mutableCopy;



}

- (void)enterBtn:(UIButton*)sender{
	BOOL IsEnter = YES;
	for (UIButton *itemBtn in self.choiceBtnArray) {
		if (!itemBtn.selected) {
			
			IsEnter = NO;
			
		}
	}
	if (IsEnter) {
		StepOneMemEnrollController *step1 = [StepOneMemEnrollController new];
		UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:step1];
		[self presentViewController:navi animated:YES completion:nil];
		
	}else{
		MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hud1.mode = MBProgressHUDModeText;
		hud1.labelText = @"请同意条款";
		[hud1 hideAnimated:YES afterDelay:2];
	}
}

//创建下滑些
-(UIButton*)bottomLinebutton:(NSString *)content withFrame:(CGRect)frame {
	
	UIButton *button = [[UIButton alloc]initWithFrame:frame];
	button.titleLabel.textAlignment = NSTextAlignmentLeft;
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitle:content forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont systemFontOfSize:13];
	NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:content];
	[tncString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:(NSRange){0,[tncString length]}];
	[tncString addAttribute:NSUnderlineColorAttributeName value:[UIColor whiteColor] range:(NSRange){0,[tncString length]}];
	[button setAttributedTitle:tncString forState:UIControlStateNormal];
	

	return button;
}



- (void)allchoiceBtnAction:(UIButton*)sender{
	sender.selected = !sender.selected;
	for (UIButton *itemBtn in self.choiceBtnArray) {
		if (sender.selected) {
			
			itemBtn.selected = YES;
		}else{
			itemBtn.selected = NO;
		}
	}
}

- (void)SinglechoiceBtnAction:(UIButton*)sender{
	sender.selected = !sender.selected;
}

- (void)cancelaction:(UITapGestureRecognizer*)tap{
	
	[self dismissViewControllerAnimated:YES completion:nil];

}
@end
