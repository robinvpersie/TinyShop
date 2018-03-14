//
//  SupermarketClassfictionView.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClassificationViewDelegate <NSObject>

@optional

- (void)clickAtIndex:(NSInteger)index;

@end

@interface SupermarketClassfictionView : UIImageView

@property(nonatomic, weak) id<ClassificationViewDelegate> delegate;

-(void)reloadWithVersion:(NSString *)version state:(NSString *)state;


@end
