//
//  TSMemberEnrollView.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/17.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "TSMemberEnrollView.h"

@implementation TSMemberEnrollView

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		self.Sourcedata =@[@[@"icon_personal_sp",@"icon_enterprise_sp",@"icon_producer_sp",@"icon_team_sp",@"icon_store_sp",@"icon_manager_sp"],@[NSLocalizedString(@"个人会员", nil) ,NSLocalizedString(@"企业会员", nil),NSLocalizedString(@"生产者会员", nil),NSLocalizedString(@"团体会员", nil),NSLocalizedString(@"加盟商会员", nil),NSLocalizedString(@"管理者会员", nil)]];
		[self createSubView];
	}
	return self;
}

- (void)createSubView{
	NSArray *imageS = self.Sourcedata.firstObject;
	NSArray *titleS = self.Sourcedata.lastObject;
	

	for (int i =0; i<3; i++) {
		for (int j = 0; j<2; j++) {
			
			UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15+j*(self.frame.size.width/2), i*75, self.frame.size.width/2 - 30, 60)];
			btn.layer.borderColor = RGB(221, 221, 221).CGColor;
			btn.layer.borderWidth = 1;
			btn.layer.cornerRadius = 5;
			btn.layer.masksToBounds = YES;
			[btn setImage:[UIImage imageNamed:imageS[i*2+j]] forState:UIControlStateNormal];
			[btn setTitle:titleS[i*2+j] forState:UIControlStateNormal];
			[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			btn.tag = i*2+j;
			[btn addTarget:self action:@selector(clickaction:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:btn];

		}
	}
	
}

- (void)clickaction:(UIButton*)sender{
	if ([self.delegate respondsToSelector:@selector(ClickTSMemberDelegate: )]) {
		[self.delegate ClickTSMemberDelegate:(int)sender.tag];
	}
}
@end
