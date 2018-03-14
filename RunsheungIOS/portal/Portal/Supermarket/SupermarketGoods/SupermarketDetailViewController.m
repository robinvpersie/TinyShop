//
//  SupermarketDetailViewController.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/8.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketDetailViewController.h"

@interface SupermarketDetailViewController ()

@property(nonatomic, strong) UIWebView *webView;

@end

@implementation SupermarketDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDetail:) name:@"GoodsDetailUrl" object:nil];
    
    self.view.backgroundColor = [UIColor redColor];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)];
//    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [_webView loadRequest:request];
    
    UIScrollView *scrollView = _webView.scrollView;
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    
    [self.view addSubview:_webView];
    // Do any additional setup after loading the view.
}

- (void)reloadDetail:(NSNotification *)notification {
    NSString *urlString = notification.object;
    if (urlString.length > 0) {
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
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
