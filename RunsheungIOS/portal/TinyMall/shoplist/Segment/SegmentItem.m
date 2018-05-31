//
//  SegmentItem.m
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/14.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import "SegmentItem.h"

@implementation SegmentItem

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame: frame];
	if (self) {
		self.dataArray = @[@"거리순",@"인기순"].mutableCopy;
		self.backgroundColor = RGB(254, 254, 254);
		[self createSubviews];
	}
	return self;
}

- (void)createSubviews{
	
	self.buttonArray = @[].mutableCopy;
	for (int i = 0; i<self.dataArray.count; i++) {
		UIButton *buton = [[UIButton alloc]initWithFrame:CGRectMake(10 + i*75, 10, 65, 24)];
		buton.layer.borderWidth= 1;
		if (i == 0) {
			buton.selected = YES;
			buton.layer.borderColor = RGB(33, 192, 67).CGColor;
			
		}else{
			buton.layer.borderColor =RGB(201, 201, 201).CGColor;
		}
		buton.tag = i+1;
		buton.layer.cornerRadius = 12;
		buton.layer.masksToBounds = YES;
		[buton addTarget:self action:@selector(ItemThird:) forControlEvents:UIControlEventTouchUpInside];
		[buton setTitle:self.dataArray[i] forState:UIControlStateNormal];
		[buton setTitleColor:RGB(175, 175, 175) forState:UIControlStateNormal];
		[buton setTitleColor:RGB(33, 192, 67) forState:UIControlStateSelected];
		[buton.titleLabel setFont:[UIFont systemFontOfSize:13]];
		[self addSubview:buton];
	}
	
	//筛选分类
	UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 8, 100, 24)];
	selectBtn.tag = 1001;
	selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
	[selectBtn setTitleColor:RGB(13, 13, 13) forState:UIControlStateNormal];
	[selectBtn setTitle:@"카테고리 " forState:UIControlStateNormal];
	[selectBtn setImage:[UIImage imageNamed:@"icon_screen_list"] forState:UIControlStateNormal];
	
	NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
	CGSize contentSize = [selectBtn.currentTitle boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
	selectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -selectBtn.currentImage.size.width, 0, selectBtn.currentImage.size.width);
	selectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, contentSize.width + 2.5, 0, -contentSize.width - 2.5);
	[selectBtn addTarget:self action:@selector(choiceIconBtn:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:selectBtn];
	
}
- (void)choiceIconBtn:(UIButton*)sender{
	if ([self.delegate respondsToSelector:@selector(clickSegment:)]) {
		[self.delegate clickSegment:(int)sender.tag];
	}
}

- (void)ItemThird:(UIButton*)sender{
	
	NSArray *btnarray = [self subviews];
	for (int i = 0;i<btnarray.count;i++) {
		id btn = btnarray[i];
		if ([btn isMemberOfClass:[UIButton class]]) {
			UIButton *button = (UIButton*)btn;
			button.selected = NO;
			button.layer.borderColor =RGB(201, 201, 201).CGColor;
			
		}
	}
	sender.selected = YES;
	if ([self.delegate respondsToSelector:@selector(clickSegment:)]) {
		[self.delegate clickSegment:(int)sender.tag];
		if (sender.tag != 1001) {
			sender.layer.borderColor = RGB(33, 192, 67).CGColor;
			
		}
		
		
	}
	
	
}
@end
