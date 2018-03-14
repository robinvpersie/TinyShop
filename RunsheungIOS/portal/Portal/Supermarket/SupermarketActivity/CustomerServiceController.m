//
//  CustomerServiceController.m
//  Portal
//
//  Created by ifox on 2017/5/16.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "CustomerServiceController.h"
#import "RSWebProgressLayer.h"


@interface CustomerServiceController ()<UIWebViewDelegate>{
    UIWebView *webView ;
    RSWebProgressLayer *_progressLayer;//网页进度加载条
}

@end

@implementation CustomerServiceController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setnavigation];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:@"http://www.renshengyaoye.com:8993/Mobile/index.aspx"];
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
  
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    if (_progressLayer == nil) {
        if ([[RSJudgeIsX new] isX]){
           _progressLayer = [RSWebProgressLayer layerWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, 2)];
        }else {
           _progressLayer = [RSWebProgressLayer layerWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 2)];
        }
        
        [self.view.layer addSublayer:_progressLayer];
        [_progressLayer startLoad];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_progressLayer finishedLoad];
    self.title = @"人生药业";
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
}

- (void)setnavigation{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"shengqing_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backitem;
    
}
- (void)dealloc {
    NSLog(@"i am dealloc");
}
- (void)pop:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setFlag:(float )flag{
    _flag = flag;
}


@end
