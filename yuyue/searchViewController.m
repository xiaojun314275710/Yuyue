//
//  searchViewController.m
//  yuyue
//
//  Created by 肖君 on 16/9/29.
//  Copyright © 2016年 肖君. All rights reserved.
//
#import "UITableView+LSEmpty.h"
#import "LSStretchableTableHeaderView.h"
#import "searchViewController.h"
#import "CJCalendarViewController.h"
#import "AFNetworking.h"
#import "SJViewCell.h"
#import "SJViewModel.h"
#import "UIView+WHC_AutoLayout.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "history.h"
#import "MBProgressHUD.h"
#import "ZQTColorSwitch.h"
#import "LCProgressHUD.h"
#define XJScreenW [UIScreen mainScreen].bounds.size.width
#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define GlobalColor Color(100,149,237)
//#define PASSED YES
//#define DENIED NO

@interface searchViewController ()<CalendarViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UIButton *startDate;//查询开始时间
@property (nonatomic , strong) UIButton* endDate;//查询结束时间

@property (nonatomic, weak) UIButton *CJButton;
@property (nonatomic , strong)  AFHTTPSessionManager*manager;
@property (nonatomic,strong)  ZQTColorSwitch *nkColorSwitch1;
@property (nonatomic , assign) BOOL isPass;

@property (nonatomic , strong) NSString *Pass;

@property (nonatomic , strong) NSArray* users;
//tabelview

@property (nonatomic, strong) UITableView *myTableview;

@property (nonatomic ,strong) NSMutableArray *myDataSource;
@property(nonatomic,strong) MBProgressHUD *hud;
@end

@implementation searchViewController




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
   
        
        //NSString*strToken=[NSString stringWithFormat:@"57e4c8035af7a460cc9b18fc"];
        
        [ _manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        
    }
    return _manager;
}

- (void)switchIsChanged:(UISwitch *)paramSender
{
    if ([_nkColorSwitch1 isOn])
    {
        _isPass=YES;
        _Pass=@"PASSED";
        NSLog(@"Switch is on");
    }
    else{
             _isPass=NO;
             _Pass=@"DENIED";
        }
}


#pragma mark -- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setUI];
    [self setTabviewUI];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
     //[_nkColorSwitch1 setOn:NO animated:YES];
      _Pass=@"DENIED";
    // _rmbSwitch.thumbTintColor = [UIColor colorWithRed:(151./255.0) green:(81./255.0) blue:(229./255.0) alpha:1];

}


-(void)setUI{
    self.view.backgroundColor=[UIColor whiteColor];
    self.view.frame = CGRectMake(0, 104, self.view.bounds.size.width, self.view.bounds.size.height-104);
    //分割线
    UIView*lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 1, XJScreenW, 1)];
    lineview.backgroundColor=[UIColor grayColor];
    lineview.alpha=0.2;
    [self.view addSubview:lineview];
    
    _nkColorSwitch1 = [[ZQTColorSwitch alloc] initWithFrame:CGRectMake(5, 10, XJScreenW/4-5, 30)];
   
    _nkColorSwitch1.onBackLabel.text = @"通过";
    _nkColorSwitch1.offBackLabel.text = @"未通过";
     [_nkColorSwitch1.onBackLabel setFont:[UIFont systemFontOfSize:10]];
     [_nkColorSwitch1.offBackLabel setFont:[UIFont systemFontOfSize:10]];
   

    
    _nkColorSwitch1.onBackLabel.textColor = [UIColor whiteColor];
   
    //[_nkColorSwitch1 setTintColor:[UIColor colorWithRed:163  green:148 blue:128 alpha:1.0]];192
    [_nkColorSwitch1 setTintColor:Color(245 , 245, 245)];
    
    [_nkColorSwitch1 setOnTintColor: GlobalColor];
    [_nkColorSwitch1 setThumbTintColor:[UIColor whiteColor]];
  
    [_nkColorSwitch1 setShape:kNKColorSwitchShapeRectangle];
    [self.view addSubview:_nkColorSwitch1];
       [_nkColorSwitch1 addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];

    
    UIButton*startDate=[[UIButton alloc]initWithFrame:CGRectMake(XJScreenW/4+5, 10, 60, 30)];
    [startDate setFont:[UIFont systemFontOfSize:10]];
    [startDate setTitle:@"起始时间：" forState:UIControlStateNormal];
    [startDate setBackgroundColor:GlobalColor];
    self.startDate=startDate;
    [startDate addTarget:self action:@selector(startBtnClick:) forControlEvents: UIControlEventTouchUpInside ];
    [self.view addSubview:startDate];
    
    UILabel*linLab=[[UILabel alloc]initWithFrame:CGRectMake(XJScreenW/4+67, 15, 20, 20)];
    linLab.text=@"--";
    [self.view addSubview:linLab];
    
    UIButton*endDate=[[UIButton alloc]initWithFrame:CGRectMake(XJScreenW/2+5, 10, 60, 30)];
    [endDate setFont:[UIFont systemFontOfSize:10]];
    [endDate setTitle:@"结束时间" forState:UIControlStateNormal];
    [endDate setBackgroundColor:GlobalColor];
    self.endDate=endDate;
    [endDate addTarget:self action:@selector(endBtnClick:) forControlEvents: UIControlEventTouchUpInside ];
    [self.view addSubview:endDate];
    
    
    UIButton *seachDateBtn=[[UIButton alloc]initWithFrame:CGRectMake(XJScreenW*0.75, 10, 60, 30)];
    //seachBtn.layer.cornerRadius = 5;
    seachDateBtn.clipsToBounds = YES;
    seachDateBtn.tag = 2;
    [seachDateBtn setBackgroundColor:GlobalColor];
    [seachDateBtn setTintColor:[UIColor whiteColor]];
    seachDateBtn.showsTouchWhenHighlighted = YES;
    [seachDateBtn setTitle:@"查询" forState:UIControlStateNormal];
    [seachDateBtn addTarget:self action:@selector(searchDateClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:seachDateBtn];


}

