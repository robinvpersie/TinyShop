//
//  ProtectItemsController.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "ProtectItemsController.h"
#import "StepOneMemEnrollController.h"
@interface ProtectItemsController (){
	NSArray*titleArray;
}

@property (nonatomic,retain)NSMutableArray *choiceBtnArray;

@property (nonatomic,retain)UIButton *allchoiceBtn;
@end

@implementation ProtectItemsController

- (void)viewDidLoad {
    [super viewDidLoad];

	[self createSubviews];
}

- (void)createSubviews{
	
	UIImageView *backImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clause_bg"]];
	backImg.userInteractionEnabled = YES;
	[self.view addSubview:backImg];
	[backImg mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	UIImageView *cancel = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_deleteone"]];
	cancel.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelaction:)];
	[cancel addGestureRecognizer:tap];
	[backImg addSubview:cancel];
	[cancel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.equalTo(@20);
		make.top.equalTo(@30);
		make.trailing.mas_equalTo(-15);
	}];
	
	//disgreeItem
	UILabel *titleLab = [UILabel new];
	titleLab.text = @"어서오세요";
	titleLab.font = [UIFont systemFontOfSize:20];
	titleLab.textColor = [UIColor whiteColor];
	[backImg addSubview:titleLab];
	[titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(APPScreenHeight *0.4);
		make.leading.mas_equalTo(15);
		make.height.mas_equalTo(30);
	}];
	
	UILabel *allChoiceLab = [UILabel new];
	allChoiceLab.text = @"약관동의가 필요합니다 ";
	allChoiceLab.font = [UIFont systemFontOfSize:20];
	allChoiceLab.textColor = [UIColor whiteColor];
	[backImg addSubview:allChoiceLab];
	[allChoiceLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(titleLab.mas_bottom);
		make.height.equalTo(@30);
		make.leading.equalTo(titleLab.mas_leading);
	}];
	
	self.allchoiceBtn = [UIButton new];
	[self.allchoiceBtn setImage:[UIImage imageNamed:@"btn_all_ok_default"] forState:UIControlStateNormal];
	[self.allchoiceBtn setImage:[UIImage imageNamed:@"btn_all_ok_activation"] forState:UIControlStateSelected];
	[self.allchoiceBtn addTarget:self action:@selector(allchoiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:self.allchoiceBtn];
	[self.allchoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(30);
		make.trailing.mas_equalTo(-15);
		make.top.equalTo(allChoiceLab.mas_top);
		
	}];
	
	UILabel *butonTitleLab = [UILabel new];
	butonTitleLab.text = @"전체동의";
	butonTitleLab.textAlignment = NSTextAlignmentRight;
	butonTitleLab.font = [UIFont systemFontOfSize:12];
	butonTitleLab.textColor = RGB(235, 235, 235);
	[backImg addSubview:butonTitleLab];
	[butonTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@30);
		make.top.equalTo(allChoiceLab.mas_top);
		make.trailing.equalTo(self.allchoiceBtn.mas_leading).offset(-4);
	}];

	titleArray = @[@"함께가게 이용약관(필수)",@"전자금융거래 이용약관 동의(필수)",@"개인정보수집 및 이용에 대한 안내(필수)",@"만14세이상고객만가입가능합니다.",@"다음으로"];
	
	const double w1 = [self getStringWidth:titleArray.firstObject]+5;
	UIButton *item1 = [self bottomLinebutton:titleArray.firstObject withFrame:CGRectZero];
	item1.tag = 5;
	[item1 addTarget:self action:@selector(rulesAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview: item1];
	[item1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(@15);
		make.top.equalTo(allChoiceLab.mas_bottom);
		make.width.mas_equalTo(w1);
		make.height.mas_equalTo(30);
		
	}];
	
	UIButton *check1 = [UIButton new];
	[check1 setImage:[UIImage imageNamed:@"icon_checkbox_default"] forState:UIControlStateNormal];
	[check1 setImage:[UIImage imageNamed:@"icon_checkbox_green"] forState:UIControlStateSelected];
	[check1 addTarget:self action:@selector(SinglechoiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:check1];
	[check1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.equalTo(@30);
		make.trailing.mas_equalTo(-15);
		make.top.equalTo(item1.mas_top);
	}];
	
	const double w2 = [self getStringWidth:titleArray[1]]+5;
	UIButton *item2 = [self bottomLinebutton:titleArray[1] withFrame:CGRectZero];
	[item2 addTarget:self action:@selector(rulesAction:) forControlEvents:UIControlEventTouchUpInside];
	item2.tag = 4;
	[backImg addSubview: item2];
	[item2 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(@15);
		make.top.equalTo(item1.mas_bottom);
		make.width.mas_equalTo(w2);
		make.height.mas_equalTo(30);
		
	}];
	
	UIButton *check2 = [UIButton new];
	[check2 setImage:[UIImage imageNamed:@"icon_checkbox_default"] forState:UIControlStateNormal];
	[check2 setImage:[UIImage imageNamed:@"icon_checkbox_green"] forState:UIControlStateSelected];
	[check2 addTarget:self action:@selector(SinglechoiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:check2];
	[check2 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.equalTo(@30);
		make.trailing.mas_equalTo(-15);
		make.top.equalTo(item2.mas_top);
	}];

	const double w3 = [self getStringWidth:titleArray[2]]+5;
	UIButton *item3 = [self bottomLinebutton:titleArray[2] withFrame:CGRectZero];
	item3.tag = 2;
	[item3 addTarget:self action:@selector(rulesAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:item3];
	[item3 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(@15);
		make.top.equalTo(item2.mas_bottom);
		make.width.mas_equalTo(w3);
		make.height.mas_equalTo(30);

	}];

	UIButton *check3 = [UIButton new];
	[check3 setImage:[UIImage imageNamed:@"icon_checkbox_default"] forState:UIControlStateNormal];
	[check3 setImage:[UIImage imageNamed:@"icon_checkbox_green"] forState:UIControlStateSelected];
	[check3 addTarget:self action:@selector(SinglechoiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:check3];
	[check3 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.equalTo(@30);
		make.trailing.mas_equalTo(-15);
		make.top.equalTo(item3.mas_top);
	}];
	
