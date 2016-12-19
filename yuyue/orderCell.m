//
//  orderCell.m
//  yuyue
//
//  Created by 肖君 on 16/11/7.
//  Copyright © 2016年 肖君. All rights reserved.
//

#define XJScreenW [UIScreen mainScreen].bounds.size.width
#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define GlobalColor Color(100,149,237)

#import "orderCell.h"
#import "SJViewCell.h"
#import "UIView+WHC_AutoLayout.h"
#import "NSString+NUll.h"
#import "MJExtension.h"
@implementation orderCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
     
        UIButton*jianBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 25, 20, 20)];
        [jianBtn setImage:[UIImage imageNamed:@"矩形-4"] forState:  UIControlStateNormal   ];
        [self.contentView addSubview:jianBtn];
        
        //姓名
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(30, 5, CGRectGetMaxX(self.contentView.bounds)/2, 30)];
        //nameLab.text=@"肖君";
         [self.contentView addSubview:_nameLab];
      
             //身份证号
        _userLab=[[UILabel alloc]initWithFrame:CGRectMake(30, 35, CGRectGetMaxX(self.contentView.bounds), 20)];
       //userLab.text=@"身份证号:432503199003240835";
        _userLab.font=[UIFont systemFontOfSize:13];
        
         [self.contentView addSubview:_userLab];
        
        

       
        
       
        

        
        
        
        
        
//        _name.whc_LeftSpace(20)
//        .whc_TopSpace(10)
//        .whc_Height(40)
//        .whc_widthAuto();

        //设置cell底部距离
        self.whc_CellBottomOffset = 20;
        
        
    }
    
    return self;
    
    
    
}
- (void)reloadData:(orderMode *)ordermode{
    _ordermode=ordermode;
    self.ordermode=ordermode;
    self.nameLab.text=ordermode.name;
    NSString*sting=[self changeSting:ordermode.uuid];
    self.userLab.text=sting;


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

@end
