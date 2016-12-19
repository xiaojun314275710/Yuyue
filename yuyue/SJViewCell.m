
#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define TEXTColor [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0]
#define ContentTEXTColor [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]

#define TEXTFont [UIFont systemFontOfSize:13.0]


#import "SJViewCell.h"
#import "UIView+WHC_AutoLayout.h"
#import "NSString+NUll.h"
#import "MJExtension.h"
#define XJScreenW [UIScreen mainScreen].bounds.size.width
@implementation SJViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        _name = [UILabel new];
        _phone=[UILabel new];
        _uuid=[UILabel new];
        _askContent = [UILabel new];
        _date=[UILabel new];
        _time=[UILabel new];
        
        _backView=[UIView new];
        _backView.backgroundColor=[UIColor whiteColor];;
        
        
        _name.textColor = TEXTColor;
        _phone.textColor = TEXTColor;
        _uuid.textColor = TEXTColor;
        _askContent.textColor = TEXTColor;
        _date.textColor=TEXTColor;
        _time.textColor=TEXTColor;;
        
        _name.font = TEXTFont;
        _phone.font = TEXTFont;
        _uuid.font = TEXTFont;
        _askContent.font = TEXTFont;
        _date.font = TEXTFont;
        _time.font = TEXTFont;
        
        
        
        
        //[self.contentView addSubview:_askHeadImage];
        // [self.contentView addSubview:_Gname];
        //[self.contentView addSubview:_Gphone];
        //[self.contentView addSubview:_Guuid];
        
        [self.contentView addSubview:_name];
        [self.contentView addSubview:_phone];
        [self.contentView addSubview:_uuid];
        [self.contentView addSubview:_askContent];
        [self.contentView addSubview:_date];
        [self.contentView addSubview:_time];
        [self.contentView addSubview:_backView];
        
        
        
        
        _name.whc_LeftSpace(20)
        .whc_TopSpace(10)
        .whc_Height(40)
        .whc_widthAuto();
        
        _phone.whc_LeftSpace(20)
        .whc_TopSpaceToView(1,_name)
        .whc_widthAuto()
        .whc_Height(40);
        
        _uuid.whc_LeftSpace(20)
        .whc_TopSpaceToView(1,_phone)
        .whc_widthAuto()
        .whc_Height(40);
        _askContent.whc_LeftSpace(20)
        .whc_TopSpaceToView(1,_uuid)
        .whc_widthAuto()
        .whc_Height(40);
        
        _date.whc_LeftSpace(20)
        .whc_TopSpaceToView(1,_askContent)
        .whc_widthAuto()
        .whc_Height(40);
        _time.whc_LeftSpace(20)
        .whc_TopSpaceToView(1,_date)
        .whc_widthAuto()
        .whc_Height(40);
        
        
        _backView.whc_LeftSpace(0)
        .whc_TopSpaceToView(40,_time)
        .whc_Size(CGSizeMake(XJScreenW ,5));
        
        
        
        
        
        //设置cell底部距离
        self.whc_CellBottomOffset = 10;
        
        
    }
    
    return self;
    
    
    
}


#pragma mark -- 赋值 --

- (void)reloadData:(SJViewModel *)sjViewModel
{
    _sjViewModel=sjViewModel;
    
    NSString* string1=@"姓名:";
    NSString* nameString=sjViewModel.name;
    NSString* string = [string1 stringByAppendingString:nameString];
    self.name.text=string;
    
    NSString* string2=@"手机号码:";
    NSString* phoneString=sjViewModel.phone;;
    NSString* PhoneString = [string2 stringByAppendingString:phoneString];
    self.phone.text=PhoneString;
    
    NSString* string3=@"身份证号码：:";
    NSString* uuidString=sjViewModel.applicant;
    NSString* UUIDString = [string3 stringByAppendingString:[self changeSting:uuidString]];
    self.uuid.text=UUIDString;
    
    
    
    
    
    NSArray *historyArray = [history mj_objectArrayWithKeyValuesArray:sjViewModel.history];
    if (historyArray.count>0) {
        history * historyModel = [historyArray objectAtIndex:0];
        NSString* string4=@"申请日期:";
        NSString* dateString=historyModel.fillingDate;
        NSString* DATEString = [string4 stringByAppendingString:dateString];
        self.date.text=DATEString;
        
        NSString* string5=@"会见时间:";
        NSString* timeString=historyModel.feedback.meetingTime;
        if (timeString!=NULL) {
            NSString* TIMEString = [string5 stringByAppendingString:timeString];
            self.time.text=TIMEString;
        }
              //
//        NSString* string5=@"会见时间:";
//        NSString* timeString=historyModel.feedback.meetingTime;
//        NSString* TIMEString = [string5 stringByAppendingString:timeString];
//        self.time.text=TIMEString;
//        NSLog(@"_id=%@,fillingDate=%@meetingTime=%@",historyModel._id,historyModel.fillingDate,historyModel.feedback.meetingTime);
        
        NSString* string6=@"申请状态:";
        NSString* statuString=historyModel.feedback.content;

        NSString* STATUtring = [string6 stringByAppendingString:statuString];
        self.askContent.text=STATUtring;
        
    
      }


}
- (BOOL) isBlankString:(NSString *)string {
  
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
  
}

@end
