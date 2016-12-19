//
//  orderViewController.h
//  yuyue
//
//  Created by 肖君 on 16/9/29.
//  Copyright © 2016年 肖君. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderMode.h"
@interface orderViewController : UIViewController
@property (nonatomic , strong) orderMode *ordermode;
@property (nonatomic , strong) NSMutableArray *userArray;


@property (nonatomic , strong) NSMutableArray*usersArray;
-(NSString*)changeSting:(NSString*)string;
@end
