//
//  SJInputPopView.h
//  textDEemo
//
//  Created by 邹少军 on 16/8/16.
//  Copyright © 2016年 chengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^confirmClickeBlock) (NSString *inputStr);


@interface SJInputPopView : UIView

/** 确定按钮 **/
@property (nonatomic ,strong) UIButton *confirmBtn;

/** 取消按钮 **/
@property (nonatomic ,strong) UIButton *cancelBtn;

/**
 * @param inputPlaceholder   输入框的默认文字
 * @param cancelBlock   取消按钮的block
 * @param confirmBlock   确认按钮的block
 */
- (void)popViewWithInputPlaceholder:(NSString *)inputPlaceholder
                        cancelBlock:(dispatch_block_t)cancelBlock
                       confirmBlock:(confirmClickeBlock)confirmBlock;

@end
