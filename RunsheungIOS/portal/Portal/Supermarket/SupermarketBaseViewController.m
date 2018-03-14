//
//  SupermarketBaseViewController.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketBaseViewController.h"
#import "SupermarketSearchResultViewController.h"
#import "SupermarketMyOrderController.h"
#import "NSBundle+Language.h"

@interface SupermarketBaseViewController ()

@end

@implementation SupermarketBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logIn) name:TokenWrong object:nil];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
     self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont italicSystemFontOfSize:17]};
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
    if (self.navigationController.viewControllers.firstObject != self) {
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[SupermarketMyOrderController class]]) {
                UIBarButtonItem *backToRoot = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popToRootController)];
                backToRoot.tintColor = [UIColor darkGrayColor];
                self.navigationItem.leftBarButtonItem = backToRoot;
            } else {
                UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popController)];
                back.tintColor = [UIColor darkGrayColor];
                self.navigationItem.leftBarButtonItem = back;
            }
        }
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[SupermarketSearchResultViewController class]]) {
                self.navigationItem.leftBarButtonItem = nil;
            }
        }
    }
}

//- (void)refreshLanguageNotificaion:(NSNotification *)notification {
//    NSLog(@"%@",notification.object);
//}

- (void)logIn {
    RSLoginContainerController *logIn = [[RSLoginContainerController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logIn];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToRootController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defalut = [[NSUserDefaults alloc]initWithSuiteName:@"YCSheLongWang"];
    NSString *lan = [defalut objectForKey:@"setlanguage"];

    if (lan && ![lan isEqualToString:@""]) {
        [NSBundle setLanguage:lan];
    }
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