//	const double w4 = [self getStringWidth:titleArray[3]] + 5;
//	UIButton *item4 = [self bottomLinebutton:titleArray[3] withFrame:CGRectZero];
//	item4.tag = 4;
//	[item4 addTarget:self action:@selector(rulesAction:) forControlEvents:UIControlEventTouchUpInside];
//	[backImg addSubview:item4];
//	[item4 mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.leading.equalTo(@15);
//		make.top.equalTo(item3.mas_bottom);
//		make.width.mas_equalTo(w4);
//		make.height.mas_equalTo(30);
//	}];
//
//	UIButton *check4 = [UIButton new];
//	[check4 setImage:[UIImage imageNamed:@"icon_checkbox_default"] forState:UIControlStateNormal];
//	[check4 setImage:[UIImage imageNamed:@"icon_checkbox_green"] forState:UIControlStateSelected];
//	[check4 addTarget:self action:@selector(SinglechoiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//	[backImg addSubview:check4];
//	[check4 mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.width.height.equalTo(@30);
//		make.trailing.mas_equalTo(-15);
//		make.top.equalTo(item4.mas_top);
//	}];
	
//	UILabel *lastlabel = [UILabel new];
//	lastlabel.text = titleArray[3];
//	lastlabel.font = [UIFont systemFontOfSize:13];
//	lastlabel.textColor = [UIColor whiteColor];
//	[backImg addSubview:lastlabel];
//	[lastlabel mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.leading.mas_equalTo(15);
//		make.top.equalTo(item3.mas_bottom);
//		make.height.equalTo(@30);
//	}];
	
//	UILabel *lastlabel1 = [UILabel new];
//	lastlabel1.text = titleArray[3];
//	lastlabel1.font = [UIFont systemFontOfSize:13];
//	lastlabel1.textColor = [UIColor whiteColor];
//	[backImg addSubview:lastlabel1];
//	[lastlabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.leading.mas_equalTo(15);
//		make.top.equalTo(lastlabel.mas_bottom);
//		make.height.equalTo(@20);
//	}];

	
	UIButton *enterBtn = [UIButton new];
	[enterBtn setImage:[UIImage imageNamed:@"btn_next_activation"] forState:UIControlStateNormal];
	[enterBtn addTarget:self action:@selector(enterBtn:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:enterBtn];
	[enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.width.equalTo(@30);
		make.trailing.mas_equalTo(-15);
		make.bottom.mas_equalTo(-40);
	}];
	
	UILabel *enterlabel = [UILabel new];
	enterlabel.text = titleArray.lastObject;
	enterlabel.textAlignment = NSTextAlignmentRight;
	enterlabel.textColor = RGB(232, 232, 232);
	[backImg addSubview:enterlabel];
	[enterlabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.equalTo(enterBtn.mas_leading).offset(-5);
		make.top.equalTo(enterBtn.mas_top);
		make.bottom.equalTo(enterBtn.mas_bottom);
	}];

	self.choiceBtnArray = @[check1,check2,check3].mutableCopy;


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
		hud1.label.text = NSLocalizedString(@"全部同意", nil);
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

- (void)rulesAction:(UIButton*)sender{
	NSString *loadurl = [NSString stringWithFormat:@"http://www.gigawon.co.kr:1314/CS2/CS%d0?%@", (int)sender.tag,@"nsukey=QBKUVmy8o2zJyFtOXCvCcd0lYWd8bZZWbwpjmDwN%2BFnIpbBYujuecZ94LBXLgc3dEQgcNPuBrsrjtup5moLzeaGCdh57CUcRip%2BXGB0Dtd42eeeR6wn0jS2hwKcZvOkBLEKI%2BVRNFUAb%2FSYeCU99miBvNgqNFYIEz%2Bc68FJU3nbAAmBapjI9rv91lJYL4wP0eEu5KKL5aKuSB7YVuAPgPQ%3D%3D"];
	WebRulesViewController *rulevc = [WebRulesViewController new];
	UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:rulevc];
	[rulevc loadRulesWebWithLoadurl:loadurl];
//	rulevc.title = titleArray[(int)sender.tag-1];
	[self presentViewController:navi animated:YES completion:nil];
	

}

- (double )getStringWidth:(NSString *)content{
	NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
	CGSize contentSize = [content boundingRectWithSize:CGSizeMake(MAXFLOAT,30) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

	return contentSize.width;
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
	BOOL IsEnter = YES;
	for (UIButton *itemBtn in self.choiceBtnArray) {
		if (!itemBtn.selected) {
			
			IsEnter = NO;
			
		}
	}
	
	if (IsEnter) {
		self.allchoiceBtn.selected = YES;
	}else{
		self.allchoiceBtn.selected = NO;
	}

}

- (void)cancelaction:(UITapGestureRecognizer*)tap{
	
	[self dismissViewControllerAnimated:YES completion:nil];

}
@end
