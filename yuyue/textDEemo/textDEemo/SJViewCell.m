//
//  SJViewCell.m
//  textDEemo
//
//  Created by 邹少军 on 16/8/16.
//  Copyright © 2016年 chengdian. All rights reserved.
//
#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define TEXTColor [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0]
#define ContentTEXTColor [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]

#define TEXTFont [UIFont systemFontOfSize:12.0]


#import "SJViewCell.h"
#import "UIView+WHC_AutoLayout.h"
#import "NSString+NUll.h"

@implementation SJViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //问问题的用户
        _askHeadImage = [UIImageView new];
        _askName = [UILabel new];
        _askContent = [UILabel new];
        
        _askHeadImage.backgroundColor = rgb(245, 245, 245);
        
        _askName.textColor = TEXTColor;
        _askContent.textColor = ContentTEXTColor;
        
        _askName.font = TEXTFont;
        _askContent.font = TEXTFont;
        
        _askHeadImage.layer.masksToBounds = YES;
        _askHeadImage.layer.cornerRadius = 20.0;
        _askHeadImage.layer.borderWidth = 0;
        _askHeadImage.layer.borderColor = [[UIColor clearColor] CGColor];
        _askHeadImage.backgroundColor = [UIColor whiteColor];
        
        
        [self.contentView addSubview:_askHeadImage];
        [self.contentView addSubview:_askName];
        [self.contentView addSubview:_askContent];
        
        //--------------------------------------------------------------------------------------------
        
        //回答问题的用户
        
        _replyHead = [UIImageView new];
        _replyName = [UILabel new];
        _replyContent = [UILabel new];
        
        _replyHead.backgroundColor = rgb(245, 245, 245);
        _replyName.textColor = TEXTColor;
        _replyContent.textColor = ContentTEXTColor;
        
        _replyName.font = TEXTFont;
        _replyContent.font = TEXTFont;
        
        _replyHead.layer.masksToBounds = YES;
        _replyHead.layer.cornerRadius = 20.0;
        _replyHead.layer.borderWidth = 0;
        _replyHead.layer.borderColor = [[UIColor clearColor] CGColor];
        _replyHead.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_replyHead];
        [self.contentView addSubview:_replyName];
        [self.contentView addSubview:_replyContent];
        
        
        _askHeadImage.whc_LeftSpace(10)
                     .whc_TopSpace(20)
                     .whc_Size(CGSizeMake(40, 40));
        
        _askName.whc_LeftSpaceToView(10,_askHeadImage)
                .whc_TopSpace(30)
                .whc_RightSpace(10)
                .whc_Height(20);
        
        _askContent.whc_LeftSpaceToView(10,_askHeadImage)
                   .whc_TopSpaceToView(10,_askName)
                   .whc_RightSpace(10)
                   .whc_heightAuto();
        
        //-------------------------------------------------------------
        
        
        _replyHead.whc_LeftSpace(25)
                  .whc_TopSpaceToView(20,_askContent)
                  .whc_Size(CGSizeMake(40, 40));
        
        
        _replyName.whc_LeftSpaceToView(10,_replyHead)
                  .whc_TopSpaceToView(30,_askContent)
                  .whc_RightSpace(10)
                  .whc_Height(20);
        
        _replyContent.whc_LeftSpaceEqualView(_replyName)
                     .whc_TopSpaceToView(15,_replyName)
                     .whc_RightSpace(10)
                     .whc_heightAuto();
        
        //设置cell底部距离
        self.whc_CellBottomOffset = 30;
        
        
    }
    
    return self;
    
    
    
}


#pragma mark -- 赋值 --

- (void)reloadData:(SJViewModel *)sjViewModel
{
    NSLog(@"model=%@",sjViewModel);
    
    //有问有答。回答问题的用户名称不等于空
    if (![NSString stringIsNull:sjViewModel.replyName])
    {
        [_replyHead setHighlighted:NO];
        [_replyName setHighlighted:NO];
        [_replyContent setHighlighted:NO];
        
        _askHeadImage.image = [UIImage imageNamed:sjViewModel.askHeadImage];
        _askName.text = sjViewModel.askName;
        _askContent.text = sjViewModel.askContent;
        
        _replyHead.image = [UIImage imageNamed:sjViewModel.replyHead];
        _replyName.text = sjViewModel.replyName;
        _replyContent.text = sjViewModel.replyContent;
        
        //cell底部视图
        self.whc_CellBottomView = _replyContent;
        
        
    }else
    {//只有问题。没有回答
        [_replyHead setHighlighted:YES];
        [_replyName setHighlighted:YES];
        [_replyContent setHighlighted:YES];
        
        _askHeadImage.image = [UIImage imageNamed:sjViewModel.askHeadImage];
        _askName.text = sjViewModel.askName;
        _askContent.text = sjViewModel.askContent;
        
        //cell底部视图
        self.whc_CellBottomView = _askContent;
    }
    
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
