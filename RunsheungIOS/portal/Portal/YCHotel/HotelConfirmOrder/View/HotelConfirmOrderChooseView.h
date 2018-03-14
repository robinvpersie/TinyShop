//
//  HotelChooseView.h
//  Portal
//
//  Created by ifox on 2017/4/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HotelConfirmOrderChooseView;

@protocol  HotelConfirmOrderChooseViewDelegate <NSObject>

@optional

- (void)didSelectedRowTitle:(NSString *)title
                  indexPath:(NSIndexPath *)indexPath
                 chooseView:(HotelConfirmOrderChooseView *)chooseView;

@end

@interface HotelConfirmOrderChooseView : UIView

@property(nonatomic, strong) NSArray *dataSource;//数据源
@property(nonatomic, copy) NSString *title;//标题
@property(nonatomic, weak) id<HotelConfirmOrderChooseViewDelegate> delegate;
@property(nonatomic, assign) BOOL defaultChoose;//是否有默认选择

- (void)showInView:(UIView *)view;

- (void)removeView;

@end
