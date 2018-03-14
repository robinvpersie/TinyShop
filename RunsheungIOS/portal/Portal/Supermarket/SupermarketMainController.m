//
//  SupermarketMainController.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketMainController.h"
#import "SupermarketHomeViewController.h"
#import "SuperMarketActivityViewController.h"
#import "SupermarketKindsViewController.h"
#import "SupermarketShoppingCartViewController.h"
#import "SupermarketMineViewController.h"
#import "SupermarketBaseNavigationController.h"
#import "LZCartViewController.h"
#import "SupermarketAllKindsController.h"

@interface SupermarketMainController ()<UITabBarControllerDelegate>

@property (nonatomic,weak)UINavigationController *selectNavi;

@end

@implementation SupermarketMainController {
    SupermarketHomeViewController *home;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.delegate = self;
    [self initControllers];
    // Do any additional setup after loading the view.
}

-(void)setVersion:(NSString *)version{
    NSString *new = [version copy];
    home.version = new;
}

-(void)setState:(NSString *)state{
    NSString *new = [state copy];
    home.state = new;
}

- (void)initControllers {
    if (self.divCode.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.divCode forKey:DivCodeDefault];
    }
    
    
    home = [[SupermarketHomeViewController alloc] init];
    home.divCode = self.divCode;
    home.divName = self.divName;
    home.version = self.version;
    home.state = self.state;
    
//    SuperMarketProfileController *mine = [[SuperMarketProfileController alloc]init];
    SupermarketMineViewController *mine = [[SupermarketMineViewController alloc] init];
    LZCartViewController *shopping_Cart = [[LZCartViewController alloc] init];
    shopping_Cart.divCode = self.divCode;
    SupermarketAllKindsController *allKinds = [[SupermarketAllKindsController alloc] init];
    
//    shopping_Cart.type = ShoppingCartController;
    
    SupermarketBaseNavigationController *nav0 = [[SupermarketBaseNavigationController alloc] initWithRootViewController:home];
//    SupermarketBaseNavigationController *nav1 = [[SupermarketBaseNavigationController alloc] initWithRootViewController:activity];
    SupermarketBaseNavigationController *nav2 = [[SupermarketBaseNavigationController alloc] initWithRootViewController:allKinds];
    SupermarketBaseNavigationController *nav3 = [[SupermarketBaseNavigationController alloc] initWithRootViewController:shopping_Cart];
    YCNavigationController *nav4 = [[YCNavigationController alloc] initWithRootViewController:mine];
    
    self.viewControllers = @[nav0,nav2,nav3,nav4];
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.barStyle = UIBarStyleDefault;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor greenColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    NSInteger index = 0;
    for (index = 0;index<self.viewControllers.count;index++) {
        UINavigationController *nav = self.viewControllers[index];
        switch (index) {
            case 0:
            {
                UIImage *image = [UIImage imageNamed:@"tabbar_home-page_n"];
                UIImage *selectedImage = [UIImage imageNamed:@"tabbar_home-page_s"];
                selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"SupermarketTabHome",nil) image:image selectedImage:selectedImage];
            }
                break;
            case 1:
            {
                UIImage *image = [UIImage imageNamed:@"tabbar_classification_n"];
                UIImage *selectedImage = [UIImage imageNamed:@"tabbar_classification_s"];
                selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"SupermarketTabKinds",nil) image:image selectedImage:selectedImage];
            }
                break;
            case 2:
            {
                UIImage *image = [UIImage imageNamed:@"tabbar_shoppingcart_n"];
                UIImage *selectedImage = [UIImage imageNamed:@"tabbar_shoppingcart_s"];
                selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"SupermarketTabShoppingCart",nil) image:image selectedImage:selectedImage];
            }
                break;
            case 3:
            {
                UIImage *image = [UIImage imageNamed:@"tabbar_my_n"];
                UIImage *selectedImage = [UIImage imageNamed:@"tabbar_my_s"];
                selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"SupermarketTabMine",nil) image:image selectedImage:selectedImage];
            }
                break;
            default:
                break;
        }
    }

}

- (void)setDivName:(NSString *)divName {
    _divName = divName;
    home.divName = divName;
}

- (void)setDivCode:(NSString *)divCode {
    _divCode = divCode;
    if (self.divCode.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:divCode forKey:DivCodeDefault];
    }
    home.divCode = divCode;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    self.selectNavi = (UINavigationController *)tabBarController.viewControllers[self.selectedIndex];
    NSInteger index = [self.viewControllers indexOfObject:viewController];
//    if (index == 3) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:SupermarketSelectTabBar object:nil];
//    }
    if (index == 2 || index == 3) {
        if ([YCAccountModel islogin]){
            return YES;
        }else {
            [tabBarController.selectedViewController goToLoginWithCompletion:^{
                
            }];
            return NO;
        }
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
