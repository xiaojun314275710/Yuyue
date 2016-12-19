//
//  ViewController.m
//  textDEemo
//
//  Created by 邹少军 on 16/8/16.
//  Copyright © 2016年 chengdian. All rights reserved.
//

#import "ViewController.h"
#import "SJInputPopView.h"
#import "SJViewModel.h"
#import "SJViewCell.h"
#import "UIView+WHC_AutoLayout.h"
#import "NSString+NUll.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

//tabelview

@property (nonatomic, strong) UITableView *myTableview;

@property (nonatomic ,strong) NSMutableArray *myDataSource;




@end

@implementation ViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"问答";
    
    [self setNavigation];
    
    [self getTableviewData];
    
    _myTableview = [[UITableView alloc] init];
    _myTableview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    _myTableview.delegate = self;
    _myTableview.dataSource = self;
    [self.view addSubview:_myTableview];
    
    [_myTableview registerClass:[SJViewCell class] forCellReuseIdentifier:NSStringFromClass([SJViewCell class])];
    [_myTableview reloadData];
    
    
    _myTableview.tableFooterView = [UIView new];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)setNavigation
{
    
    UIButton *rightbtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbtn setImage:[UIImage imageNamed:@"xunwen_icon_bianji"] forState:UIControlStateNormal];
    rightbtn.frame      = CGRectMake(0, 0, 21,21);
    [rightbtn addTarget:self action:@selector(writeProblem) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightitme = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    [self.navigationItem setRightBarButtonItem:rightitme];
    
}


- (void)getTableviewData
{
    _myDataSource = [[NSMutableArray alloc] init];
    
    SJViewModel *model = [[SJViewModel alloc]init];
    model.askHeadImage = @"xiong_da";
    model.askName = @"熊大";
    model.askContent = @"可恶!又是光头强。熊就要有个熊样";
    model.replyHead = @"xiong_er";
    model.replyName = @"熊二";
    model.replyContent = @"熊大，你又骗俺,熊大，熊大，你等等俺，你等等俺呀.俺的蜂蜜，俺的坚果，俺的小蝴蝶!可恶的的光头强，又在砍俺们的树。不好咧不好咧，光头强又来咧~熊大!光头强又在砍俺们的树了!俺还经常在这棵树上数月亮呢!熊大光头强又来砍树嘞…果然是光头强，看我怎么收拾他";
    
    
    
    SJViewModel *model1 = [[SJViewModel alloc]init];
    model1.askHeadImage = @"guangtouqiang";
    model1.askName = @"光头强";
    model1.askContent = @"惹我光头强,揍你没商量!强哥不发威，当我是病猫啊!砍树砍树，挣钱无数!臭狗熊，我跟你们没完!!!!!又是你们两个臭狗熊，别跑，给我站住臭狗熊，终于让我逮到你们了。";
    model1.replyHead = @"xiong_er";
    model1.replyName = @"熊二";
    model1.replyContent = @"熊大，你又骗俺,熊大，熊大，你等等俺，你等等俺呀.俺的蜂蜜，俺的坚果，俺的小蝴蝶!可恶的的光头强，又在砍俺们的树。不好咧不好咧，光头强又来咧~熊大!光头强又在砍俺们的树了!俺还经常在这棵树上数月亮呢!熊大光头强又来砍树嘞…果然是光头强，看我怎么收拾他";
    
    [_myDataSource addObject:model];
    [_myDataSource addObject:model1];
    
    
    
}



#pragma mark -- uitableview Delegate 代理 --


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _myDataSource.count;
    
}


#pragma mark - 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [SJViewCell whc_CellHeightForIndexPath:indexPath tableView:tableView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    SJViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SJViewCell class])];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    SJViewModel *model = [_myDataSource objectAtIndex:indexPath.row];
    
    [cell reloadData:model];
    
    
    return cell;

    

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_myTableview deselectRowAtIndexPath:indexPath animated:YES];
    
    SJViewModel *model = [_myDataSource objectAtIndex:indexPath.row];
    
    if (self.myDataSource.count != 0) {
        
        if ([NSString stringIsNull:model.replyName]) {
            
            [self replyClicke:model indexPath:indexPath.row];
            
            
        }else
        {//当回答不等于空的时候
            
            
            [[[UIAlertView alloc] initWithTitle:@"提示"
                                        message:@"当前问题已经得到回答"
                                       delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles: nil] show];
            
            
        }
        
    }
    
    
}


- (void)replyClicke:(SJViewModel *)model indexPath:(NSInteger )index
{
    
    
    SJInputPopView *sjpopView = [[SJInputPopView alloc] init];
    
    [sjpopView popViewWithInputPlaceholder:@"请输入您想要回答的内容"
                               cancelBlock:^(){
                                   
                                   NSLog(@"关闭");
                                   
                               } confirmBlock:^(NSString *inputStr){
                                   

                                   [_myDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                                       
                                       SJViewModel *temModel = obj;
                                       
                                       if (idx == index) {
                                           
                                           temModel.askHeadImage = model.askHeadImage;
                                           temModel.askName = model.askName;
                                           temModel.askContent = model.askContent;
                                           
                                           
                                           temModel.replyHead = @"xiongmao";
                                           temModel.replyName = @"熊猫";
                                           temModel.replyContent = inputStr;
                                           
                                       }
                                       
                                   }];
                                   
                                   
                                   //刷新界面
                                   [_myTableview reloadData];
                                   
                                   
                               }];

    
    
}


- (void)writeProblem
{
    
    SJInputPopView *sjpopView = [[SJInputPopView alloc] init];
    
    [sjpopView popViewWithInputPlaceholder:@"请输入您想要问的问题"
                                    cancelBlock:^(){
                                    
                                        NSLog(@"关闭");
                                        
                                    } confirmBlock:^(NSString *inputStr){
                                        
                                        
                                        SJViewModel *model = [[SJViewModel alloc]init];
                                        model.askHeadImage = @"guangtouqiang";
                                        model.askName = @"光头强";
                                        model.askContent = inputStr;
                                        
                                        model.replyHead = @"";
                                        model.replyName = @"";
                                        model.replyContent = @"";
                                        
                                        [self.myDataSource addObject:model];
                                        
                                        [self.myTableview reloadData];
                                        
                                    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
