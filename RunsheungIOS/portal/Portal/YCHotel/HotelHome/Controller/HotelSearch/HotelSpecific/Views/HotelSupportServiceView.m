//
//  HotelSupportServiceView.m
//  Portal
//
//  Created by 王五 on 2017/4/15.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelSupportServiceView.h"
#import "UILabel+CreateLabel.h"
#define BTNHEIGHT 50
@implementation HotelSupportServiceView{
    CGRect _frame1;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        _frame1 = frame;
    }
    return self;
}

- (void)setServiceArr:(NSMutableArray *)serviceArr{
    _serviceArr = serviceArr;
    [self createSubviews:_frame1];
    
}
//创建子视图
- (void)createSubviews:(CGRect)frame{
   
   
    UIView *moreService = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, CGRectGetHeight(frame))];
    [self addSubview:moreService];

    for (int i=0;i<(self.serviceArr.count/4.0f);i++) {
        for (int j=0;j<4;j++) {
            if ((i*4+j)<self.serviceArr.count) {
          
            NSDictionary *dic = [self.serviceArr objectAtIndex:(i*4+j)];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(j*APPScreenWidth/4, i*BTNHEIGHT, APPScreenWidth/4.0f, BTNHEIGHT)];
            [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:i*4+j];
            [moreService addSubview:btn];
            
            UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(APPScreenWidth/8.0f-8.0f, 8, 16, 16)];
                NSString *urlImg = dic.allKeys.firstObject;
                urlImg = [urlImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [iconImg setImageWithURL:[NSURL URLWithString:urlImg]];
            [iconImg setContentMode:UIViewContentModeScaleAspectFit];
            [iconImg setUserInteractionEnabled:YES];
            [btn addSubview:iconImg];
            
            UILabel *icontitle = [UILabel createLabelWithFrame:CGRectMake(0, CGRectGetHeight(btn.frame) - 20, CGRectGetWidth(btn.frame), 20) textColor:HotelGrayColor font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter text:[dic allValues].firstObject];
            [btn addSubview:icontitle];
            
       
        }
    }
        
    }
}

- (void)btn:(UIButton*)sender{
    
}
@end
