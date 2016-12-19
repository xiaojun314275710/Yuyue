//
//  passWordViewController.m
//  yuyue
//
//  Created by 肖君 on 16/10/8.
//  Copyright © 2016年 肖君. All rights reserved.
//

#import "passWordViewController.h"
#import "homeViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "ViewController.h"


#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define GlobalColor Color(100,149,237)
@interface passWordViewController ()


@property(nonatomic,strong) UITextField *oldPasswordLab;
@property(nonatomic,strong) UITextField *PasswordLab;
@property(nonatomic,strong) UITextField *confirmPasswordLab;
@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UIImageView *backView;

@property (nonatomic , strong) UIButton* backBtn;
@property(nonatomic,strong) UIButton *confirmBtn;

@property(nonatomic,strong) UITextField *textField;

@property (nonatomic , strong)  AFHTTPSessionManager*manager;

@property(nonatomic,strong) MBProgressHUD *hud;
@end

@implementation passWordViewController

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
    [self setUI];
    
    
    
    
}

- (void)customeNavBar
{
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetMaxX(self.view.bounds),44)];
    _titleLab.font = [UIFont systemFontOfSize:17];
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.text = @"修改密码";
    
    _backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    
    
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    
    [_backBtn addTarget:self
                 action:@selector(backItemClick)
       forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_titleLab];
    [self.view addSubview:_backBtn];
}


-(void)setUI
{
    _backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetMaxX(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64)];
    [_backView setUserInteractionEnabled:YES];
    _backView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    
    _oldPasswordLab = [[UITextField alloc] initWithFrame:CGRectMake(5, 40, CGRectGetMaxX(_backView.bounds) - 10, 40)];
    _oldPasswordLab.delegate = self;
    _oldPasswordLab.borderStyle = UITextBorderStyleRoundedRect;
    _oldPasswordLab.keyboardType = UIKeyboardTypeDefault;
    _oldPasswordLab.returnKeyType = UIReturnKeyDone;
    _oldPasswordLab.backgroundColor = [UIColor whiteColor];
    _oldPasswordLab.placeholder = @"原密码";
    [_backView addSubview:_oldPasswordLab];
    
    _PasswordLab = [[UITextField alloc] initWithFrame:CGRectMake(5, 82, CGRectGetMaxX(_backView.bounds) - 10, 40)];
    _PasswordLab.delegate = self;
    _PasswordLab.borderStyle = UITextBorderStyleRoundedRect;
    _PasswordLab.keyboardType = UIKeyboardTypeASCIICapable;
    _PasswordLab.backgroundColor = [UIColor whiteColor];
    _PasswordLab.placeholder = @"新密码";
    _PasswordLab.secureTextEntry=YES;
    [_backView addSubview:_PasswordLab];
    
    
    _confirmPasswordLab=[[UITextField alloc] initWithFrame:CGRectMake(5, 124, CGRectGetMaxX(_backView.bounds) - 10, 40)];
    _confirmPasswordLab.delegate = self;
    _confirmPasswordLab.borderStyle = UITextBorderStyleRoundedRect;
    _confirmPasswordLab.keyboardType = UIKeyboardTypeASCIICapable;
    _confirmPasswordLab.backgroundColor = [UIColor whiteColor];
    _confirmPasswordLab.placeholder = @"确定密码";
    _confirmPasswordLab.secureTextEntry=YES;
    [_backView addSubview: _confirmPasswordLab];
    
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(5, 225, CGRectGetMaxX(_backView.bounds) - 10, 40);
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.clipsToBounds = YES;
    _confirmBtn.tag = 2;
    _confirmBtn.showsTouchWhenHighlighted = YES;
    [_confirmBtn setBackgroundColor:GlobalColor];
    [_confirmBtn setTintColor:[UIColor whiteColor]];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_confirmBtn];
    [self.view addSubview:_backView];
    
    
    
    
    
    
    
}
-(void)clickBtn
{
    NSDictionary *dict = @{@"newPassword":_PasswordLab.text};
    
    
    NSDictionary *para = @{@"user":dict};
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString*baseUrl=@"http://103.37.158.17:3000/api/v1/users/";
    
    NSString*url=[baseUrl stringByAppendingString:token];
    
    if (_confirmPasswordLab.text!=_PasswordLab.text) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"密码不匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
    } else {
        
   
    
    
        
            [self.manager  PUT:url parameters:para success:^(NSURLSessionDataTask * task, id  responseObject) {
                NSString*scufulString=@"密码修改成功";
                
                [self showAnimate:scufulString];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    ViewController*homeVC=[[ViewController alloc]init];
                    [self.navigationController pushViewController:homeVC animated:YES];
                });
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
    
    
         }
    
}

-(void)backItemClick
{
    
    
    
    [self.navigationController popViewControllerAnimated:YES ];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    
}


#pragma  mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _textField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - MBProgress
- (void)showAnimate:(NSString *)content
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = content;
    _hud.animationType = MBProgressHUDAnimationFade;
    _hud.mode = MBProgressHUDModeIndeterminate;
    
    [_hud hide:YES afterDelay:3.0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
