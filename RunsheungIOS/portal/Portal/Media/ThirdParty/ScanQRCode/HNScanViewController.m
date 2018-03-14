//
//  HNViewController.m
//  惠农码
//
//  Created by Liangpx on 13-12-14.
//  Copyright (c) 2013年 HuiNongKeJi. All rights reserved.
//

#import "HNScanViewController.h"
#import "HNCodeScannerView.h"
#import "HNSoundHelper.h"
#import <AVFoundation/AVFoundation.h>



@interface HNScanViewController ()<HNCodeScannerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) HNCodeScannerView *codeScannerView;
@property (nonatomic, strong) UILabel *codeLabel;


@end

@implementation HNScanViewController
- (void)dealloc
{
    _codeScannerView = nil;
    _codeLabel = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor navigationBarColor]];
    CGFloat labelHeight = 0;
//    self.view.bounds = CGRectMake(0, 0, kAppScreenWidth, 454);
    self.view.backgroundColor = [UIColor whiteColor];
    //
    self.codeScannerView = [[HNCodeScannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - labelHeight)];
    
    self.codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.codeScannerView.frame.size.height, self.view.bounds.size.width - 10, labelHeight)];
    self.codeLabel.backgroundColor = [UIColor clearColor];
    self.codeLabel.textColor = [UIColor blackColor];
    self.codeLabel.font = [UIFont boldSystemFontOfSize:13];
    self.codeLabel.numberOfLines = 2;
    self.codeLabel.textAlignment = NSTextAlignmentCenter;
    self.codeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.codeScannerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.codeScannerView.delegate = self;
    [self.view addSubview:self.codeScannerView];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController
    
//    [self.view addSubview:self.codeLabel];
    if(self.navigationController.viewControllers.firstObject == self) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]};
        [self.navigationController.navigationBar setTitleTextAttributes:attributes];
        self.title = @"扫描";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(album)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }

}

-(void)album{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = false;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:true completion:nil];
  }
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
      [picker dismissViewControllerAnimated:true completion:nil];
       UIImage *image = info[UIImagePickerControllerOriginalImage];
       CIDetector *dector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
           CIImage *CIimage = [[CIImage alloc]initWithCGImage:image.CGImage];
           NSArray *features = [dector featuresInImage:CIimage];
            [features enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[CIQRCodeFeature class]]){
                       if([_delegate respondsToSelector:@selector(scanViewController:didScanResult:)])
                       {
                           CIQRCodeFeature *feature = (CIQRCodeFeature *)obj;
                           [_delegate scanViewController:self didScanResult:feature.messageString];
                           [self dismissViewControllerAnimated:YES completion:nil];
                       }
                  }
            }];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.codeScannerView stop];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.codeScannerView start];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}
#pragma mark - actions

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}


- (void)reStartScan
{
    [self.codeScannerView start];
}

#pragma mark - HNCodeScannerViewDelegate

- (void)scannerView:(HNCodeScannerView *)scannerView didReadCode:(NSString*)code withPointsCount:(NSInteger)count{
    if([_delegate respondsToSelector:@selector(scanViewController:didScanResult:)])
    {
        [_delegate scanViewController:self didScanResult:code];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)scannerViewDidStartScanning:(HNCodeScannerView *)scannerView {
    
    
    switch (self.codeComeFrom) {
        case kCodeScanComeFromProductAndCompany:
             self.codeLabel.text = @"请将商户或商品二维码信息放入框内，即可自动扫描";
            break;
        case kCodeScanComeFromAddFriends:
            self.codeLabel.text = @"请将好友二维码放入框内，即可自动扫描";
            break;
            
        default:
            break;
    }
    
    
   
}

- (void)scannerViewDidStopScanning:(HNCodeScannerView *)scannerView {
    
}


- (void)alertUserToSettingCamera
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意" message:@"请设置允许使用照相机！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"注意" message:@"请设置允许使用照相机！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


#pragma mark - Private

- (void)beep {
    [HNSoundHelper playSoundFromFile:@"BEEP.mp3" fromBundle:[NSBundle mainBundle] asAlert:YES];
}

@end
