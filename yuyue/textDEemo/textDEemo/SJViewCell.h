//
//  SJViewCell.h
//  textDEemo
//
//  Created by 邹少军 on 16/8/16.
//  Copyright © 2016年 chengdian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJViewModel.h"



@interface SJViewCell : UITableViewCell

/** 问问题的用户头像 **/

@property (nonatomic ,strong) UIImageView *askHeadImage;
/** 问问题的用户名称 **/

@property (nonatomic ,strong) UILabel *askName;
/** 问题内容 **/

@property (nonatomic ,strong) UILabel *askContent;


/** 回答问题的用户头像 **/

@property (nonatomic ,strong) UIImageView *replyHead;
/** 回答问题的用户名称 **/

@property (nonatomic ,strong) UILabel *replyName;
/** 回答内容 **/

@property (nonatomic ,strong) UILabel *replyContent;



- (void)reloadData:(SJViewModel *)sjViewModel;


@end
