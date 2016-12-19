//
//  NSString+NUll.m
//  textDEemo
//
//  Created by 邹少军 on 16/8/16.
//  Copyright © 2016年 chengdian. All rights reserved.
//

#import "NSString+NUll.h"

@implementation NSString (NUll)



- (BOOL) isBlankString:(NSString *)string {
    
    if (string == nil || string== NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}

+ (BOOL)stringIsNull:(NSString *)string
{
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if (!string || [string isKindOfClass:[NSNull class]] || string.length == 0 || [string isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
    
    
}


@end
