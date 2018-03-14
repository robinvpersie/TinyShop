//
//  HNCodeScannerView.m
//  惠农码
//
//  Created by Liangpx on 13-12-14.
//  Copyright (c) 2013年 HuiNongKeJi. All rights reserved.
//

#import "HNCodeScannerView.h"
#import "HNCodeScannerMatchView.h"
#import <AVFoundation/AVFoundation.h>
#import "HNSoundHelper.h"
#import "HNCodeScannerCoverView.h"
//#import "UIAlertView+SLAdditions.h"

@interface HNCodeScannerView () <AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) HNCodeScannerMatchView *matchView;
@property (nonatomic, strong) NSDate *lastDetectionDate;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;
@property (nonatomic, strong) HNCodeScannerCoverView *coverView;

@end

@implementation HNCodeScannerView {
    NSTimer *_timer;
    BOOL _scanning;
    BOOL _wasScanning;
    BOOL _canScan;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _captureSession = nil;
    _previewLayer = nil;
    _matchView = nil;
    _lastDetectionDate = nil;
    _metadataOutput = nil;
    _coverView = nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _canScan = YES;
        self.frame = frame;
        self.captureSession = [[AVCaptureSession alloc] init];
        [self.captureSession setSessionPreset:AVCaptureSessionPreset640x480];
        
        AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([videoCaptureDevice lockForConfiguration:&error]) {
            if (videoCaptureDevice.isAutoFocusRangeRestrictionSupported) {
                [videoCaptureDevice setAutoFocusRangeRestriction:AVCaptureAutoFocusRangeRestrictionNear];
            }
            if ([videoCaptureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                [videoCaptureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            }
            [videoCaptureDevice unlockForConfiguration];
        } else {
            NSLog(@"Could not configure video capture device: %@", error.localizedDescription);
            _canScan = NO;
        }
        
        AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
        if(videoInput) {
            [self.captureSession addInput:videoInput];


            self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
            self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [self.layer addSublayer:self.previewLayer];

            self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
            [self.captureSession addOutput:self.metadataOutput];
            [self.metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//            [self setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeQRCode]];
            [self setMetadataObjectTypes:@[ AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode]];
//            AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode
            
            //放大焦距
            
            NSError *error = nil;
            
            [videoCaptureDevice lockForConfiguration:&error];
            
            
            
            if (videoCaptureDevice.activeFormat.videoMaxZoomFactor > 2) {
                
                videoCaptureDevice.videoZoomFactor = 2;
                
            }else{
                
                videoCaptureDevice.videoZoomFactor = videoCaptureDevice.activeFormat.videoMaxZoomFactor;
                
            }
            
        } else {
            NSLog(@"Could not create video input: %@", error.localizedDescription);
            _canScan = NO;
           
        }
        self.matchView = [[HNCodeScannerMatchView alloc] initWithFrame:self.bounds];
//        [self addSubview:self.matchView];
        self.quietPeriodAfterMatch = 2.0;

        HNCodeScannerCoverView *coverView =  [[HNCodeScannerCoverView alloc] initWithFrame:self.bounds];
        self.coverView = coverView;
        [self addSubview:coverView];
        [coverView setScannerState:kScannerStateStart];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deactivate)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:[UIApplication sharedApplication]];
        
        // Register for notification that app did enter foreground
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(activate)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:[UIApplication sharedApplication]];
        
        
    
        
    }
    return self;
}



- (void)setMetadataObjectTypes:(NSArray *)metaDataObjectTypes {
    [self.metadataOutput setMetadataObjectTypes:metaDataObjectTypes];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewLayer.frame = self.bounds;
    self.matchView.frame = self.bounds;
    
    /*
     //Doesn't work for some reason: CGAffineTransform error
    CGRect rect = [self.previewLayer metadataOutputRectOfInterestForRect:self.previewLayer.bounds];
    self.metadataOutput.rectOfInterest = rect;
    */ 
}

