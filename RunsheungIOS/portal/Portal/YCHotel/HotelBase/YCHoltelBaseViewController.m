//
//  YCHoltelBaseViewController.m
//  Portal
//
//  Created by ifox on 2017/3/29.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCHoltelBaseViewController.h"
#import "NSBundle+Language.h"

@interface YCHoltelBaseViewController ()

@end

@implementation YCHoltelBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goLogIn) name:HotelTokenWrong object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defalut = [[NSUserDefaults alloc]initWithSuiteName:@"YCSheLongWang"];
    NSString *lan = [defalut objectForKey:@"setlanguage"];
    
    if (lan && ![lan isEqualToString:@""]) {
        [NSBundle setLanguage:lan];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont italicSystemFontOfSize:17]};
    if (self.navigationController.viewControllers.firstObject != self) {
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popController)];
        back.tintColor = [UIColor darkGrayColor];
        self.navigationItem.leftBarButtonItem = back;
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HotelTokenWrong object:nil];
}

- (void)goLogIn {
    RSLoginContainerController *logInController = [[RSLoginContainerController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logInController];
    
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
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
