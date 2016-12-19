//
//  ViewController.m
//  yuyue
//
//  Created by 肖君 on 16/9/28.
//  Copyright © 2016年 肖君. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "NIMSDK.h"
#import "Reachability.h"
#import "LCProgressHUD.h"

#import "homeViewController.h"
#define XJScreenW [UIScreen mainScreen].bounds.size.width
#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define GlobalColor Color(100,149,237)
#define TIME 1.0f
@interface ViewController ()<NIMLoginManagerDelegate,NIMSystemNotificationManager,NIMSystemNotificationManagerDelegate,NIMTeamManagerDelegate>


@property(nonatomic,strong) UIButton *loginBtn;//登录按钮
@property(nonatomic,strong) UIImageView *backView;
@property(nonatomic,strong) UITextField *textField;
@property(nonatomic,strong) MBProgressHUD *hud;
@property(nonatomic,strong) MBProgressHUD *alert;
@property(nonatomic,assign) AFNetworkReachabilityStatus status;
@property (nonatomic , retain) NSTimer *timer;


@property (nonatomic,strong) AFHTTPSessionManager *manager;

@property (nonatomic , strong) NSMutableArray* mesArray;
@property(nonatomic,assign) NSInteger i;
@property(nonatomic,strong) NSString *mark;
@property(nonatomic,strong) NSString *account;
@property(nonatomic,strong) NSString *token;

@end

@implementation ViewController

//懒加载
- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];

        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
      [_manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain",@"application/json",@"text/xml",@"text/javascript"]];
    }
    return _manager;
}
-(NSMutableArray*) mesArray
{
    if (!_mesArray) {
        _mesArray=[[NSMutableArray alloc]init];
    }

    return _mesArray;

}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithRed:99/255.0 green:149/255.0 blue:236/255.0 alpha:1];
    [self customeNavBar];
    [self setUI];
    [self showNetStatus];
    
 
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    //[self isConnectionAvailable];

}

-(void)viewDidDisappear:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

}



#pragma mark - 检查网络

- (void)showNetStatus
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        _status = status;
        if (status == AFNetworkReachabilityStatusNotReachable)
        {
             [LCProgressHUD showFailure:@"当前网络不可用，请检查网络是否连接"];
        }
    }];
    [manager startMonitoring];
    
}
#pragma mark -- UI
- (void)customeNavBar
{
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetMaxX(self.view.bounds),44)];
    _titleLab.font = [UIFont systemFontOfSize:17];
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.text = @"登录";
    [self.view addSubview:_titleLab];
}


