//
//  YCHotelMainController.m
//  Portal
//
//  Created by ifox on 2017/3/29.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCHotelMainController.h"
#import "YCHotelNavigationController.h"
#import "YCHotelHomeViewController.h"
#import "YCHotelMineViewController.h"
#import "YCHotelOrderViewController.h"
#import "YCHotelHomeController.h"

@interface YCHotelMainController ()<UITabBarControllerDelegate>

@end

@implementation YCHotelMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    [self initControllers];
    // Do any additional setup after loading the view.
}

- (void)initControllers {
    
    YCHotelHomeViewController *hotelHome = [[YCHotelHomeViewController alloc] init];
    YCHotelOrderViewController *hotelOrder = [[YCHotelOrderViewController alloc] init];
//    YCHotelMineViewController *hotelMine = [[YCHotelMineViewController alloc] init];
    PersonalCenterController *hotelMine = [[PersonalCenterController alloc] init];
    hotelMine.isHotel = true;
    
    YCHotelHomeController *home = [[YCHotelHomeController alloc] init];
    
    YCHotelNavigationController *homeNav = [[YCHotelNavigationController alloc] initWithRootViewController:home];
    YCHotelNavigationController *orderNav = [[YCHotelNavigationController alloc] initWithRootViewController:hotelOrder];
    YCHotelNavigationController *mineNav = [[YCHotelNavigationController alloc] initWithRootViewController:hotelMine];
    
    self.viewControllers = @[homeNav,orderNav,mineNav];
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.barStyle = UIBarStyleDefault;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       PurpleColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    NSInteger index = 0;
    for (index = 0; index < self.viewControllers.count; index++) {
        UINavigationController *nav = self.viewControllers[index];
        switch (index) {
            case 0:
            {
                UIImage *image = [UIImage imageNamed:@"icon_home_n"];
                UIImage *selectedImage = [UIImage imageNamed:@"icon_home_s"];
                selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                 nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"HotelTabHome", nil) image:image selectedImage:selectedImage];
            }
                break;
            case 1:
            {
                UIImage *image = [UIImage imageNamed:@"icon_order_n"];
                UIImage *selectedImage = [UIImage imageNamed:@"icon_order_s"];
                selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"HotelTabOrder", nil) image:image selectedImage:selectedImage];
            }
                break;
            case 2:
            {
                UIImage *image = [UIImage imageNamed:@"icon_mine_n"];
                UIImage *selectedImage = [UIImage imageNamed:@"icon_mine_s"];
                selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"HotelTabMine", nil) image:image selectedImage:selectedImage];
            }
                break;
            default:
                break;
        }
    }
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    BOOL isLogIn = [YCAccountModel islogin];
    if (isLogIn == NO) {
        RSLoginContainerController *logInController = [[RSLoginContainerController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logInController];
        
        [self presentViewController:nav animated:YES completion:nil];
        return NO;
    }
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HotelRefreshOrderListNotification object:nil];
    }

    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
