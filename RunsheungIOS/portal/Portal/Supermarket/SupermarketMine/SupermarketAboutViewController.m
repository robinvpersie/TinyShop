//
//  SupermarketAboutViewController.m
//  Portal
//
//  Created by ifox on 2017/1/14.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketAboutViewController.h"

@interface SupermarketAboutViewController ()

@end

@implementation SupermarketAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SMAboutUsTitle", nil);
    
    self.view.backgroundColor = BGColor;
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectZero];
    logo.bounds = CGRectMake(0, 0, 100, 100);
    logo.center = self.view.center;
    logo.image = [UIImage imageNamed:@"shelong"];
    [self.view addSubview:logo];
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logo.frame)+15, APPScreenWidth, 20)];
    version.textColor = [UIColor grayColor];
    version.font = [UIFont systemFontOfSize:17];
    version.textAlignment = NSTextAlignmentCenter;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    version.text =  [NSString stringWithFormat:@"生鲜奢厨版本%@",app_Version];
    version.text = @"人生药业Version:1.0.0";
    [self.view addSubview:version];
    // Do any additional setup after loading the view.
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
