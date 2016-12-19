//
//  AppDelegate.m
//  yuyue
//
//  Created by 肖君 on 16/9/28.
//  Copyright © 2016年 肖君. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NIMSDK.h"
#import "MJExtension.h"

NSString *NTESNotificationLogout = @"NTESNotificationLogout";
@interface AppDelegate ()<NIMLoginManagerDelegate,NIMSystemNotificationManager,NIMSystemNotificationManagerDelegate,NIMTeamManagerDelegate,UIAlertViewDelegate>

//@property (nonatomic , strong) NSMutableArray* mesArray;
@property (nonatomic , strong) NIMCustomSystemNotification  *notification;
@property (nonatomic,strong)    NSArray *clients;
@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      [[NIMSDK sharedSDK].loginManager addDelegate:self];
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController=[[UINavigationController alloc]initWithRootViewController:[[ViewController alloc]init]];
    
    [self.window makeKeyAndVisible];
    
    
    //    UIUserNotificationSettings *seting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    //
    //
    //
    //    [[UIApplication sharedApplication]registerUserNotificationSettings:seting];
    
    //系统通知
    [[NIMSDK sharedSDK] registerWithAppID:@"1719bb50b6bb43e08187c9f99a330dec" cerName:@"nil"];
    
    ViewController*vc=[[ViewController alloc]init];
    id<NIMSystemNotificationManager> systemNotificationManager = [[NIMSDK sharedSDK] systemNotificationManager];
    [systemNotificationManager addDelegate:self];
    
    NSArray *notifications = [systemNotificationManager fetchSystemNotifications:nil
                                                                           limit:20];
    
    [[[NIMSDK sharedSDK] loginManager] login:vc.userName.text
                                       token:vc.userID.text
                                  completion:^(NSError *error) {  NSLog(@"**^^^^**%@",error);  }];
    ;
    
    
    
    
    //[self addLocalNotification];
    
    
    
    
    return YES;
}
#pragma NIMLoginManagerDelegate



-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    NSString *reason = @"你被踢下线";
    switch (code) {
        case NIMKickReasonByClient:
        case NIMKickReasonByClientManually:{
            //            NSString *clientName = [NTESClientUtil clientName:clientType];
            //            reason = clientName.length ? [NSString stringWithFormat:@"你的帐号被%@端踢出下线，请注意帐号信息安全",clientName] : @"你的帐号被踢出下线，请注意帐号信息安全";
            reason = @"你的帐号被踢出下线，请注意帐号信息安全";
            break;
        }
        case NIMKickReasonByServer:
            reason = @"你被服务器踢下线";
            break;
        default:
            break;
    }
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clickButtonAtIndex:%d",(int)buttonIndex);
    if (buttonIndex==0) {
        
        ViewController*homeVC=[[ViewController alloc]init];
        self.window.rootViewController=homeVC;
          
    }
    
}


- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
    self.notification=notification;
    
    [self.mesArray addObject:notification.content];
    [self addLocalNotification];
    UIUserNotificationSettings *seting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    
    
    
    [[UIApplication sharedApplication]registerUserNotificationSettings:seting];
    
}

-(void)addLocalNotification{
    
    //    UIUserNotificationSettings *seting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    //
    //
    //
    //    [[UIApplication sharedApplication]registerUserNotificationSettings:seting];
    
    //定义本地通知对象
    UILocalNotification *notification=[[UILocalNotification alloc]init];
    //设置调用时间
    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:5.0];//通知触发的时间，10s以后
    notification.repeatInterval=2;//通知重复次数
    //notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
    
    
    
    //设置通知属性
    notification.alertBody=self.notification.content; //通知主体
    
    //NSLog(@"addLocalNotification :%@",self.notification.content);
    //notification.alertBody=@"该应用增加了很多新特性过来体验一下";
    //notification.applicationIconBadgeNumber=1;//应用程序图标右上角显示的消息数
    notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
    notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片
    // notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
    notification.soundName=@"msg.caf";//通知声音（需要真机）
    
    //设置用户信息
    notification.userInfo=@{@"id":@1,@"user":@"xj"};//绑定到通知上的其他额外信息
    
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void)sendCustomNotification:(NIMCustomSystemNotification *)notification toSession:(NIMSession *)session completion:(NIMSystemNotificationHandler)completion
{
    NSLog(@"sendCustomNotification");
    
}







-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    NSDictionary *userInfo=notification.userInfo;
    
    [userInfo writeToFile:@"/Users/kenshincui/Desktop/didReceiveLocalNotification.txt" atomically:YES];
    NSLog(@"didReceiveLocalNotification:The userInfo is %@",userInfo);
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if (notificationSettings.types!=UIUserNotificationTypeNone) {
        [self addLocalNotification];
    }
    
    
    
}


-(void)removeNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
