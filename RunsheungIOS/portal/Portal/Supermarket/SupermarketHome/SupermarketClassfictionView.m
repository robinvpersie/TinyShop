//
//  SupermarketClassfictionView.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketClassfictionView.h"

#define kItemsWidth self.frame.size.width/5
#define kBGViewWidth self.frame.size.width/4

@implementation SupermarketClassfictionView {
    NSMutableArray *_imageNames;
    NSMutableArray *_titleNames;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
		
		//jake - 170708
        //jake - 170708
        _titleNames = [NSMutableArray arrayWithObjects:@"我的订单",@"地址管理",@"钱包",@"在线客服", nil];
        _imageNames = [NSMutableArray arrayWithObjects:@"icon_02",@"icon_03",@"icon_04",@"icon_funcationnav_service", nil];
		
        [self createIteams];
        self.image = [UIImage imageNamed:@"rect"];
        self.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

- (void)createIteams {
    for (int i = 0; i < _titleNames.count; i++) {
        UIView *view = [self createSingelItemWithImageName:_imageNames[i] andtitleName:_titleNames[i] andIndex:i];
        [self addSubview:view];
    }
}

-(void)reloadWithVersion:(NSString *)version state:(NSString *)state {
    NSString * appversion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSLog(@"%@",version);
    NSLog(@"%@",appversion);
    NSLog(@"%@",state);
    if ([version isEqualToString:appversion] && [state isEqualToString:@"0"]) {
        [_titleNames removeObject:@"充值"];
        [_imageNames removeObject:@"icon_top_up"];
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self createIteams];
}


- (UIView *)createSingelItemWithImageName:(NSString *)imageName andtitleName:(NSString *)titileName andIndex:(NSInteger)index {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((index%4) * kBGViewWidth, index/4*kItemsWidth, kBGViewWidth, kItemsWidth)];
    view.tag = 100+index;
//    view.layer.borderWidth = 1.0;
//    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, kBGViewWidth - 40, kItemsWidth - 40)];
    logoView.image = [UIImage imageNamed:imageName];
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:logoView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoView.frame), kBGViewWidth, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = titileName;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor darkGrayColor];
    [view addSubview:titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSingleItem:)];
    [view addGestureRecognizer:tap];
    return view;
}

- (void)tapSingleItem:(UITapGestureRecognizer*)gesture {
    UIView *view = gesture.view;
    [self.delegate clickAtIndex:(view.tag - 100)];
}

@end
