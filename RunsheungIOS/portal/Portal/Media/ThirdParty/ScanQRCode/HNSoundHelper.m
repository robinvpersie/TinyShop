//
//  HNSoundHelper.m
//  惠农码
//
//  Created by Liangpx on 13-12-14.
//  Copyright (c) 2013年 HuiNongKeJi. All rights reserved.
//

#import "HNSoundHelper.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation HNSoundHelper

static NSMutableDictionary *soundDictionary = nil;


+ (void)initialize {
    if (soundDictionary == nil) {
        soundDictionary = [NSMutableDictionary new];
    }
}

+ (void)clearSoundCache {
    for (NSNumber *n in soundDictionary.allValues) {
        AudioServicesDisposeSystemSoundID([n unsignedIntegerValue]);
    }
    [soundDictionary removeAllObjects];
}

+ (void)playSoundFromURL:(NSURL *)soundFileURL asAlert:(BOOL)alert {
    SystemSoundID soundId;
    
    id key = [soundFileURL absoluteString];
    NSNumber *n = [soundDictionary objectForKey:key];
    
    if (n == nil && key) {
        
        if (soundFileURL && AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundFileURL, &soundId) == noErr) {
            n = [NSNumber numberWithUnsignedInteger:soundId];
            [soundDictionary setObject:n forKey:key];
        }
    }
    
    soundId = [n unsignedIntegerValue];
    
    if (soundId) {
        if (alert) {
            AudioServicesPlayAlertSound(soundId);
        } else {
            AudioServicesPlaySystemSound(soundId);
        }
    }
}

+ (void)playSoundFromFile:(NSString *)soundFileName fromBundle:(NSBundle *)bundle asAlert:(BOOL)alert {
    NSString *extension = [soundFileName pathExtension];
    NSString *basename = [soundFileName stringByDeletingPathExtension];
    
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    
    NSURL *alertSound = soundFileName ? [bundle URLForResource: basename
                                                 withExtension: extension] : nil;
    
    [self playSoundFromURL:alertSound asAlert:alert];
}

@end
