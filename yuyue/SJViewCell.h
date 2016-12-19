

#import <UIKit/UIKit.h>
#import "SJViewModel.h"



@interface SJViewCell : UITableViewCell



@property (nonatomic , strong) UILabel *name;//姓名

@property (nonatomic ,strong) UILabel *phone;//电话号码

@property (nonatomic ,strong) UILabel *uuid;//身份证号码

@property (nonatomic ,strong) UILabel *askContent;//预约状态

@property (nonatomic , strong) UILabel *date;//申请日期
@property (nonatomic , strong) UILabel *time;//会见时间

@property (nonatomic , strong) UIView *backView;

@property (nonatomic , strong) SJViewModel *sjViewModel;

- (void)reloadData:(SJViewModel *)sjViewModel;


@end
