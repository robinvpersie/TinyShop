//
//  KLHomeCollectionViewCell.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/2.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "KLHomeCollectionViewCell.h"

@interface KLHomeCollectionViewCell ()

@end

@implementation KLHomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.cornerRadius = 4;
    self.imageView.clipsToBounds = YES;
    // Initialization code
}

@end
