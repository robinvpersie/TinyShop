//
//  SupermarketHomeAdview.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SupermarketHomeAdviewDelegate <NSObject>

- (void)clickAdViewIndex:(NSInteger)index;

@end

@interface SupermarketHomeAdview : UIView

@property(nonatomic, strong) UIImageView *imageView1;
@property(nonatomic, strong) UIImageView *imageView2;
@property(nonatomic, strong) UIImageView *imageView3;

@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, weak)   id<SupermarketHomeAdviewDelegate>delegate;

@end
