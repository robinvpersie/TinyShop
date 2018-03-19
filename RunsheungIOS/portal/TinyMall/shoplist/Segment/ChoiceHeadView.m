//
//  ChoiceHeadView.m
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/8.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import "ChoiceHeadView.h"
#import "Masonry.h"

static const CGFloat arrWidth = 11;
static const CGFloat locationWidth = 12;

@interface ChoiceHeadView ()

@property (nonatomic, strong) UIButton *invisibleBtn;
@property (nonatomic, strong) UILabel * contentlb;
@property (nonatomic, strong) UIImageView *arrImgView;
@property (nonatomic, strong) UIImageView *locationImgView;

@end

@implementation ChoiceHeadView

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		[self createSubviews];
	}
	return self;
}

- (void)createSubviews{
	
	
    self.contentlb = [[UILabel alloc] init];
	self.contentlb.textColor = [UIColor darkTextColor];
	self.contentlb.textAlignment = NSTextAlignmentCenter;
	self.contentlb.font = [UIFont systemFontOfSize:15];
	[self addSubview:self.contentlb];
	
	self.locationImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location"]];
//    redlocation.frame = CGRectMake(CGRectGetMinX(label.frame)-16, 8, 12, 14);
	[self addSubview:self.locationImgView];
	
	self.arrImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_down"]];
//    arrowImg.frame = CGRectMake(CGRectGetMaxX(label.frame) +3, 13 , 10, 8);
	[self addSubview:self.arrImgView];
    
    self.invisibleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.invisibleBtn];
    [self.invisibleBtn addTarget:self action:@selector(showPopView) forControlEvents:UIControlEventTouchUpInside];

}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.addressName != nil) {
        [self.locationImgView setHidden:NO];
        [self.arrImgView setHidden:NO];
        CGFloat largestWidth = 200 - arrWidth - locationWidth - 3 - 4;
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        CGSize contentsize = [self.addressName boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        if (contentsize.width >= largestWidth) {
            self.contentlb.frame = CGRectMake(self.frame.size.width - largestWidth - arrWidth, 0, largestWidth, 30);
        }else {
            CGFloat x = self.frame.size.width - contentsize.width - 16 - 11;
            self.contentlb.frame = CGRectMake(x/2.0 + 16, 0, contentsize.width, 30);
        }
    }
    self.locationImgView.frame = CGRectMake(CGRectGetMinX(self.contentlb.frame) -16, 8, locationWidth, 14);
    self.arrImgView.frame = CGRectMake(CGRectGetMaxX(self.contentlb.frame) + 3, 13, arrWidth, 8);
    self.invisibleBtn.frame = self.frame;
}

-(void)setAddressName:(NSString *)addressName {
    _addressName = [addressName copy];
    self.contentlb.text = _addressName;
    [self setNeedsLayout];
}

-(void)showPopView {
    if (_showAction != nil) {
        _showAction();
    }
}


@end
