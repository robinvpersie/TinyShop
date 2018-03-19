//
//  WJItemView.m
//  WJIM_DOME
//
//  Created by 王五 on 2017/9/16.
//  Copyright © 2017年 王五. All rights reserved.
//

#import "TSItemView.h"

@implementation TSItemView

- (instancetype)initWithFrame:(CGRect)frame withData:(NSArray*)data{
   self = [super initWithFrame:frame];
    if (self) {
        
        self.ItemsArr = data;
      
        [self createItems:frame];
    }
    return self;
}

#pragma mark -- 创建Items
- (void)createItems:(CGRect)frame{
    self.rowWidth = 0.0f;
    self.rows = 0;
    for (int i = 0; i<self.ItemsArr.count; i++) {
       
        NSString *content = self.ItemsArr[i];
        UIView *backview;
		NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
		CGSize contentSize = [content boundingRectWithSize:CGSizeMake(MAXFLOAT,30) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

        float itemwidth = contentSize.width;
        if ( (self.frame.size.width - self.rowWidth) < (itemwidth + 20)) {
           
            self.rowWidth = 0.0f;
            self.rows +=1;
  
        }
       
        backview = [[UIView alloc]initWithFrame:CGRectMake(self.rowWidth,self.rows*35, itemwidth + 20, 30)];

		UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(5,0, itemwidth+10, 30)];
		[itemBtn setTitle:content forState:UIControlStateNormal];
		[itemBtn setTitleColor:RGB(175, 175, 175) forState:UIControlStateNormal];
		[itemBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
		[itemBtn setBackgroundColor:RGB(245, 245, 245)];
		[itemBtn.layer setCornerRadius:15];
		[itemBtn.layer setMasksToBounds:YES];

        [itemBtn addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        itemBtn.tag = i;
        [backview addSubview:itemBtn];
        self.rowWidth += itemwidth+20;

        [self addSubview:backview];
        
        
    }
    
    if (self.ItemsArr.count) {
      
        CGRect frame1 = self.frame;
        frame1.size.height = (self.rows + 1)*35;
        self.frame = frame1;

    }
}

- (void)itemAction:(UIButton*)sender{
    
    if ([self.wjitemdelegate respondsToSelector:@selector(wjClickItems:)]) {

        [self.wjitemdelegate wjClickItems:self.ItemsArr[(int)sender.tag]];
    }
}
@end
