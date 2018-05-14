//
//  ADHeaderCell.h
//  Portal
//
//  Created by linpeng on 2018/5/9.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^headBlock)(int index);
@interface ADHeaderCell : UITableViewCell
@property (nonatomic,copy) headBlock headblock;
@end

