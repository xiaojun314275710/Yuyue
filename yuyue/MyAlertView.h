

#import <UIKit/UIKit.h>

@protocol MyAlertViewBtnDelegate <NSObject>

@optional

-(void)saveClickButton :(UIButton*)saveBtn;

@end

@interface MyAlertView : UIView

@property (nonatomic, weak) id<MyAlertViewBtnDelegate>delegate;

- (void)show;
- (void)close;

@end
