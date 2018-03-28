//
//  InputFieldView.h
//  Portal
//
//  Created by 이정구 on 2018/3/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputFieldView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic, copy) NSString * placeHolder;
@property(nonatomic, strong) UIFont * font;
@property(nonatomic, copy) NSString * text;

@end
