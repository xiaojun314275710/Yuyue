//
//  orderViewController.m
//  yuyue
//
//  Created by 肖君 on 16/9/29.
//  Copyright © 2016年 肖君. All rights reserved.
//
#import "orderMode.h"

#import "orderViewController.h"
#import "LCProgressHUD.h"
#import "homeViewController.h"
#import "LSSwitchTitleView.h"
#import "BJDatePickerView.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "CJCalendarViewController.h"
#import "orderCell.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "MyAlertView.h"

#define XJScreenW [UIScreen mainScreen].bounds.size.width
#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define GlobalColor Color(100,149,237)
@interface orderViewController ()<CalendarViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MyAlertViewBtnDelegate>

@property (nonatomic , strong) UITextField* userName ;//姓名
@property (nonatomic , strong) UITextField* userID ;//身份证号
@property (nonatomic , strong) UITextField* phoneText;//电话号码
@property (nonatomic , strong)  UITextField* dateText;//申请日期

@property(nonatomic,strong)BJDatePickerView*datePickerView;
@property(nonatomic,strong) MBProgressHUD *hud;

@property(nonatomic,strong)UITextField*textField;
@property(nonatomic,strong)BJDatePicker*datePicker;
@property (nonatomic , strong)  AFHTTPSessionManager*manager;


@property (nonatomic, strong) UITableView *myTableview;
@property (nonatomic , strong) NSDictionary* Dict;

@end

@implementation orderViewController



- (void)viewDidLoad {
    [super viewDidLoad];
     [self setYuyueUI];
    [self setTabviewUI];
    
    }


#pragma mark -- tabview
-(void)setTabviewUI{
    
    
    _myTableview = [[UITableView alloc] init];
    _myTableview.frame = CGRectMake(0, 190, [UIScreen mainScreen].bounds.size.width,100  );
    _myTableview.delegate = self;
    _myTableview.dataSource = self;
    [self.view addSubview:_myTableview];
    _myTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
   //_myTableview.showsVerticalScrollIndicator = NO;
   [_myTableview registerClass:[orderCell class] forCellReuseIdentifier:NSStringFromClass([orderCell class])];
    
 
   [_myTableview reloadData];
    
    
    
    
}
#pragma mark -- uitableview Delegate 代理 --


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return  self.usersArray.count;
    
    
    
}


#pragma mark - 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
   orderCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([orderCell class])];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.ordermode=self.usersArray[indexPath.row];

   [cell reloadData:cell.ordermode];
   
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    //cell.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.usersArray removeObjectAtIndex: indexPath.row];
        [self.userArray removeObjectAtIndex: indexPath.row];
        
        // Delete the row from the data source.
        [_myTableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_myTableview reloadData];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}



