//
//  orderCell.h
//  yuyue
//
//  Created by 肖君 on 16/11/7.
//  Copyright © 2016年 肖君. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJCalendarViewController.h"
#import "LSSwitchTitleView.h"
#import "BJDatePickerView.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "orderMode.h"

@interface orderCell : UITableViewCell
@property (nonatomic , strong) UILabel* nameLab ;//姓名
@property (nonatomic , strong) UILabel* userLab ;//身份证号

@property (nonatomic , strong) orderMode *ordermode;
- (void)reloadData:(orderMode *)ordermode;
@end
