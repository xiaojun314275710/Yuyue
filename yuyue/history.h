//
//  history.h
//  yuyue
//
//  Created by 肖君 on 16/10/10.
//  Copyright © 2016年 肖君. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "feedback.h"
@interface history : NSObject
@property (nonatomic , strong) NSString *_id;
@property (nonatomic , strong)  NSString*fillingDate;
@property (nonatomic , strong) feedback *feedback;

@end
