//
//  ParkingHomepage.m
//  Portal
//
//  Created by ifox on 2017/2/27.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "ParkingHomepage.h"

@implementation ParkingHomepage

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight - 20)];
    imageView.image = [UIImage imageNamed:@"停车首页"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissController)];
    [imageView addGestureRecognizer:backTap];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(10, 10, 30, 30);
    [back addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
