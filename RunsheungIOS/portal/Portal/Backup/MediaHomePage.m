//
//  MediaHomePage.m
//  Portal
//
//  Created by ifox on 2017/5/2.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "MediaHomePage.h"

@interface MediaHomePage ()

@end

@implementation MediaHomePage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight - 20)];
    imageView.image = [UIImage imageNamed:@"klhome"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissController)];
    [imageView addGestureRecognizer:backTap];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(10, 10, 30, 30);
    [back addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];

    // Do any additional setup after loading the view.
}

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
