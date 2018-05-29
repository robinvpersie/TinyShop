//
//  PopDomainInputView.h
//  Portal
//
//  Created by dlwpdlr on 2018/5/27.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^submitBlock)(NSMutableArray *data);

@interface PopDomainInputView : UIView<UITextFieldDelegate>
- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic,retain)UIView *coverView;
@property (nonatomic,retain)NSMutableArray *fieldDatas;
@property (nonatomic,copy)submitBlock submitblock;

@end