-(void)setTabviewUI{

    
    _myTableview = [[UITableView alloc] init];
    _myTableview.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50);
    _myTableview.delegate = self;
    _myTableview.dataSource = self;
    [self.view addSubview:_myTableview];
    _myTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableview.showsVerticalScrollIndicator = NO;
    [_myTableview registerClass:[SJViewCell class] forCellReuseIdentifier:NSStringFromClass([SJViewCell class])];
    
   
    [_myTableview reloadData];
    



}

#pragma mark -- 按钮点击事件
- (void)startBtnClick:(UIButton *)sender {
    self.CJButton = sender;
    CJCalendarViewController *calendarController = [[CJCalendarViewController alloc] init];
    calendarController.view.frame = self.view.frame;
    
    calendarController.delegate = self;
    NSArray *arr = [self.startDate.titleLabel.text componentsSeparatedByString:@"-"];
    
    if (arr.count > 1) {
        [calendarController setYear:arr[0] month:arr[1] day:arr[2]];
    }
    
    [self presentViewController:calendarController animated:YES completion:nil];

    
}
- (void)endBtnClick :(UIButton *)sender {
    self.CJButton = sender;
    CJCalendarViewController *calendarController = [[CJCalendarViewController alloc] init];
    calendarController.view.frame = self.view.frame;
    
    calendarController.delegate = self;
    NSArray *arr = [self.endDate.titleLabel.text componentsSeparatedByString:@"-"];
    
    if (arr.count > 1) {
        [calendarController setYear:arr[0] month:arr[1] day:arr[2]];
    }
    
    [self presentViewController:calendarController animated:YES completion:nil];
 

    
}


-(void)CalendarViewController:(CJCalendarViewController *)controller didSelectActionYear:(NSString *)year month:(NSString *)month day:(NSString *)day{
   
    [self.CJButton setTitle:[NSString stringWithFormat:@"%@-%@-%@", year, month, day] forState:UIControlStateNormal];
    
}




/**
 *  按日期查询
 */
-(void)searchDateClick
{
    
//    self.myTableview.startTip = YES;
//    self.myTableview.tipTitle = @"无查询信息";
//    //可以不设置 默认图片为nomessage 可以到分类中修改默认图片名
//    self.myTableview.tipImage=[UIImage imageNamed:@"nomessage"];
    
    NSLog(@"searchClick");
    NSString *orgCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"orgCode"];
    
    
    NSDictionary *para = @{@"start":_startDate.titleLabel.text,@"orgCode":orgCode,@"end":_endDate.titleLabel.text,@"isPass":_Pass};
  
    
    NSLog(@"%@",para);
    
    NSString*url=@"http://103.37.158.17:3000/api/v1/search";
    
    [self.manager GET:url parameters:para success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         
         NSLog(@"%@",responseObject);
        self.myDataSource=[SJViewModel mj_objectArrayWithKeyValuesArray:responseObject[@"applies"]];
         

          NSLog(@"------%@",self.myDataSource);
         if (self.myDataSource.count==0) {
             //[SVProgressHUD showErrorWithStatus:@"没有会见消息"];
             [LCProgressHUD showMessage:@"没有会见消息"];

         } else {
              [LCProgressHUD showLoading:@"正在查询"];
             [NSTimer scheduledTimerWithTimeInterval:2.0f
                                              target:self
                                            selector:@selector(roloadTabviewData)
                                            userInfo:nil
                                             repeats:NO];
         }
 
       
        
     }
     
    failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"加载失败"];
                  
                  NSLog(@"%@",error);
                  
              }];
    
}
-(void)roloadTabviewData{
  [_myTableview reloadData];
    [LCProgressHUD hide];
}
/**
 *  判断对象是否为空
 *
 *  @param object object
 *
 *  @return yes or  no
 */
- (BOOL)dx_isNullOrNilWithObject:(id)object;
{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



-(NSString*)changeSting:(NSString*)string
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



#pragma mark -- uitableview Delegate 代理 --


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    
    return  self.myDataSource.count;

   
    
}


#pragma mark - 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return
    [SJViewCell whc_CellHeightForIndexPath:indexPath tableView:tableView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SJViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SJViewCell class])];
    cell.sjViewModel=self.myDataSource[indexPath.row];
    NSArray *historyArray = [history mj_objectArrayWithKeyValuesArray:cell.sjViewModel.history];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell reloadData:cell.sjViewModel];
    //[_myTableview reloadData];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    cell.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
}






@end