-(void)setUI
{
    _backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetMaxX(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64)];
    [_backView setUserInteractionEnabled:YES];
    _backView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    _hintLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0,CGRectGetMaxX(_backView.bounds) * 0.5 , 40)];
    _hintLab.font = [UIFont systemFontOfSize:13];
    _hintLab.text = @"请输入工作人员信息";
    [_backView addSubview:_hintLab];
    
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(5, 40, CGRectGetMaxX(_backView.bounds) - 10, 40)];
    _userName.delegate = self;
    _userName.borderStyle = UITextBorderStyleRoundedRect;
    _userName.keyboardType = UIKeyboardTypeDefault;
    _userName.returnKeyType = UIReturnKeyDone;
    _userName.backgroundColor = [UIColor whiteColor];
    _userName.placeholder = @"账号";
    [_backView addSubview:_userName];
    
    _userID = [[UITextField alloc] initWithFrame:CGRectMake(5, 82, CGRectGetMaxX(_backView.bounds) - 10, 40)];
    _userID.delegate = self;
    _userID.borderStyle = UITextBorderStyleRoundedRect;
    _userID.keyboardType = UIKeyboardTypeASCIICapable;
    _userID.backgroundColor = [UIColor whiteColor];
    _userID.placeholder = @"密码";
    _userID.secureTextEntry=YES;
    [_backView addSubview:_userID];
    
   
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(5, 175, CGRectGetMaxX(_backView.bounds) - 10, 40);
    _loginBtn.layer.cornerRadius = 5;
    _loginBtn.clipsToBounds = YES;
    _loginBtn.tag = 2;
    _loginBtn.showsTouchWhenHighlighted = YES;
    [_loginBtn setBackgroundColor:GlobalColor];
    [_loginBtn setTintColor:[UIColor whiteColor]];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_loginBtn];
  

    [self.view addSubview:_backView];

    


}
-(void)userInteractionEnabled
{
    _loginBtn.userInteractionEnabled=NO;
    

}
- (void)showSuccess {
    
    [LCProgressHUD showSuccess:@"登录成功"];
}
-(void)clickBtn:(UIButton*)send
{
   // _loginBtn.userInteractionEnabled=NO;
    if(_loginBtn.selected) return;
   _loginBtn.selected=YES;
    [self performSelector:@selector(timeEnough) withObject:nil afterDelay:2.0];
    //3秒后又可以处理点击事件了
    
    
  NSDictionary *dict=@{@"userid":self.userName.text,@"password":self.userID.text,};
     // NSDictionary *dict=@{@"userid":@"aks003",@"password":@"123456",};
  NSDictionary *para= @{@"session":dict};
  NSString*url=@"http://103.37.158.17:3000/api/v1/login";

    [self.manager POST:url parameters:para success:^(NSURLSessionDataTask *task, id responseObject)
    {
        [LCProgressHUD showLoading:@"正在登录"];
        [NSTimer scheduledTimerWithTimeInterval:TIME
                                         target:self
                                       selector:@selector(showSuccess)
                                       userInfo:nil
                                        repeats:NO];

        
        _token=responseObject[@"user"][@"cloudMsg"] [@"token"];
        _account=responseObject[@"user"][@"cloudMsg"] [@"cloudID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"orgCode"];
//        
       [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cloudtoken"];
        // 向文件写入内容
        [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"user"][@"token"] forKey:@"token"];
         [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"user"][@"orgnization"] [@"code"]forKey:@"orgCode"];
        
        [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"user"][@"cloudMsg"] [@"cloudID"]forKey:@"account"];
        [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"user"][@"cloudMsg"] [@"token"]forKey:@"cloudtoken"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        id<NIMSystemNotificationManager> systemNotificationManager = [[NIMSDK sharedSDK] systemNotificationManager];
        [systemNotificationManager addDelegate:self];
        
        NSArray *notifications = [systemNotificationManager fetchSystemNotifications:nil
                                                                               limit:20];
     
        [[[NIMSDK sharedSDK] loginManager] login:_account
                                           token:_token
                                      completion:^(NSError *error) {  NSLog(@"**^^^^**%@",error);  }];
        ;
        
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          
            homeViewController*homeVC=[[homeViewController alloc]init];
            [self.navigationController pushViewController:homeVC animated:YES];
        });
        
        
    }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   
                   
                   //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                   
                   if ([error.description containsString:@"404"]) {
//                       NSString*falil=@"用户名或密码错误";
//                       
//                       [self showAnimate:falil];
                         [LCProgressHUD showFailure:@"用户名或密码错误"];
                 

                   } else if ([error.description containsString:@"400"]) {
                       [LCProgressHUD showFailure:@"用户名或密码错误"];
                       //NSString*falil=@"用户名或密码错误";
                       //[self showAnimate:falil];
                   }
                   else {
                       [LCProgressHUD showFailure:@"服务器错误"];
                       
                   }
                   
                   
                   
                
                   
                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                   
                   NSLog(@"%@",error);
                   
               }];

 

}

- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
    
    NSLog(@"  onReceiveCustomSystemNotification  ");
    NSString *content = notification.content;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"内容：%@",notification.content);
    [self.mesArray addObject:notification.content];
 
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sysMessage"];
    // 向文件写入内容
    [[NSUserDefaults standardUserDefaults]setObject:self.mesArray forKey:@"sysMessage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"转换得到的数组：%@",self.mesArray);
    
}


-(void)timeEnough
{
    _loginBtn.selected=NO;
    [_timer invalidate];
    _timer=nil;

}

#pragma mark - MBProgress
- (void)showAnimate:(NSString *)content
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = content;
    _hud.animationType = MBProgressHUDAnimationFade;
    _hud.mode = MBProgressHUDModeIndeterminate;
    
    [_hud hide:YES afterDelay:3.5];
}

#pragma mark - UIAlertView
- (void)showAlertHint:(NSString *)text
{
    _alert = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _alert.labelText = text;
    _alert.mode = MBProgressHUDModeText;
    [self performSelector:@selector(alertDismiss) withObject:nil afterDelay:3.5];
}
- (void)alertDismiss
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
  
}

@end
