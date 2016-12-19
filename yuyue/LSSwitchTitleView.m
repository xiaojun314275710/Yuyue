//
//  JXMSwitchitleView.m
//  dsf
//
//  Created by yepiaoyang1 on 16/6/23.
//  Copyright © 2016年 yepiaoyang. All rights reserved.
//

#import "LSSwitchTitleView.h"
#import "orderViewController.h"

@interface LSSwitchTitleBtn ()
{
    UIColor *_selectedColor;
    UIColor *_textColor;
    UILabel *_titleLabel;
    UIView *_linView;
}
@end

@implementation LSSwitchTitleBtn

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

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor selectedColor:(UIColor *)selectedColor lineViewColor:(UIColor *)lineViewColor {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _textColor = textColor;
        _selectedColor = selectedColor;

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _titleLabel.text =  text;
        _titleLabel.textColor = textColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _linView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 2 ,CGRectGetWidth(self.frame) , 2)];
        _linView.backgroundColor = lineViewColor;
        _linView.hidden = YES;
        [self addSubview:_linView];
        
    }
    return self;
}


//重写setter方法
- (void)setIsSelected:(BOOL)isSelected
{
    if (isSelected) {
        _titleLabel.textColor = _selectedColor;
        _linView.hidden = NO;
    }else{
        _titleLabel.textColor = _textColor;
        _linView.hidden = YES;
    }
}

@end


@interface LSSwitchTitleView ()
{
    LSSwitchTitleBtn *_selectedBtn;
    void (^_selectedBlock)(NSInteger index);
    NSMutableArray *_switchBtnArray;
}
@end

@implementation LSSwitchTitleView

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

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray textColor:(UIColor *)textColor selectedColor:(UIColor *)selectedColor lineViewColor:(UIColor *)lineViewColor bgColor:(UIColor *)bgColor selecte:(void(^)(NSInteger index))selecte
{
    self = [super initWithFrame:frame];
    if (self) {
        _switchBtnArray = [NSMutableArray array];
        self.backgroundColor  = bgColor;
        _selectedBlock = selecte;
        
            for (int i = 0; i < titleArray.count; i ++) {
            
            LSSwitchTitleBtn *btn = [[LSSwitchTitleBtn alloc] initWithFrame:CGRectMake(self.frame.size.width / titleArray.count * i, 0, self.frame.size.width / titleArray.count, self.frame.size.height) text:titleArray[i] textColor:textColor selectedColor:selectedColor lineViewColor:lineViewColor];
            [self addSubview:btn];
//            btn.tag = 2000 + i;
            [_switchBtnArray  addObject:btn];
                
            UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selecteAction:)];
            [btn addGestureRecognizer:g];
            
            if (i == 0) {
                btn.isSelected = YES;
                _selectedBtn = btn;
               
            }
        }
        
    }
    return self;
}


- (void)selecteAction:(UITapGestureRecognizer *)g {
    
    LSSwitchTitleBtn *switchTitleBtn = (LSSwitchTitleBtn *)g.view;
    if (_selectedBtn == switchTitleBtn) {
        return;
    }
    
    _selectedBtn.isSelected = NO;
    switchTitleBtn.isSelected = YES;
    _selectedBtn = switchTitleBtn;
    
//    if (_selectedBlock) {
//        _selectedBlock(g.view.tag - 2000);
//    }
    
    if (_selectedBlock) {
        for (NSInteger i = 0; i < _switchBtnArray.count; i ++) {
            LSSwitchTitleBtn *btn = _switchBtnArray[i];
            if (_selectedBtn == btn) {
             _selectedBlock(i);
                break;
            }
        }
    }
    
}

@end
