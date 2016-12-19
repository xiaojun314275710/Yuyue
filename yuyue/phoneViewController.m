//
//  phoneViewController.m
//  yuyue
//
//  Created by 肖君 on 16/10/8.
//  Copyright © 2016年 肖君. All rights reserved.
//

#import "phoneViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "ViewController.h"


#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define GlobalColor Color(100,149,237)
#define XJScreenW [UIScreen mainScreen].bounds.size.width
@interface phoneViewController ()

@property(nonatomic,strong)UITextField*textField;
@property (nonatomic , strong) UITextField* phoneText;//电话号码
@property(nonatomic,strong) UILabel *titleLab;
@property (nonatomic , strong) UIButton* backBtn;
@property(nonatomic,strong) UIImageView *backView;
@property (nonatomic , strong)  AFHTTPSessionManager*manager;

@property(nonatomic,strong) MBProgressHUD *hud;
@end

@implementation phoneViewController


#pragma mark -- 懒加载
- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [_manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain",@"application/json",@"text/xml",@"text/javascript"]];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSLog(@"-----%@-----",token );
        
        
        //NSString*strToken=[NSString stringWithFormat:@"57e4c8035af7a460cc9b18fc"];
        
        [ _manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:99/255.0 green:149/255.0 blue:236/255.0 alpha:1];
    [self customeNavBar];
    [self setYuyueUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)customeNavBar
{
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetMaxX(self.view.bounds),44)];
    _titleLab.font = [UIFont systemFontOfSize:17];
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.text = @"设置手机号码";
    
    _backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    
    
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    
    [_backBtn addTarget:self
                 action:@selector(backItemClick)
       forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_titleLab];
    [self.view addSubview:_backBtn];
}

-(void)setYuyueUI
{
    _backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetMaxX(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64)];
    [_backView setUserInteractionEnabled:YES];
    _backView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    
    
    
    
    UILabel* hintLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 10,CGRectGetMaxX(_backView.bounds) * 0.8 , 40)];
    hintLab.font = [UIFont systemFontOfSize:15];
    hintLab.text = @"请工作人员修改手机号码：";
    [_backView addSubview:hintLab];
    
    UIView*lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 42, XJScreenW, 1)];
    lineview.backgroundColor=[UIColor grayColor];
    lineview.alpha=0.2;
    [_backView addSubview:lineview];
    
    
    //电话号码
    
    _phoneText = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, CGRectGetMaxX(_backView.bounds) - 20, 40)];
    _phoneText.delegate = self;
    _phoneText.borderStyle = UITextBorderStyleNone;
    _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    _phoneText.backgroundColor = [UIColor whiteColor];
    _phoneText.placeholder = @"请输入电话号码";
    
    [_backView addSubview:_phoneText];
    
    
    
    UIButton* loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(5, 210, CGRectGetMaxX(_backView.bounds) - 10, 40);
    loginBtn.layer.cornerRadius = 5;
    loginBtn.clipsToBounds = YES;
    loginBtn.tag = 2;
    
    loginBtn.showsTouchWhenHighlighted = YES;
    [loginBtn setBackgroundColor:GlobalColor];
    [loginBtn setTintColor:[UIColor whiteColor]];
    [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_backView addSubview:loginBtn];
    
    [self.view addSubview:_backView];
    
}

-(void)confirmClick
{
    NSDictionary *dict = @{@"phone":_phoneText.text};
    
    
    NSDictionary *para = @{@"user":dict};
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString*baseUrl=@"http://103.37.158.17:3000/api/v1/users/";
    
    NSString*url=[baseUrl stringByAppendingString:token];
    
    
    
    [self.manager  PUT:url parameters:para success:^(NSURLSessionDataTask * task, id  responseObject) {
        NSString*scufulString=@"手机号码修改成功";
        
        [self showAnimate:scufulString];
    
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
    
    
    
}

-(void)backItemClick
{
    
    
    [self.navigationController popViewControllerAnimated:YES ];
    
    
    
}
#pragma mark - MBProgress
- (void)showAnimate:(NSString *)content
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = content;
    _hud.animationType = MBProgressHUDAnimationFade;
    _hud.mode = MBProgressHUDModeIndeterminate;
    
    [_hud hide:YES afterDelay:1.5];
}


@end
