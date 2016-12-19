//
//  SJViewModel.h
//  textDEemo
//
//  Created by 邹少军 on 16/8/16.
//  Copyright © 2016年 chengdian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJViewModel : NSObject

/** 问问题的用户头像 **/

@property (nonatomic ,copy) NSString *askHeadImage;
/** 问问题的用户名称 **/

@property (nonatomic ,copy) NSString *askName;
/** 问题内容 **/

@property (nonatomic ,copy) NSString *askContent;


/** 回答问题的用户头像 **/

@property (nonatomic ,copy) NSString *replyHead;
/** 回答问题的用户名称 **/

@property (nonatomic ,copy) NSString *replyName;
/** 回答内容 **/

@property (nonatomic ,copy) NSString *replyContent;

@end
