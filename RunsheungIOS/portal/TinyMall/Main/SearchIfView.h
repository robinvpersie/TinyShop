//
//  SearchIfView.h
//  Portal
//
//  Created by dlwpdlr on 2018/5/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^paramterDicBlock)(NSMutableDictionary *dic);

@interface SearchIfView : UIView
@property(nonatomic,retain)NSArray*datas;
@property(nonatomic,retain)NSDictionary *dic;
@property (nonatomic,copy)NSString *currentStr;
@property (nonatomic,retain)NSMutableDictionary *resquestDic;
@property (nonatomic,copy)paramterDicBlock paramterdic;

- (instancetype)initWithFrame:(CGRect)frame;
@end