#pragma mark -- UI设置
-(void)setYuyueUI
{

    
    UIImageView*  backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 104, CGRectGetMaxX(self.view.bounds), CGRectGetHeight(self.view.bounds) - 104)];
    [backView setUserInteractionEnabled:YES];
    backView.backgroundColor = [UIColor whiteColor];
    self.view=backView;
    
    UIView*lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 1, XJScreenW, 1)];
    lineview.backgroundColor=[UIColor grayColor];
    lineview.alpha=0.2;
    [backView addSubview:lineview];
    
    UILabel* hintLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0,CGRectGetMaxX(backView.bounds) * 0.5 , 40)];
    hintLab.font = [UIFont systemFontOfSize:13];
    hintLab.text = @"请填写相关信息";
    [backView addSubview:hintLab];
  
    UIButton*adBtn=[[UIButton alloc]initWithFrame:CGRectMake(XJScreenW-38, 10, 30, 30)];
    [adBtn setImage:[UIImage imageNamed:@"圆角矩形-2"] forState:UIControlStateNormal];
    [adBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    adBtn.showsTouchWhenHighlighted = YES;
    [backView addSubview:adBtn];
    
    //姓名
    UILabel*nameLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 40, CGRectGetMaxX(backView.bounds)/2, 40)];
    nameLab.text=@"姓名:";
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(XJScreenW/2, 40, CGRectGetMaxX(backView.bounds) - 10, 40)];
    _userName.delegate=self;
    
    _userName.borderStyle = UITextBorderStyleNone;
    _userName.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _userName.returnKeyType = UIReturnKeyDone;
    _userName.backgroundColor = [UIColor whiteColor];
    _userName.placeholder = @"请输入姓名";
    [backView addSubview:nameLab];
    [backView addSubview:_userName];
    
    //身份证号
    UILabel*userLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 82, CGRectGetMaxX(backView.bounds)/2, 40)];
    userLab.text=@"身份证号:";
    _userID = [[UITextField alloc] initWithFrame:CGRectMake(XJScreenW/2-26, 82, CGRectGetMaxX(backView.bounds) - 10, 40)];
   
    _userID.delegate=self;
    _userID.borderStyle = UITextBorderStyleNone;
    _userID.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _userID.backgroundColor = [UIColor whiteColor];
    _userID.placeholder = @"     请输入身份证号";
    
    [backView addSubview:userLab];
    [backView addSubview:_userID];
    
    //电话号码
    UILabel*phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 122, CGRectGetMaxX(backView.bounds)/2, 40)];
    phoneLab.text=@"电话号码:";
    _phoneText = [[UITextField alloc] initWithFrame:CGRectMake(XJScreenW/2, 122, CGRectGetMaxX(backView.bounds) - 10, 40)];
    _phoneText.delegate = self;
    _phoneText.borderStyle = UITextBorderStyleNone;
    _phoneText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _phoneText.backgroundColor = [UIColor whiteColor];
    _phoneText.placeholder = @"请输入电话号码";
    [backView addSubview:phoneLab];
    [backView addSubview:_phoneText];
    
   UILabel*btn=[[UILabel alloc]initWithFrame:CGRectMake(5, 165, 60, 30)];
    btn.text=@"已添加";
  
    btn.textColor=GlobalColor;

    
    [backView addSubview:btn];
    
 
    
    //申请探监日期
    UILabel*dateLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 280, CGRectGetMaxX(backView.bounds)/2, 40)];
    dateLab.text=@"申请探监日期:";
    _dateText = [[UITextField alloc] initWithFrame:CGRectMake(XJScreenW/2, 280, CGRectGetMaxX(backView.bounds) - 10, 40)];
    _dateText.delegate = self;
    _dateText.borderStyle = UITextBorderStyleNone;
    _dateText.keyboardType = UIKeyboardTypeASCIICapable;
    _dateText.backgroundColor = [UIColor whiteColor];
    _dateText.placeholder = @"请输入探监日期";
    self.textField=_dateText;
    [backView addSubview:dateLab];
    [backView addSubview:_dateText];
    
    
    
    
    UIButton* loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(5, 330, CGRectGetMaxX(backView.bounds) - 10, 40);
    loginBtn.layer.cornerRadius = 5;
    loginBtn.clipsToBounds = YES;
    loginBtn.tag = 2;
    loginBtn.showsTouchWhenHighlighted = YES;
    [loginBtn setBackgroundColor:GlobalColor];
    [loginBtn setTintColor:[UIColor whiteColor]];
    [loginBtn setTitle:@"申请" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(applyClick) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:loginBtn];
    
    
    
}
-(void)addApplyData
{
    NSDictionary* mDictionary= @{@"uuid":_userID.text,@"phone":_phoneText.text,@"name":_userName.text};
    [self.userArray addObject:mDictionary];

    _usersArray = [orderMode mj_objectArrayWithKeyValuesArray:self.userArray];
    NSLog(@"-------%@",self.usersArray);
    [_myTableview reloadData];

}


- (void) addBtnClicked:(id)sender
{
  

    MyAlertView *alertView = [[MyAlertView alloc] initWithFrame:CGRectMake(0, XJScreenH*0.5, XJScreenW, XJScreenH*0.5)];
    alertView.delegate=self;
    [alertView show];
    
}

-(void)saveClickButton :(UIButton*)saveBtn{
    
    
    UITextField *name = [saveBtn.superview viewWithTag:100];
    
    UITextField *phone=[saveBtn.superview viewWithTag:300];
    UITextField *uuid=[saveBtn.superview viewWithTag:200];
    
    //if (name.text.length||phone.text.length||uuid.text.length) {
        NSString*jiamiSting=[self changeSting:uuid.text];
  
        NSDictionary* mDictionary= @{@"uuid":jiamiSting,@"phone":phone.text,@"name":name.text};
        [self.userArray addObject:mDictionary];
        if (name.text==_userName.text||uuid.text==_userID.text||phone.text==_phoneText.text) {
        [LCProgressHUD showInfoMsg:@"申请信息不能相同"];
        }
    //}
    
    
        _usersArray = [orderMode mj_objectArrayWithKeyValuesArray:self.userArray];
        NSLog(@"-------%@",self.usersArray);
        [_myTableview reloadData];

    
    
    
}
#pragma mark -- 身份证号码加密
-(NSString*)changeSting:(NSString*)string
{
    NSMutableString *stringM = [NSMutableString string];
    NSDictionary *dict = @{@"0":@"*",@"1":@"&",@"2":@"%",@"3":@"#",@"4":@"@",@"5":@"Q",@"6":@"P",@"7":@"D",@"8":@"S",@"9":@"B"};
    for (int i = 0; i < [string length]; i++) {
        NSString *subString = [string substringWithRange:(NSRange){i,1}];
        if ([[dict allKeys] containsObject:subString]) {
            [stringM appendString:dict[subString]];
        } else {
            [stringM appendString:subString];
        }
    }
    return stringM;
}


