//
//  HNCodeScannerCoverView.h
//  StarlinkApp
//
//  Created by lpx on 15/6/1.
//  Copyright (c) 2015年 starlink. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KScannerState) {
    kScannerStateStart,
    kScannerStateScanning,
    kScannerStateStop,
};



@interface HNCodeScannerCoverView : UIView


@property (nonatomic, assign) KScannerState scannerState;

@end
