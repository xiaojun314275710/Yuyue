//
//  messageViewController.m
//  yuyue
//
//  Created by 肖君 on 16/9/29.
//  Copyright © 2016年 肖君. All rights reserved.
//
#import "AppDelegate.h"

#import "messageViewController.h"
#import "NIMSDK.h"
#import "MJExtension.h"


#import "UIView+WHC_AutoLayout.h"
#import "OneTableViewCell.h"
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define GlobalColor Color(100,149,237)

#import "OneTableViewCell.h"
@interface messageViewController ()<NIMSystemNotificationManagerDelegate,NIMTeamManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic , strong) NSMutableArray* mesArray;
@end

@implementation messageViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    
    self.mesArray=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"sysMessage"]];
    //         self.mesArray=[NSMutableArray arrayWithArray:[appDelegate.mesArray arrayByAddingObjectsFromArray:sysMessage ]];
    
    if (_mesArray.count==0) {
        UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, (self.view.frame.size.height-400)/2, 200, 200)];
        [image  setImage:[UIImage imageNamed:@"no_sys_msg"]];
        [self.view addSubview:image];
    }
    [_tableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.view.frame = CGRectMake(0, 104, self.view.bounds.size.width, self.view.bounds.size.height);
    
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100) style:UITableViewStylePlain];
        //    _myTableview.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50);

            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:_tableView];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.rowHeight = 140;
            [_tableView registerClass:[OneTableViewCell class] forCellReuseIdentifier:@"cell"];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mesArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   // cell.label.text = self.mesArray[indexPath.row];
    NSString*string1=@"系统消息：                                          ";
    NSString*string2=self.mesArray[indexPath.row];
    cell.label.text=[string1 stringByAppendingString:string2];
    
    return cell;
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
        [_mesArray removeObjectAtIndex: indexPath.row];
      
        // Delete the row from the data source.
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_tableView reloadData];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}





#pragma mark -- 懒加载
-(NSMutableArray*)mesArray
{
    if (!_mesArray) {
        _mesArray=[[NSMutableArray alloc]init];
    }
    
    return _mesArray;
}


@end
