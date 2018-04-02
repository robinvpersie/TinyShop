//
//  FindSearchView.h
//  Portal
//
//  Created by dlwpdlr on 2018/3/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^inputKeyWordBlock)(NSString *keyword);
@interface FindSearchView : UIView<UITextFieldDelegate>
@property (nonatomic,copy)inputKeyWordBlock inputkeyworkBlock;
@end
