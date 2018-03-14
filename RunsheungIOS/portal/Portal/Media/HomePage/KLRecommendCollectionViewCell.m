//
//  KLRecommendCollectionViewCell.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/3.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "KLRecommendCollectionViewCell.h"

@implementation KLRecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _statusLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _statusLabel.layer.borderWidth = 1.0f;
    _statusLabel.layer.cornerRadius = 10.5f;
    _statusLabel.hidden = YES;
    _imageView.layer.cornerRadius = 5;
    _imageView.clipsToBounds = YES;
    // Initialization code
}

@end