- (void)start {
    if (!_scanning) {
        _scanning = YES;
        [self.matchView reset];
        [self.captureSession startRunning];
        
        if(_canScan){
            [self.coverView setScannerState:kScannerStateScanning];
        }else{
            if([self.delegate respondsToSelector:@selector(alertUserToSettingCamera)]){
                [self.delegate alertUserToSettingCamera];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(scannerViewDidStartScanning:)] && _canScan) {
            [self.delegate scannerViewDidStartScanning:self];
        }
    }
    
}

- (void)stop {
    if (_scanning) {
        _scanning = NO;
        [_timer invalidate];
        _timer = nil;
        [self.captureSession stopRunning];
        
        if(_canScan){
            [self.coverView setScannerState:kScannerStateStop];
        }
        
        if ([self.delegate respondsToSelector:@selector(scannerViewDidStopScanning:)] && _canScan) {
            [self.delegate scannerViewDidStopScanning:self];
        }
    }
}

- (void)deactivate {
    _wasScanning = _scanning;
    [self stop];
}

- (void)activate {
    if (_wasScanning) {
        [self start];
        _wasScanning = NO;
    }
}

- (CGPoint)pointFromArray:(NSArray *)points atIndex:(NSUInteger)index {
    NSDictionary *dict = [points objectAtIndex:index];
    CGPoint point;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)dict, &point);    
    return [self.matchView convertPoint:point fromView:self];
}

- (BOOL)isInQuietPeriod {
    return self.lastDetectionDate != nil && (-[self.lastDetectionDate timeIntervalSinceNow]) <= self.quietPeriodAfterMatch;
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([self isInQuietPeriod]) {
        return;
    }
//    [self.captureSession stopRunning];
    for(AVMetadataObject *metadataObject in metadataObjects)
    {
        if ([metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
            BOOL foundMatch = readableObject.stringValue != nil;
            NSArray *corners = readableObject.corners;
            if (corners.count == 4 && foundMatch) {
                    [self stop];
                 [HNSoundHelper playSoundFromFile:@"BEEP.mp3" fromBundle:[NSBundle mainBundle] asAlert:YES];
//                [self performSelector:@selector(beep) withObject:nil afterDelay:0.1];
                CGPoint topLeftPoint = [self pointFromArray:corners atIndex:0];
                CGPoint bottomLeftPoint = [self pointFromArray:corners atIndex:1];
                CGPoint bottomRightPoint = [self pointFromArray:corners atIndex:2];
                CGPoint topRightPoint = [self pointFromArray:corners atIndex:3];
                
//                if (CGRectContainsPoint(self.matchView.bounds, topLeftPoint) &&
//                    CGRectContainsPoint(self.matchView.bounds, topRightPoint) &&
//                    CGRectContainsPoint(self.matchView.bounds, bottomLeftPoint) &&
//                    CGRectContainsPoint(self.matchView.bounds, bottomRightPoint))
//                {
//                    [self stop];
//                    _timer = [NSTimer scheduledTimerWithTimeInterval:self.quietPeriodAfterMatch target:self selector:@selector(start) userInfo:nil repeats:NO];
                    self.lastDetectionDate = [NSDate date];

                    [self.matchView setFoundMatchWithTopLeftPoint:topLeftPoint
                                    topRightPoint:topRightPoint
                                  bottomLeftPoint:bottomLeftPoint
                                 bottomRightPoint:bottomRightPoint];
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pushSomeThing:) object:nil];
                    [self performSelector:@selector(pushSomeThing:) withObject:[NSArray arrayWithObjects:readableObject.stringValue,[NSNumber numberWithInteger:corners.count], nil] afterDelay:1];
//                    [self.delegate scannerView:self didReadCode:readableObject.stringValue withPointsCount:corners.count];
//                }
            }
        }
    }
}

- (void)pushSomeThing:(NSArray *)array
{
   [self.delegate scannerView:self didReadCode:[array objectAtIndex:0] withPointsCount:[[array objectAtIndex:1] integerValue]];
}

@end
