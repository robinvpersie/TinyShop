//
//  SearchIfView.m
//  Portal
//
//  Created by dlwpdlr on 2018/5/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "SearchIfView.h"
#import "arrowBtn.h"


@implementation SearchIfView

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
	}
	return self;
}
- (void)setDic:(NSDictionary *)dic{
	_dic = dic;
	self.resquestDic = [NSMutableDictionary new];
	self.datas = @[@[@{@"배달":_dic[@"dataDeli"]},@{@"위치":_dic[@"dataOrderBy"]},@{@"주문상품":_dic[@"dataLevel"]}],@[@{@"이벤트중":_dic[@"dataEvnt"]},@{@"상품권사용":_dic[@"dataVchr"]},@{@"검색":@[]}]];
	[self.resquestDic setObject:@"0" forKey:@"DeliveryCd"];
	[self.resquestDic setObject:@"1" forKey:@"order_by"];
	[self.resquestDic setObject:@"0" forKey:@"EventCd"];
	[self.resquestDic setObject:@"0" forKey:@"VoucherCd"];
	[self.resquestDic setObject:@"1" forKey:@"level1"];
	[self.resquestDic setObject:@"3" forKey:@"level2"];

	[self createSubviews];

}
- (void)createSubviews{
	UILabel *ifchoice = [UILabel new];
	ifchoice.text = @"조건검색";
	[self addSubview:ifchoice];
	[ifchoice mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.height.mas_equalTo(15);
	}];
	NSArray *first = self.datas.firstObject;
	NSArray *second = self.datas.lastObject;
	for (int i=0;i<self.datas.count;i++) {
		for (int j=0;j< second.count;j++) {
			if (i*3+j != 5) {
				NSDictionary *dic = (i==0? first[j]: second[j]);
				
				UIView *bgview = [UIView new];
				[self addSubview:bgview];
				[bgview mas_makeConstraints:^(MASConstraintMaker *make) {
					make.top.mas_equalTo(i*40 + 40);
					make.width.mas_equalTo(((i*3+j)==4?((SCREEN_WIDTH - 36)/3.0f+20):(SCREEN_WIDTH - 36)/3.0f));
					make.leading.mas_equalTo(15+j*(SCREEN_WIDTH - 30)/3.0f);
					make.height.mas_equalTo(40);
				}];
				
				UILabel *title = [UILabel new];
				title.font = [UIFont systemFontOfSize:15];
				title.textColor = RGB(45, 45, 45);
				title.text = dic.allKeys.firstObject;
				[bgview addSubview:title];
				[title mas_makeConstraints:^(MASConstraintMaker *make) {
					make.top.mas_equalTo(10);
					make.leading.mas_equalTo(0);
					make.bottom.mas_equalTo(-10);
				}];
				
				NSArray *values = dic.allValues.firstObject;
				arrowBtn *editBtn = [[arrowBtn alloc]initWithFrame:CGRectZero];
				editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
				editBtn.choiceblock = ^(NSString *str ,int index,int indexpathrow) {
					_currentStr = str;
					NSArray *keys = @[@"DeliveryCd",@"order_by",@"",@"EventCd",@"VoucherCd"];
					for (int i = 0; i<keys.count; i++) {
						if (i!=2) {
							[self.resquestDic setObject:[NSString stringWithFormat:@"%d",(i==1?indexpathrow+1:indexpathrow)] forKey:keys[i]];

						}else{
				
							NSArray *data1 = self.datas.firstObject;
							NSDictionary*dics = data1.lastObject;
							NSArray *datass = dics.allValues;
							NSArray *datasss = datass.firstObject;
							NSDictionary *dit = datasss[indexpathrow];
							[self.resquestDic setObject:dit[@"level1"] forKey:@"level1"];
							[self.resquestDic setObject:dit[@"level2"] forKey:@"level2"];
							
						}
						
					}
					
				
					NSLog(@"%@",self.resquestDic);
				};
				editBtn.tag = (i*3+j);
				[editBtn addTarget:self action:@selector(clickChoice:) forControlEvents:UIControlEventTouchUpInside];
				[bgview addSubview:editBtn];
				[editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
					make.leading.mas_equalTo(title.mas_trailing).offset(3);
					make.trailing.mas_equalTo(-5);
					make.top.mas_equalTo(8);
					make.bottom.mas_equalTo(-8);
				}];
				editBtn.data = values;
				

			}else{
				UIButton *submit = [UIButton new];
				submit.backgroundColor = RGB(33, 192, 67);
				submit.layer.cornerRadius = 4;
				submit.layer.masksToBounds = YES;
				[submit setTitle:@"검색" forState:UIControlStateNormal];
				[submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
				[self addSubview:submit];
				[submit mas_makeConstraints:^(MASConstraintMaker *make) {
					make.width.mas_equalTo(50);
					make.top.mas_equalTo(i*50 + 37);
					make.height.mas_equalTo(26);
					make.trailing.mas_equalTo(-20);
				}];
				
			}
	}
}
}

- (void)clickChoice:(UIButton*)sender{


}

- (void)submit:(UIButton*)sender{
	NSLog(@"%@",_resquestDic);
	if (self.paramterdic) {
		self.paramterdic(self.resquestDic);
	}


}
#pragma mark -- 获取文字内容的宽度
- (CGSize)getSize:(NSString*)content{
	NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
	CGSize contentSize = [content boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
	return contentSize;
}
@end
