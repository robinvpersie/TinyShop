//
//  HNViewController.h
//  惠农码
//
//  Created by Liangpx on 13-12-14.
//  Copyright (c) 2013年 HuiNongKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KCodeScanComeFrom) {
    kCodeScanComeFromProductAndCompany,
    kCodeScanComeFromAddFriends,
};


@class HNScanViewController;

@protocol HNScanViewControllerDelegate <NSObject>

- (void)scanViewController:(HNScanViewController *)scanViewController didScanResult:(NSString *)result;

@end

@interface HNScanViewController : UIViewController

@property (nonatomic, assign) id <HNScanViewControllerDelegate>delegate;

@property (nonatomic, assign) KCodeScanComeFrom codeComeFrom;


- (void)reStartScan;

@end
