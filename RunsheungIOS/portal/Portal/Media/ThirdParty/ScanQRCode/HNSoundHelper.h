//
//  HNSoundHelper.h
//  惠农码
//
//  Created by Liangpx on 13-12-14.
//  Copyright (c) 2013年 HuiNongKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNSoundHelper : NSObject

+ (void)clearSoundCache;
+ (void)playSoundFromURL:(NSURL *)soundFileURL asAlert:(BOOL)alert;
+ (void)playSoundFromFile:(NSString *)soundFileName fromBundle:(NSBundle *)bundle asAlert:(BOOL)alert;

@end
