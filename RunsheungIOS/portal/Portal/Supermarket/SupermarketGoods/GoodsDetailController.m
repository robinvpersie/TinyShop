//
//  GoodsDetailController.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/8.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "GoodsDetailController.h"
#import "LGSegment.h"
#import "SupermarketGoodsViewController.h"
#import "SupermarketDetailViewController.h"
#import "SupermarketCommentViewController.h"

@interface GoodsDetailController ()<UIScrollViewDelegate,SegmentDelegate>

@property(nonatomic, strong) LGSegment *segment;
@property(nonatomic, strong) UIScrollView *scrollView;

@end

@implementation GoodsDetailController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _segment = [[LGSegment alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    _segment.delegate = self;
    
    _segment.titleList = @[NSLocalizedString(@"SMGoodsDetailGoods", nil),NSLocalizedString(@"SMGoodsDetailDetail", nil),NSLocalizedString(@"SMGoodsDetailComments", nil)].mutableCopy;
    
    if (self.divCode.length == 0 || self.divCode == nil) {
        self.divCode = [[NSUserDefaults standardUserDefaults] objectForKey:DivCodeDefault];
        if (self.divCode.length == 0) {
            NSUserDefaults *defalut = [[NSUserDefaults alloc]initWithSuiteName:@"YCSheLongWang"];
            self.divCode = [defalut objectForKey:@"HomeDivCode"];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.divCode forKey:DivCodeDefault];
    }
    
//    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popController)];
//    self.navigationItem.leftBarButtonItem = back;
    
    self.navigationItem.titleView = _segment;
    
    [self setControllers];
    
    //加载ScrollView
    [self setContentScrollView];
    
    [self initView];
    
    // Do any additional setup after loading the view.
}

- (void)popController {
    if (self.isScan) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
     [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setControllers {
    SupermarketGoodsViewController *goods = [[SupermarketGoodsViewController alloc] init];
    goods.item_code = self.item_code;
    goods.isScan = self.isScan;
    goods.divCode = self.divCode;
    goods.controllerType = self.controllerType;
    SupermarketDetailViewController *detail = [[SupermarketDetailViewController alloc] init];
    SupermarketCommentViewController *comment = [[SupermarketCommentViewController alloc] init];
    comment.divCode = self.divCode;
    comment.item_code = self.item_code;
    
    [self addChildViewController:goods];
    [self addChildViewController:detail];
    [self addChildViewController:comment];
}

- (void)setContentScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, APPScreenWidth, APPScreenHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    for (int i=0; i<self.childViewControllers.count; i++) {
        UIViewController * vc = self.childViewControllers[i];
        vc.view.frame = CGRectMake(i * APPScreenWidth, 0, APPScreenWidth, APPScreenHeight);
        [_scrollView addSubview:vc.view];
    }
    _scrollView.contentSize = CGSizeMake(APPScreenWidth*3, APPScreenHeight);
}

- (void)initView {
    
}

#pragma mark - UIScrollViewDelegate
//实现LGSegment代理方法
-(void)scrollToPage:(int)Page {
//    if (Page == 2) {
//        return;
//    }
    CGPoint offset = _scrollView.contentOffset;
    offset.x = self.view.frame.size.width * Page;
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.contentOffset = offset;
    }];
}
// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    [self.segment moveToOffsetX:offsetX];
    
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
