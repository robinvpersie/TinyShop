//
//  CompanyAuthController.h
//  Portal
//
//  Created by 이정구 on 2018/3/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyAuthController : UIViewController

@property(nonatomic,copy)NSString *mempwd;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *custom_name;
@property(nonatomic,copy)NSString *top_zip_code;
@property(nonatomic,copy)NSString *top_addr_head;
@property(nonatomic,copy)NSString *top_addr_detail;

@end
