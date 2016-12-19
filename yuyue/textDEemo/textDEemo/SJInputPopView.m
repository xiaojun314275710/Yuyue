//
//  SJInputPopView.m
//  textDEemo
//
//  Created by 邹少军 on 16/8/16.
//  Copyright © 2016年 chengdian. All rights reserved.
//


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define selfWidth kScreenWidth - 40
#define selfHeight 200

#define SJInputViewWidth selfWidth - 20
#define SJInputViewHeight selfHeight - 65

#define BUTTON_Y SJInputViewHeight + 15


#define BtnTitleColor [UIColor colorWithRed:3/255.0 green:162/255.0 blue:253/255.0 alpha:1.0]


#import "SJInputPopView.h"


@interface SJInputPopView ()<UITextViewDelegate>

/** 背景view **/
@property (nonatomic, strong) UIView *backImageView;

/** 弹出视图里面的输入框 **/
@property (nonatomic ,strong) UITextView *inputView;

/** 输入框里面的默认提示文字 **/
@property (nonatomic ,strong) UILabel *placeholder;

/** 取消按钮点击事件 **/
@property (nonatomic, copy) dispatch_block_t cancelBlock;

/** 确定按钮点击事件 **/
@property (nonatomic, copy) confirmClickeBlock confirmBlock;


@end

@implementation SJInputPopView



- (void)popViewWithInputPlaceholder:(NSString *)inputPlaceholder
                        cancelBlock:(dispatch_block_t)cancelBlock
                       confirmBlock:(confirmClickeBlock)confirmBlock
{
    
    
    
    self.cancelBlock = cancelBlock;
    self.confirmBlock = confirmBlock;
    
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
    self.layer.borderWidth = 0;
    self.layer.borderColor = [[UIColor clearColor] CGColor];
    self.backgroundColor = [UIColor whiteColor];
    
    //初始化input输入框
    self.inputView = [[UITextView alloc] init];
    self.inputView.frame = CGRectMake(10, 10, SJInputViewWidth, SJInputViewHeight);
    self.inputView.delegate = self;
    self.inputView.font = [UIFont systemFontOfSize:14.0];
    self.inputView.layer.masksToBounds = YES;
    self.inputView.layer.cornerRadius = 0.0;
    self.inputView.layer.borderWidth = 0.7;
    self.inputView.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];
    self.inputView.backgroundColor = [UIColor whiteColor];
    
    
    self.inputView.scrollEnabled = NO;//禁止拖动
    [self addSubview:self.inputView];
    
    
    self.placeholder = [[UILabel alloc] init];
    self.placeholder.frame = CGRectMake(5, -5, SJInputViewWidth-10, 40);
    self.placeholder.enabled = NO;
    self.placeholder.numberOfLines = 2;
    self.placeholder.font = [UIFont systemFontOfSize:14.0];
    self.placeholder.text = inputPlaceholder;
    self.placeholder.textColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    
    [self.inputView addSubview:self.placeholder];
    
    
    //取消按钮
    
    
    NSInteger width = selfWidth;
    
    CGFloat Buttonwidth = width /2;
    
    self.cancelBtn = [[UIButton alloc] init];
    self.cancelBtn.frame = CGRectMake(0, BUTTON_Y, Buttonwidth , 45);
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:BtnTitleColor forState:UIControlStateNormal];
    [self.cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [self.cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    
    
    
    //确定按钮
    self.confirmBtn = [[UIButton alloc] init];
    self.confirmBtn.frame = CGRectMake(Buttonwidth, BUTTON_Y, Buttonwidth , 45);
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:BtnTitleColor forState:UIControlStateNormal];
    [self.confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [self.confirmBtn addTarget:self action:@selector(clickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.confirmBtn];
    
    
    
    [self show];
    
    
    
}


#pragma mark -- textview delegate --

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length == 0) {
        
        [self.placeholder setHidden:NO];
        
    }else
    {
        
        [self.placeholder setHidden:YES];
        
    }
    
    
}


#pragma mark -- show --

- (void)show
{
    
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake(20, kScreenHeight / 2  - 90, selfWidth, selfHeight);
    
    [topVC.view addSubview:self];
    
}


#pragma mark -- 取消按钮触发事件 --

- (void)clickCancelBtn:(UIButton *)sender
{
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
    [self dismissAlert];
    
}



#pragma mark -- 确定按钮的触发事件 --

- (void)clickConfirmBtn:(UIButton *)sender
{
    
    
    if (self.confirmBlock) {
        self.confirmBlock(self.inputView.text);
    }
    
    [self dismissAlert];
}



- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)dismissAlert
{
    [self removeFromSuperview];
}



- (void)willMoveToSuperview:(UIView *)newSuperview
{
    
    
    
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPress:)];
        tapGesture.numberOfTapsRequired=1;
        [self.backImageView addGestureRecognizer:tapGesture];
        
    }
    [topVC.view addSubview:self.backImageView];
    
    [super willMoveToSuperview:newSuperview];
    
}

- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    
    [super removeFromSuperview];
    
}

-(void)handleTapPress:(UITapGestureRecognizer *)gestureRecognizer
{
    
    [self dismissAlert];
    
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
