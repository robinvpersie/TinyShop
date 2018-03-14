//
//  HZLocation.m
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import "SLAreaLocation.h"

@implementation SLAreaLocation

-(id)init{
    self=[super init];
    if(self){
        self.sProvinceCode=@"";
        self.sProvinceName=@"";
        self.sCityCode=@"";
        self.sCityName=@"";
        self.sAreaCode=@"";
        self.sAreaName=@"";
    }
    return self;
}
@end
