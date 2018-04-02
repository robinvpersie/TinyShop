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
		make.width.height.equalTo(@15);
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

	NSArray*titleArray = @[@"함께가게이용약관동의",@"전자금융거래이용약관동의",@"개인정보수집이용동의",@"마케팅정보메일,SMS수신동의(선택)",@"만14세이상고객만가입가능합니다.",@"다음으로"];
	
	const double w1 = [self getStringWidth:titleArray.firstObject];
	UIButton *item1 = [self bottomLinebutton:titleArray.firstObject withFrame:CGRectZero];
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
	
	const double w2 = [self getStringWidth:titleArray[1]];
	UIButton *item2 = [self bottomLinebutton:titleArray[1] withFrame:CGRectZero];
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

	const double w3 = [self getStringWidth:titleArray[2]];
	UIButton *item3 = [self bottomLinebutton:titleArray[2] withFrame:CGRectZero];
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
	
	UILabel *item4 = [UILabel new];
	item4.text = titleArray[3];
	item4.textColor  = [UIColor whiteColor];
	[item4 setFont:[UIFont systemFontOfSize:13]];
	[backImg addSubview:item4];
	[item4 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(@15);
		make.top.equalTo(item3.mas_bottom);
		make.width.mas_equalTo(200);
		make.height.mas_equalTo(30);
		
	}];
	
	UIButton *check4 = [UIButton new];
	[check4 setImage:[UIImage imageNamed:@"icon_checkbox_default"] forState:UIControlStateNormal];
	[check4 setImage:[UIImage imageNamed:@"icon_checkbox_green"] forState:UIControlStateSelected];
	[check4 addTarget:self action:@selector(SinglechoiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	[backImg addSubview:check4];
	[check4 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.equalTo(@30);
		make.trailing.mas_equalTo(-15);
		make.top.equalTo(item4.mas_top);
	}];
	
	UILabel *lastlabel = [UILabel new];
	lastlabel.text = titleArray[4];
	lastlabel.font = [UIFont systemFontOfSize:13];
	lastlabel.textColor = [UIColor whiteColor];
	[backImg addSubview:lastlabel];
	[lastlabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(15);
		make.top.equalTo(item4.mas_bottom);
		make.height.equalTo(@30);
	}];
	
	
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
