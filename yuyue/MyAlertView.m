

#import "MyAlertView.h"
#import "UIView+Frame.h"
#import "MBProgressHUD.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define GlobalColor Color(100,149,237)


@interface MyAlertView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic,strong) UIView *alertBgView;



@property (nonatomic , strong) UITextField* userName ;//姓名
@property (nonatomic , strong) UITextField* userID ;//身份证号
@property (nonatomic , strong) UITextField* phoneText;//电话号码
@end


@implementation MyAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;

        
        
        UIView *Witeview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        Witeview.backgroundColor=[UIColor whiteColor];
        [self addSubview:Witeview];
        

        
        
        CGFloat w =Witeview.frame.size.width;
        
        UILabel *goodsName=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, w/3, 40)];
        goodsName.text=@"姓名：";
        goodsName.textAlignment=NSTextAlignmentCenter;
        goodsName.font=[UIFont systemFontOfSize:14];
        [Witeview addSubview:goodsName];
        
        UIView*lineView1=[[UIView alloc]initWithFrame:CGRectMake(40, 67, w-60, 1)];
        lineView1.backgroundColor=[UIColor grayColor];
        [Witeview addSubview:lineView1];
        
        UITextField *goodsTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsName.frame)+3, 25, 3*w/2, 40)];
        goodsTF.tag = 100;
        
        goodsTF.borderStyle = UITextBorderStyleNone;
        goodsTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        goodsTF.returnKeyType = UIReturnKeyDone;
        goodsTF.backgroundColor = [UIColor whiteColor];
        goodsTF.placeholder = @"请输入姓名";
        [Witeview addSubview:goodsTF];
        
        UILabel *sortLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(goodsName.frame)+25 , w/3, 40)];
        sortLabel.text=@"身份证号：";
        sortLabel.textAlignment=NSTextAlignmentCenter;
        sortLabel.font=[UIFont systemFontOfSize:14];
        [Witeview addSubview:sortLabel];
        
        UIView*lineView2=[[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(sortLabel.frame)+5, w-60, 1)];
        lineView2.backgroundColor=[UIColor grayColor];
        [Witeview addSubview:lineView2];
        
        UITextField *sortTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sortLabel.frame)+3, CGRectGetMaxY(goodsTF.frame)+24, 2*w/3, 40)];
        sortTF.tag = 200;

        sortTF.borderStyle = UITextBorderStyleNone;
        sortTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        sortTF.returnKeyType = UIReturnKeyDone;
        sortTF.backgroundColor = [UIColor whiteColor];
        sortTF.placeholder = @"请输入身份证号码";
        [Witeview addSubview:sortTF];
        
        UILabel *phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(sortLabel.frame)+25 , w/3, 40)];
        phoneLabel.text=@"电话号码：";
        phoneLabel.textAlignment=NSTextAlignmentCenter;
        phoneLabel.font=[UIFont systemFontOfSize:14];
        [Witeview addSubview:phoneLabel];
        
        UIView*lineView3=[[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(phoneLabel.frame)+5, w-60, 1)];
        lineView3.backgroundColor=[UIColor grayColor];
        [Witeview addSubview:lineView3];

        UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sortLabel.frame)+3, CGRectGetMaxY(sortTF.frame)+24, 3*w/2, 40)];
        phoneTF.tag = 300;

        
        phoneTF.borderStyle = UITextBorderStyleNone;
        phoneTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        phoneTF.returnKeyType = UIReturnKeyDone;
        phoneTF.backgroundColor = [UIColor whiteColor];
        phoneTF.placeholder = @"请输入电话号码";
        [Witeview addSubview:phoneTF];
        
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(self.alertBgView.width-43,-6,50, 50);
        [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setImage:[UIImage imageNamed:@"notice_close"]forState:UIControlStateNormal];
        [ self.alertBgView addSubview:cancelBtn];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake((self.width-90)*0.5,CGRectGetMaxY(phoneTF.frame)+38,90, 27);
        [confirmBtn  setBackgroundColor:GlobalColor];
        [confirmBtn setTintColor:[UIColor whiteColor]];
        confirmBtn.layer.cornerRadius = 5;
        [confirmBtn addTarget:self action:@selector(saveClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn setTitle:@"添加" forState:UIControlStateNormal];
        [Witeview addSubview:confirmBtn];
        

        
        [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification  object:nil];
    }
    return self;
}


-(void)cancelClick:(UIButton*)canlBtn{

    [self close];
}

-(void)saveClickButton:(UIButton*)saveBtn{
    
    if ([self.delegate respondsToSelector:@selector(saveClickButton:)]) {
        [self.delegate saveClickButton:saveBtn];
    }
    
    
    UITextField *name = [saveBtn.superview viewWithTag:100];
    
    UITextField *phone=[saveBtn.superview viewWithTag:300];
    UITextField *uuid=[saveBtn.superview viewWithTag:200];
    [self close];
    
  
}
- (void)show
{
    if (self.bgView) return;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.bgView addGestureRecognizer:tap];
    
    self.bgView.userInteractionEnabled = YES;
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.2;
    [window addSubview:self.bgView];
    [window addSubview:self];
    
}

- (void)close
{
    [self.bgView removeFromSuperview];
     self.bgView = nil;
    [self removeFromSuperview];

}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [self close];
}

- (void)keyboardWillChange:(NSNotification  *)notification
{
    
    // 1.获取键盘的Y值
    NSDictionary *dict  = notification.userInfo;
    CGRect keyboardFrame = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardFrame.origin.y;
    // 获取动画执行时间
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    // 2.计算需要移动的距离
    CGFloat selfY = keyboardY - self.height - 50;
    
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        // 需要执行动画的代码
        self.y = selfY;
        self.bgView.alpha = 0.5;
    } completion:^(BOOL finished) {
        // 动画执行完毕执行的代码
        if (_bgView == nil) {
            //  [self.textField resignFirstResponder];
            [self removeFromSuperview];
        }
    }];
}

@end
