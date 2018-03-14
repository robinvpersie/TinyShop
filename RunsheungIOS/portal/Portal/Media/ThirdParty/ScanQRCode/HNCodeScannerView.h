//
//  HNCodeScannerView.h
//  惠农码
//
//  Created by Liangpx on 13-12-14.
//  Copyright (c) 2013年 HuiNongKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNCodeScannerView;

@protocol HNCodeScannerViewDelegate < NSObject >

- (void)scannerView:(HNCodeScannerView *)scannerView didReadCode:(NSString*)code withPointsCount:(NSInteger)count;

@optional
- (void)scannerViewDidStartScanning:(HNCodeScannerView *)scannerView;
- (void)scannerViewDidStopScanning:(HNCodeScannerView *)scannerView;

- (void)alertUserToSettingCamera;

@end

@interface HNCodeScannerView : UIView

@property (nonatomic, weak) id <HNCodeScannerViewDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval quietPeriodAfterMatch;

- (void)setMetadataObjectTypes:(NSArray *)metaDataObjectTypes;
- (void)start;
- (void)stop;

@end
