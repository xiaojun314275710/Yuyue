//
//  homeViewController.m
//  yuyue
//
//  Created by 肖君 on 16/9/29.
//  Copyright © 2016年 肖君. All rights reserved.
//


#import "ViewController.h"
#import "homeViewController.h"
#import "LSSwitchTitleView.h"
#import "BJDatePickerView.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"

#import "orderViewController.h"
#import "searchViewController.h"
#import "messageViewController.h"

#import "passWordViewController.h"
#import "phoneViewController.h"


#import "XTPopView.h"
#import "NIMSDK.h"

#define XJScreenW [UIScreen mainScreen].bounds.size.width
#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define GlobalColor Color(100,149,237)


@interface homeViewController ()<selectIndexPathDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)BJDatePickerView*datePickerView;
@property(nonatomic,strong) MBProgressHUD *hud;

@property(nonatomic,strong)UITextField*textField;
@property(nonatomic,strong)BJDatePicker*datePicker;
@property (nonatomic , strong)  AFHTTPSessionManager*manager;

@property (nonatomic , strong) UITextField* userName ;//姓名
@property (nonatomic , strong) UITextField* userID ;//身份证号
@property (nonatomic , strong) UITextField* phoneText;//电话号码
@property (nonatomic , strong)  UITextField* dateText;//申请日期

@property (nonatomic, strong) UIButton *customBtn;
@property (nonatomic , strong)   orderViewController *ordervc;
@property (nonatomic , strong)   searchViewController *searchvc;
@property (nonatomic , strong)   messageViewController *messageVC;
@property (nonatomic , strong) ViewController* viewVC;

@property (nonatomic , strong) XTPopView *popHeadview;

@property (nonatomic ,assign) NSInteger index;

@end

@implementation homeViewController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
       [self setHeadView];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //[self setHeadView];

   _ordervc=[[orderViewController alloc]init];
   [self.view addSubview:_ordervc.view];
     _ordervc.view.frame = CGRectMake(0, 104, self.view.bounds.size.width, self.view.bounds.size.height-104);
    ;
    LSSwitchTitleView *switchTitleView = [[LSSwitchTitleView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40) titleArray:@[@"预约" , @"查询" , @"消息"] textColor: [UIColor blackColor] selectedColor:GlobalColor lineViewColor: GlobalColor  bgColor:[UIColor whiteColor ] selecte:^(NSInteger index) {
       
        if (index==0) {
            [self.view addSubview:_ordervc.view];
            [self addChildViewController:_ordervc];
        _ordervc.view.frame = CGRectMake(0, 104, self.view.bounds.size.width, self.view.bounds.size.height-104);
       
            [self.searchvc.view removeFromSuperview];
            [self.messageVC.view removeFromSuperview];
           
        }
        else if (index==1){

//           searchViewController*seachVC=[[searchViewController alloc]init];
           [self.view addSubview:self.searchvc.view];
            [self addChildViewController:self.searchvc];
            
         
            [self.ordervc.view removeFromSuperview];
            [self.messageVC.view removeFromSuperview];
            
        }
        
        else {

//            messageViewController*messageVC=[[messageViewController alloc]init];
            [self.view addSubview:self.messageVC.view];
            [self addChildViewController:self.messageVC];
            
            [self.viewVC.view removeFromSuperview];
            [self.ordervc.view removeFromSuperview];
            [self.searchvc.view removeFromSuperview];
            
            
            
            
        }

        
    }];
       [self.view addSubview:switchTitleView];
}


-(void)setHeadView
{
  
    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, XJScreenW, 64)];
    headView.backgroundColor=GlobalColor;
    
    UILabel* titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetMaxX(self.view.bounds),44)];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"预约助手";
    [headView addSubview:titleLab];
    
 
    
    UIButton *scaleUpButton = [[UIButton alloc]init];
    [scaleUpButton setTitle:@"设置" forState:UIControlStateNormal];
     scaleUpButton.font = [UIFont systemFontOfSize:17];
    scaleUpButton.frame = CGRectMake(XJScreenW-40, 20, 40, 40);
    [scaleUpButton addTarget:self
                      action:@selector(setupbtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:scaleUpButton];
    [self.view addSubview:headView];
    _customBtn=scaleUpButton;

}
- (void)setupbtnClick:(UIButton *)btn
{
  
    
       CGPoint point = CGPointMake(_customBtn.center.x,_customBtn.frame.origin.y + 64);
    XTPopView *view1 = [[XTPopView alloc] initWithOrigin:point Width:130 Height:40 * 3 Type:XTTypeOfRightUp Color:[UIColor colorWithRed:0.2737 green:0.2737 blue:0.2737 alpha:1.0]];
        self.popHeadview=view1;
    view1.dataArray = @[@"修改密码",@"清空系统消息",@"注销 ",];
    view1.fontSize = 13;
    view1.row_height = 40;
    view1.titleTextColor = [UIColor whiteColor];
    view1.delegate = self;
    [view1 popView];
}
- (void)selectIndexPathRow:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            
            passWordViewController*passwordVC=[[passWordViewController alloc]init];
            [self.navigationController pushViewController:passwordVC animated:YES];
            
        }
            break;
        case 1:
        {
            
//            phoneViewController*phoneVC=[[phoneViewController alloc]init];
//            [self.navigationController pushViewController:phoneVC animated:YES];
            messageViewController*mesVC=[[messageViewController alloc]init];
             // [self.navigationController pushViewController:_messageVC animated:YES];
           

            
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sysMessage"];
            
            
            
          
        }
            break;
        case 2:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你确定要注销？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
           
            alert.alertViewStyle = UIAlertViewStyleDefault;
            
            [alert show];
            [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error){}];
        
          
        }
        case 3:
        {
            
            NSLog(@"Clikc 3 ......");
        }

            break;
        default:
            break;
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clickButtonAtIndex:%d",(int)buttonIndex);
    if (buttonIndex==1) {
        
        ViewController*homeVC=[[ViewController alloc]init];
        [self.navigationController pushViewController:homeVC animated:YES];
    }

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark----UITextFieldDelegate----
//无遮盖 输入框进入编辑状态 BJDatePicker替换键盘
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField==self.textField) {
        self.textField.inputView=self.datePicker;
    }
}
//收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
    

}

- (orderViewController *)ordervc{
    if (!_ordervc) {
        _ordervc = [[orderViewController alloc]init];
    }
    return _ordervc;
}

- (searchViewController *)searchvc{
    if (!_searchvc) {
        _searchvc = [[searchViewController alloc]init];
    }
    return _searchvc;
}

- (messageViewController *)messageVC{
    if (!_messageVC) {
        _messageVC = [[messageViewController alloc]init];
    }
    return _messageVC;
}
//懒加载
- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [_manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain",@"application/json",@"text/xml",@"text/javascript"]];
    }
    return _manager;
}

-(BJDatePickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView=[BJDatePickerView shareDatePickerView];
        WS(ws);
        [_datePickerView datePickerViewDidSelected:^(NSString *date) {
            //赋值
            ws.textField.text=date;
        }];
        
    }
    return _datePickerView;
}

-(BJDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker=[BJDatePicker shareDatePicker];
        WS(ws);
        [_datePicker datePickerDidSelected:^(NSString *date) {
            //赋值
            ws.textField.text=date;
            //收键盘
            [ws.textField resignFirstResponder];
        }];
        
    }
    return _datePicker;
}



@end
