//
//  OffLineShoppingCartBaseViewController.m
//  Portal
//
//  Created by ifox on 2017/9/30.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "OffLineShoppingCartBaseViewController.h"
#import "OffLineHomeController.h"

@interface OffLineShoppingCartBaseViewController ()

@end

@implementation OffLineShoppingCartBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont italicSystemFontOfSize:17]};
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if (self.navigationController.viewControllers.firstObject != self) {
            if ([vc isKindOfClass:[OffLineHomeController class]]) {
                UIBarButtonItem *backToRoot = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popToRootController)];
                backToRoot.tintColor = [UIColor darkGrayColor];
                self.navigationItem.leftBarButtonItem = backToRoot;
            } else {
                UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popController)];
                back.tintColor = [UIColor darkGrayColor];
                self.navigationItem.leftBarButtonItem = back;
            }
        }
    }
}

- (void)popToRootController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)popController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
