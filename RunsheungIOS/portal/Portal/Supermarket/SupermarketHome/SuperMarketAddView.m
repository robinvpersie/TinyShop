//
//  SuperMarketAddView.m
//  Portal
//
//  Created by zhengzeyou on 2018/1/9.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "SuperMarketAddView.h"

@implementation SuperMarketAddView{
    UIImageView *showImg;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self initView];
        
       
    }
    return self;
}
//创建子视图
- (void)initView{
    showImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, CGRectGetHeight(self.frame))];
    showImg.backgroundColor = [UIColor grayColor];
    [self addSubview:showImg];
    
}
- (void)setImageNamed:(NSString *)imageNamed{
    _imageNamed = imageNamed;
    if ([self.imageNamed containsString:@"http"]) {
        [showImg sd_setImageWithURL:[NSURL URLWithString:_imageNamed]];
    }else{
        [showImg setImage:[UIImage imageNamed:self.imageNamed]];
    }
    }
    

@end
