//
//  YCShareModel.m
//  Portal
//
//  Created by ifox on 2017/2/21.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCShareModel.h"

@implementation YCShareModel

- (void)setPhone_number:(NSString *)phone_number {
    _phone_number = phone_number;
    YCAccountModel *model =  [YCAccountModel getAccount];
    _phone_number = model.memid;
}

- (void)setPassword:(NSString *)password {
    _password = password;
    YCAccountModel *model =  [YCAccountModel getAccount];
    _password = model.password;
}

- (void)setItem_code:(NSString *)item_code {
    _item_code = item_code;
    if (item_code.length == 0) {
        _item_code = @"item_code";
    }
}

- (void)setToken:(NSString *)token {
    _token = token;
    YCAccountModel *model =  [YCAccountModel getAccount];
    _token = model.token;
}

@end
