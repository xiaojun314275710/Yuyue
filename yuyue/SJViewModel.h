//


#import <Foundation/Foundation.h>
#import "history.h"

@interface SJViewModel : NSObject






@property (nonatomic ,copy) NSString *name;//姓名
@property (nonatomic ,copy) NSString *phone;//电话号码
@property (nonatomic ,copy) NSString *applicant;//身份证号码
@property (nonatomic ,copy) NSString *_id;//网易id

@property (nonatomic , strong) NSArray * history;







@end
