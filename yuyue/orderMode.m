//
//  orderMode.m
//  yuyue
//
//  Created by 肖君 on 16/11/8.
//  Copyright © 2016年 肖君. All rights reserved.
//

#import "orderMode.h"

@implementation orderMode
+ (instancetype)contactWithName:(NSString *)name userid:(NSString *)uuid
{
    orderMode *c = [[self alloc] init];
    c.name = name;
    c.uuid = uuid;
    
    return c;
}


@end
