//
//  SupermarketRefundRuleController.m
//  Portal
//
//  Created by ifox on 2017/1/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketRefundRuleController.h"

@interface SupermarketRefundRuleController ()

@end

@implementation SupermarketRefundRuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SMRefundRule", nil);
    
    self.view.backgroundColor = BGColor;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = BGColor;
//    scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 0)];
//    imageView.backgroundColor = [UIColor orangeColor];
    
    UIImage *rule = [UIImage imageNamed:@"ruleImage"];
    CGFloat imageWidth = rule.size.width;
    CGFloat imageHeight = rule.size.height;
    
    CGFloat imageViewHeight = APPScreenWidth*imageHeight/imageWidth;
    
    imageView.frame = CGRectMake(0, 0, APPScreenWidth, imageViewHeight);
    imageView.image = rule;
    
    scrollView.contentSize = CGSizeMake(APPScreenWidth, imageViewHeight);
    
    [scrollView addSubview:imageView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
