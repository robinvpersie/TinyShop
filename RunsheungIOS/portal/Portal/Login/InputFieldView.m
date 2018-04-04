//
//  InputFieldView.m
//  Portal
//
//  Created by 이정구 on 2018/3/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "InputFieldView.h"

@interface InputFieldView () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField * field;

@end

@implementation InputFieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.field = [[UITextField alloc] initWithFrame:CGRectZero];
        self.field.delegate = self;
        self.field.textColor = [UIColor darkTextColor];
        [self addSubview:self.field];
        [self.field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).offset(10);
            make.centerY.mas_equalTo(self);
            make.trailing.mas_equalTo(self).offset(-10);
            make.height.mas_equalTo(self).multipliedBy(0.75);
        }];
        
        
    }
    return self;
}


-(void)setFont:(UIFont *)font {
    self.field.font = font;
}

-(void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = [placeHolder copy];
    self.field.placeholder = _placeHolder;
}

-(NSString *)text {
    return self.field.text;
}
-(void)setSecureEntry:(BOOL)secureEntry{
	self.field.secureTextEntry = secureEntry;
}

#pragma textFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
