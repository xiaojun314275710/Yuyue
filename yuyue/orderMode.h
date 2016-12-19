//
//  orderMode.h
//  yuyue
//
//  Created by 肖君 on 16/11/8.
//  Copyright © 2016年 肖君. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderMode : NSObject<NSCoding>
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *uuid;

@property (nonatomic , strong) NSString* phone;
+ (instancetype)contactWithName:(NSString *)name userid:(NSString *)userid;
@end
