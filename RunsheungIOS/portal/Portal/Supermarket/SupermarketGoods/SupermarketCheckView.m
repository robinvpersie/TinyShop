//
//  SupermarketCheckView.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/9.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketCheckView.h"
#import "UILabel+WidthAndHeight.h"

#define itemWidth self.frame.size.width/3

@implementation SupermarketCheckView
{
    UILabel *_msg_0;
    UILabel *_msg_1;
    UILabel *_msg_2;
    
    UIImageView *checkOne;
    UIImageView *checkTwo;
    UIImageView *checkThree;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(246, 246, 246);
        [self initView];
    }
    return self;
}

- (void)initView {
    checkOne = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, self.frame.size.height - 14, self.frame.size.height - 14)];
    checkOne.image = [UIImage imageNamed:@"icon_selected-s"];
    [self addSubview:checkOne];
    if (_msg_0 == nil) {
        _msg_0 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(checkOne.frame)+5, 5, itemWidth, checkOne.frame.size.height)];
        _msg_0.textColor = [UIColor grayColor];
        _msg_0.text = NSLocalizedString(@"SMGoodsSend", nil);
        _msg_0.font = [UIFont systemFontOfSize:12];
    }
    [self addSubview:_msg_0];
    
    checkTwo = [[UIImageView alloc] initWithFrame:CGRectMake(itemWidth, checkOne.frame.origin.y, checkOne.frame.size.width, checkOne.frame.size.height)];
    checkTwo.image = [UIImage imageNamed:@"icon_selected-s"];
    [self addSubview:checkTwo];
    if (_msg_1 == nil) {
        _msg_1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(checkTwo.frame)+5, checkOne.frame.origin.y, itemWidth, checkOne.frame.size.height)];
        _msg_1.textColor = [UIColor grayColor];
        _msg_1.text = NSLocalizedString(@"SMGoodsRefund", nil);
        _msg_1.font = [UIFont systemFontOfSize:12];
    }
    [self addSubview:_msg_1];
    
    if (_msg_2 == nil) {
        _msg_2 = [[UILabel alloc] initWithFrame:CGRectMake(0, checkOne.frame.origin.y, 0, checkOne.frame.size.height)];
        _msg_2.textColor = [UIColor grayColor];
        _msg_2.text = NSLocalizedString(@"SMGoodsPickFreeExpress", nil);
        _msg_2.font = [UIFont systemFontOfSize:12];
        
        CGFloat width = [UILabel getWidthWithTitle:_msg_2.text font:_msg_2.font];
        CGRect frame = _msg_2.frame;
        frame.size.width = width;
        frame.origin.x = self.frame.size.width - width - 10;
        _msg_2.frame = frame;
    }
    [self addSubview:_msg_2];
    
    checkThree = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_msg_2.frame) -  5 - checkOne.frame.size.width, checkOne.frame.origin.y, checkOne.frame.size.width, checkOne.frame.size.height)];
    checkThree.image = [UIImage imageNamed:@"icon_selected-s"];
    [self addSubview:checkThree];
    
    _msg_0.hidden = YES;
    _msg_1.hidden = YES;
    _msg_2.hidden = YES;
    
    checkOne.hidden = YES;
    checkTwo.hidden = YES;
    checkThree.hidden = YES;
}

- (void)setMsgArray:(NSArray *)msgArray {
    _msgArray = msgArray;
    
    switch (msgArray.count) {
        case 0:
            
            break;
            
        case 1:
            _msg_0.text = msgArray[0];
            checkOne.hidden = NO;
            _msg_0.hidden = NO;
            break;
        
        case 2:
            _msg_0.text = msgArray[0];
            _msg_1.text = msgArray[1];
            
            _msg_0.hidden = NO;
            _msg_1.hidden = NO;
            checkOne.hidden = NO;
            checkTwo.hidden = NO;
            break;
            
        case 3:
            _msg_0.text = msgArray[0];
            _msg_1.text = msgArray[1];
            _msg_2.text = msgArray[2];
            _msg_0.hidden = NO;
            _msg_1.hidden = NO;
            _msg_2.hidden = NO;
            checkOne.hidden = NO;
            checkTwo.hidden = NO;
            checkThree.hidden = NO;
            break;
        default:
            break;
    }
}

@end
