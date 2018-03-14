//
//  SLAreaPickerView.h
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAreaLocation.h"

@class SLAreaPickerView;

@protocol SLAreaPickerViewDelegate <NSObject>

@optional
- (void)doSLAreaPickerView:(SLAreaLocation *)locArea;
@end

@interface SLAreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <SLAreaPickerViewDelegate> delegate;

- (void)show;
//
-(id)initWithCoder:(NSString*)sProvinceCode
          cityCode:(NSString*)sCityCode
          areaCode:(NSString*)sAreaCode;

@end
