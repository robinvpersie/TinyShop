//
//  MineBaseViewController.m
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/2.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import "TSBaseViewController.h"

@interface TSBaseViewController ()

@end

@implementation TSBaseViewController
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];

	[self setNavi];
	
}



- (void)setNavi{
	UIButton *popBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
	[popBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
	[popBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
	[popBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
	[popBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:popBtn];
	self.navigationItem.leftBarButtonItem = item;
	
}

- (void)pop:(UIButton*)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = RGB(255, 255, 255);
	
}

- (void)setNaviLineColor:(UIViewController*)vc withColor:(UIColor*)color{
	UIImage *colorImage = [self imageWithColor:[UIColor clearColor] size:CGSizeMake(vc.view.frame.size.width, 0.8)];
	[vc.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
	[vc.navigationController.navigationBar setShadowImage:[self imageWithColor:color size:CGSizeMake(vc.view.frame.size.width, 0.8)]];
	
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
	if (!color || size.width <=0 || size.height <=0) return nil;
	CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
	UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
	CGContextRef context =UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, color.CGColor);
	CGContextFillRect(context, rect);
	UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end

