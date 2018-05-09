//
//  ADView.m
//  Portal
//
//  Created by linpeng on 2018/5/9.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "ADView.h"
#import "Masonry.h"

@interface ADView()

@property(nonatomic, strong) UIImageView * imgView;
@property(nonatomic, strong) UILabel * titlelb;

@end

@implementation ADView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imgView = [[UIImageView alloc] init];
        [self addSubview:self.imgView];
        
        self.titlelb = [[UILabel alloc] init];
        self.titlelb.textColor = [UIColor darkTextColor];
        self.titlelb.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.titlelb];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.height.equalTo(@40);
            make.top.equalTo(self).offset(10);
        }];
        
        [self.titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imgView);
            make.top.equalTo(self.imgView.mas_bottom).offset(3);
        }];
        
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titlelb.text = [title copy];
}

-(void)setImage:(UIImage *)image {
    self.imgView.image = [image copy];
}


@end
