//
//  KLMainController.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/2.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "KLMainController.h"
#import "KLHomeViewController.h"
#import "KLOnlineVideoViewController.h"
#import "KLVoteViewController.h"
#import "KLMyCenterViewController.h"
#import "KLBuyingTicketViewController.h"
#import "KLTabOnlineVideoView.h"
#import "KLBaseNavigationController.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface KLMainController()<UITabBarControllerDelegate>

@property(nonatomic, strong) UIView *onlineViewView;
@property(nonatomic, strong) UIWindow *window;
@property (nonatomic,weak)UINavigationController *selectNavi;
@property (nonatomic,strong)KLTabOnlineVideoView *videoView;

@end

@implementation KLMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.delegate = self;
//    [self initControllers];
    
    
    // Do any additional setup after loading the view.
}

- (void)initControllers {
    
//    KLMediaHomeViewController *home = [[KLMediaHomeViewController alloc] init];
//    KLOnlineVideoController *onlineVideo = [[KLOnlineVideoController alloc] init];
//    KLBuyingTicketViewController *buyingTicket = [[KLBuyingTicketViewController alloc] init];
//    KLOnlineVoteController *vote = [[KLOnlineVoteController alloc] init];
//    KLMediaOnlineUserCenter *myCenter = [[KLMediaOnlineUserCenter alloc] init];
//    
//    
//    KLBaseNavigationController *nav0 = [[KLBaseNavigationController alloc] initWithRootViewController:home];
//    nav0.navigationBar.barTintColor = [UIColor whiteColor];
//    nav0.navigationBar.translucent = NO;
//    nav0.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont italicSystemFontOfSize:17]};
//     KLBaseNavigationController *nav1 = [[KLBaseNavigationController alloc] initWithRootViewController:onlineVideo];
//    nav1.navigationBar.translucent = NO;
//     KLBaseNavigationController *nav2 = [[KLBaseNavigationController alloc] initWithRootViewController:buyingTicket];
//     KLBaseNavigationController *nav3 = [[KLBaseNavigationController alloc] initWithRootViewController:vote];
//    nav3.navigationBar.translucent = NO;
//    KLBaseNavigationController *nav4 = [[KLBaseNavigationController alloc] initWithRootViewController:myCenter];
//    nav4.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
//    nav4.navigationBar.translucent = NO;
//    
////    self.viewControllers = @[home,onlineVideo,buyingTicket,vote,myCenter];
//    self.viewControllers = @[nav0,nav1,nav2,nav3,nav4];
//    self.tabBar.translucent = NO;
//    self.tabBar.barTintColor = [UIColor whiteColor];
//    self.tabBar.barStyle = UIBarStyleDefault;
//    
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       [UIColor orangeColor], NSForegroundColorAttributeName,
//                                                       nil] forState:UIControlStateSelected];
//    
//    NSInteger index = 0;
//    for (index = 0;index<self.viewControllers.count;index++) {
//        UINavigationController *nav = self.viewControllers[index];
//        switch (index) {
//            case 0:
//            {
//                UIImage *image = [UIImage imageNamed:@"tabbar_recommend_n"];
//                UIImage *selectedImage = [UIImage imageNamed:@"tabbar_recommend_s"];
//                selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"精彩推荐" image:image selectedImage:selectedImage];
//            }
//                break;
//            case 1:
//            {
//                UIImage *image = [UIImage imageNamed:@"tabbar_vedio_n"];
//                UIImage *selectedImage = [UIImage imageNamed:@"tabbar_vedio_s"];
//                selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"在线视频" image:image selectedImage:selectedImage];
//            }
//                break;
//            case 2:
//            {
//                UIImage *image = [UIImage imageNamed:@"tabbar_ticket_n"];
//                UIImage *selectedImage = [UIImage imageNamed:@"tabbar_ticket_s"];
//                selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"自助购票" image:image selectedImage:selectedImage];
//            }
//                break;
//            case 3:
//            {
//                UIImage *image = [UIImage imageNamed:@"tabbar_vote_n"];
//                UIImage *selectedImage = [UIImage imageNamed:@"tabbar_vote_s"];
//                selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"投票活动" image:image selectedImage:selectedImage];
//            }
//                break;
//            case 4:
//            {
//                UIImage *image = [UIImage imageNamed:@"tabbar_mine_n"];
//                UIImage *selectedImage = [UIImage imageNamed:@"tabbar_mine_s"];
//                selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的狂乐" image:image selectedImage:selectedImage];
//            }
//                break;
//            default:
//                break;
//        }
//    }
}



//-(KLTabOnlineVideoView *)videoView{
//    if (_videoView == nil){
//        KLTabOnlineVideoView *video = [[KLTabOnlineVideoView alloc]init];
//        __weak typeof(self) weakself = self;
//        video.afterHideAction = ^(int type){
//            if (type == 0) {
//                KLEntertainmentController * K = [[KLEntertainmentController alloc]init];
//                K.hidesBottomBarWhenPushed = YES;
//                [weakself.selectNavi pushViewController:K animated:YES];
//            }else {
//                KLMovieHouseController *movie = [[KLMovieHouseController alloc]init];
//                movie.hidesBottomBarWhenPushed = YES;
//                [weakself.selectNavi pushViewController:movie animated:YES];
//             }
//        };
//        return video;
//    }
//    return _videoView;
//}

//-(BOOL)shouldAutorotate{
//    UIViewController *select = self.selectedViewController;
//    if ([select isKindOfClass:[UINavigationController class]]){
//        UINavigationController *nav = (UINavigationController *)select;
//        return nav.topViewController.shouldAutorotate;
//    }else {
//        return select.shouldAutorotate;
//    }
//    return YES;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    UIViewController *select = self.selectedViewController;
//    if ([select isKindOfClass:[UINavigationController class]]){
//        UINavigationController *nav = (UINavigationController *)select;
//        return nav.topViewController.supportedInterfaceOrientations;
//    }else {
//        return select.supportedInterfaceOrientations;
//    }
//    return UIInterfaceOrientationMaskPortrait;
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    self.selectNavi = (UINavigationController *)tabBarController.viewControllers[self.selectedIndex];
//    NSInteger index = [self.viewControllers indexOfObject:viewController];
//    if (index == 2) {
//        [self.videoView showInView:self.view.window];
//        return NO;
//    }
//        return YES;
//   }
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    NSLog(@"bbbb");
//  }


@end


