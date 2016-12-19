//
//  JXMSwitchitleView.h
//  dsf
//
//  Created by yepiaoyang1 on 16/6/23.
//  Copyright © 2016年 yepiaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSSwitchTitleBtn : UIView

/**
 *  创建封装按钮
 *
 *  @param frame         frame
 *  @param text          按钮文字
 *  @param textColor     正常状态下文字的颜色
 *  @param selectedColor 选择状态下文字颜色
 *  @param lineViewColor 标示线的颜色
 *
 *  @return 封装按钮
 */

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor selectedColor:(UIColor *)selectedColor lineViewColor:(UIColor *)lineViewColor;

@property (nonatomic , assign)BOOL isSelected;

@end


@interface LSSwitchTitleView : UIView

/**
 *  创建选择视图
 *
 *  @param frame         frame
 *  @param titleArray    按钮文字数组
 *  @param textColor     正常状态下文字的颜色
 *  @param selectedColor 选择状态下文字颜色
 *  @param lineViewColor 标示线的颜色
 *  @param bgColor       视图背景颜色
 *  @param selecte       点击事件block
 *
 *  @return 选择视图
 */

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray textColor:(UIColor *)textColor selectedColor:(UIColor *)selectedColor lineViewColor:(UIColor *)lineViewColor bgColor:(UIColor *)bgColor selecte:(void(^)(NSInteger index))selecte;

@end