-(NSString*)changesting:(NSString*)string
{
    NSMutableString *stringM = [NSMutableString string];
    NSDictionary *dict = @{@"*":@"0",@"&":@"1",@"%":@"2",@"#":@"3",@"@":@"4",@"Q":@"5",@"P":@"6",@"D":@"7",@"S":@"8",@"B":@"9"};
    for (int i = 0; i < [string length]; i++) {
        NSString *subString = [string substringWithRange:(NSRange){i,1}];
        if ([[dict allKeys] containsObject:subString]) {
            [stringM appendString:dict[subString]];
        } else {
            [stringM appendString:subString];
        }
    }
    return stringM;
}



#pragma mark -- 网络请求
-(void)applyClick
{

//    
   NSString *orgCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"orgCode"];
     NSString* encryptSting=[self changeSting:_userID.text];
//    NSDictionary *dict = @{@"fillingDate":_dateText.text,@"orgCode":orgCode,@"phone":_phoneText.text,@"uuid":encryptSting};
//
    
//    NSDictionary *para = @{@"application":dict};
  self.Dict=@{@"fillingDate":_dateText.text,@"orgCode":orgCode,@"phone":_phoneText.text,@"uuid":encryptSting,@"family":self.userArray};
       NSDictionary *para = @{@"application":self.Dict};
    NSLog(@"%@",para);
   
    if (_phoneText.text.length==0 || _dateText.text.length==0 ||_userID.text.length==0  || _userName.text.length==0)
    
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"请填写完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        
        

    }
    else if ([self judgeIdentityStringValid:_userID.text]==0){

        
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"身份证号码不合法" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        
    }
    else if ([self isMobileNumber:_phoneText.text]==0){
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"电话号码不合法" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        
        
        
    }

    
    else {
     
        [LCProgressHUD showLoading:@"正在申请"];
        NSString*url=@"http://103.37.158.17:3000/api/v1/applies";
            [self.manager POST:url parameters:para success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",responseObject);
             
             if (([responseObject[@"code"]intValue]==200)) {
                [NSTimer scheduledTimerWithTimeInterval:2.0
                                                 target:self
                                               selector:@selector(showSuccess)
                                               userInfo:nil
                                                repeats:NO];
                      }
             else if ([responseObject[@"code"]intValue]==404){
                 //[LCProgressHUD hide];
                 NSString*uuidStng=responseObject[@"msg"];
                NSString*ChangeSting= [self changesting:uuidStng];
                 NSString*sting1=@"没有权限";
                NSString* string = [ChangeSting stringByAppendingString:sting1 ];
                 [LCProgressHUD showFailure:string];
             }
             else if ([responseObject[@"code"]intValue]==400){
                 //[LCProgressHUD hide];
                 [LCProgressHUD showFailure:@"已申请当日会见，请勿重复提交"];
             }
             else if ([responseObject[@"code"]intValue]==302){
                 //[LCProgressHUD hide];
                 [LCProgressHUD showFailure:@"该日司法所会见已满"];
             }
             else if ([responseObject[@"code"]intValue]==500){
                 //[LCProgressHUD hide];
                 [LCProgressHUD showFailure:@"服务器错误"];
             }
             else {
                 //[LCProgressHUD hide];
                 NSString*failSting=responseObject[@"msg"];
                 [LCProgressHUD showMessage:failSting];
             }
                NSInteger code = [responseObject[@"code"] integerValue];
          }
                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                       NSLog(@"NSError:%@",error);
                       
                       //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                       dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                       dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                           
                           });
                       
                   }];
    }
  
    
}

-(void)showSuccess
{
        [LCProgressHUD showSuccess:@"申请提交成功"];
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [LCProgressHUD hide];
    });

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

#pragma mark -- 正则表达式
// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}
- (BOOL)judgeIdentityStringValid:(NSString *)identityString {
    
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}
//昵称
-(BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}





#pragma mark -- 懒加载
- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        // _manager= [AFHTTPRequestOperationManager  manager];
        
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

-(NSMutableArray *)userArray{
    
    if (!_userArray) {
        _userArray=[[NSMutableArray alloc]init];
   
    
            }
    
    return _userArray;
}
-(NSMutableArray *)usersArray{
    
    if (!_usersArray) {
        _usersArray=[[NSMutableArray alloc]init];
        
        
    }
    
    return _usersArray;
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
