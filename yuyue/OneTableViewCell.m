

#import "OneTableViewCell.h"
#import "UIView+WHC_AutoLayout.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT self.frame.size.height
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//#define GlobalColor Color(100,149,237)
#define GlobalColor Color(237,237,237)
@implementation cancelButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(25, 20, 25 ,25);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(25, 45, 30 ,25);
}

@end


@implementation OneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 10, WIDTH-40, 120)];
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        //view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        view.backgroundColor=GlobalColor;
        [self.contentView addSubview:view];
        
//         UILabel *sysLab = [[UILabel alloc] init];
//        sysLab.frame=
//        sysLab.text=@"系统消息：";
//        
//        
//         UILabel *contentLab = [[UILabel alloc] init];
//        contentLab.numberOfLines=0;
//        contentLab.lineBreakMode = UILineBreakModeCharacterWrap;
//        [view addSubview:sysLab];
//        [view addSubview:contentLab];
        
       // UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, view.frame.size.width-10, view.frame.size.height-10)];
        [view addSubview:label];
        _label = label;
      
        _label.numberOfLines = 0;//表示label可以多行显示
        
        _label.lineBreakMode = UILineBreakModeCharacterWrap;//换行模式，与上面的计算保持一致。
        
//
//        _cancelView = [[cancelButton alloc] initWithFrame:CGRectMake(WIDTH-20, 0, 100, 80)];
//        _cancelView.backgroundColor = [UIColor whiteColor];
//        _cancelView.hidden = YES;
//        [_cancelView setTitle:@"删除" forState:UIControlStateNormal];
//        _cancelView.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_cancelView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [_cancelView setImage:[UIImage imageNamed:@"pic13"] forState:UIControlStateNormal];
//        [self.contentView addSubview:_cancelView];
    }
    return self;
}
/**
 *  监听滑动删除，获取cell滑动删除的状态（核心）
 *
 */
//
//- (void)didTransitionToState:(UITableViewCellStateMask)state {
//     NSLog(@"cell的状态 %lu", (unsigned long)state);
//    switch (state) {
//        case 0:
//        {
//            _cancelView.hidden = YES;
//        }
//            break;
//        case 2:
//        {
//            _cancelView.hidden = NO;
//        }
//            break;
//            
//        default:
//            break;
//    }
//}
@end
