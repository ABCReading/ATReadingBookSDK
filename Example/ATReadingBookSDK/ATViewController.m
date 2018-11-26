//
//  ATViewController.m
//  ATReadingBookSDK
//
//  Created by Spaino on 11/22/2018.
//  Copyright (c) 2018 Spaino. All rights reserved.
//

#import "ATViewController.h"
#import <ABCtimeReadingBookSDK/ABCtimeReadingBookSDK.h>
//#import <ATVoiceEvalManager/ATVoiceEvalManager.h>
#import <ATVoiceEvalManager/ATVoiceEvalManager.h>
//#import "ATVoiceEvalManager.h"
#import "ATTestInstance.h"
#import "ATAppDelegate.h"
#import "TestPaymentView.h"
#import "TestHostPaymentViewController.h"

#define AT_SCREEN_WIDTH                     MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)
#define AT_SCREEN_HEIGHT                    MIN(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)
#define AT_SCREEN_BOUNDS                    (CGRect){0, 0, AT_SCREEN_WIDTH, AT_SCREEN_HEIGHT}


@interface ATViewController ()
@property (nonatomic, copy) ATVoiceEvalCompletedBlock evalCompletedBlock;
@end

@implementation ATViewController
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 强制横屏;
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ABCtime跟读打分, 处理打分回调
    __weak typeof(self) weakSelf = self;
    [ATVoiceEvalManager sharedInstance].evalResultBlock = ^(id result, BOOL isSuccess) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (result && [result isKindOfClass:ATVoiceEvalResultModel.class]) {
            if (strongSelf.evalCompletedBlock) {
                strongSelf.evalCompletedBlock(((ATVoiceEvalResultModel *)result).score.integerValue, isSuccess);
            }
            //以下是模拟跟读打分延迟的情况
            //            if (arc4random() % 2 == 0) {
            //                if (strongSelf.evalCompletedBlock) {
            //                    strongSelf.evalCompletedBlock(((ATVoiceEvalResultModel *)result).score.integerValue, isSuccess);
            //                }
            //            } else {
            //                if (strongSelf.evalCompletedBlock) {
            //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                        strongSelf.evalCompletedBlock(((ATVoiceEvalResultModel *)result).score.integerValue, isSuccess);
            //                    });
            //                }
            //            }
        }
    };
    
    // >>> 主app需要做的事情;
    // 注册ABCtimeReadingBookSDK
    [ATReadingBookManager registAppID:@"sdk761251283344" appSecret:@"a63623e86db5c31699cef42c36d729d3"];
    
    // 设定服务器类型;
    [ATReadingBookManager setServerType:EATServerTypeProduction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 显示ABCtimeReadingBook的入口页面!!!!
 */
- (IBAction)show {
    NSBundle *libraryBundle = [NSBundle bundleForClass:self.class];
    NSString *path = [libraryBundle pathForResource:@"ATReadingBookSDK" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    NSString *sourcePath = [bundle pathForResource:@"ATReadingBookImages" ofType:@"bundle"];
    
    NSLog(@"%@+++++++", [NSBundle bundleWithPath:sourcePath]);
    
    
    // 测试输出全量的level列表 aa ~ G 级别
    NSArray *retLevelList = [ATReadingBookManager getAllBookLevelList];
    NSLog(@"retLevelList > %@", retLevelList);
    
    // 测试使用的用户id
#define kATUserTestID      (@"900213")
    // 用户login;
    [[ATReadingBookManager sharedInstance] setParentViewController:self
                                                        withUserId:kATUserTestID
                                                          delegate:self];
    //点击payment入口掉起 宿主app 的支付页面;
    [[ATReadingBookManager sharedInstance] setPaymentEnterBlock:^(NSString *userID,
                                                                  NSString *levelID,
                                                                  __kindof UINavigationController *atNavigationController) {
        
        // 模拟订单号, 随机数
        int y = 100 +  (arc4random() % 101);
        NSString *randomTransactionID = [NSString stringWithFormat:@"userID_%@_levelID_%@_random_%d", userID, levelID, y];
        
        //TODO: 显示主App支付页面
        TestHostPaymentViewController *showPaymentViewController = [[TestHostPaymentViewController alloc] init];
        [showPaymentViewController setBackBlock:^{
            [atNavigationController popViewControllerAnimated:YES];
            
            // TODO: 支付成功的回调;
            [[ATReadingBookManager sharedInstance] paymentSuccessWithTransaction:randomTransactionID
                                                                          userID:userID
                                                                         levelID:levelID];
        }];
        [atNavigationController pushViewController:showPaymentViewController animated:YES];
        
        //        // >>> TODO :这里显示支付页面for 宿主app
        //        NSLog(@"显示付费页面for ABCtimeReading ... userID : %@, levelID : %@", userID, levelID);
        //        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        //        [keyWindow makeKeyAndVisible];
        //        [keyWindow addSubview:({
        //            // 模拟订单号, 随机数
        //            int y = 100 +  (arc4random() % 101);
        //            NSString *randomTransactionID = [NSString stringWithFormat:@"userID_%@_levelID_%@_random_%d", userID, levelID, y];
        //
        //            // ======================================================================================================================= //
        //            // 模拟TEST支付页面;
        //            TestPaymentView *retView = [[TestPaymentView alloc] initWithFrame:AT_SCREEN_BOUNDS];
        //            [retView setPaymentInfoStr:[NSString stringWithFormat:@"userID : %@, levelID : %@, 订单ID : %@", userID, levelID, randomTransactionID]];
        //
        //            __weak typeof(retView) weakRetView = retView;
        //            [retView setPayCallBack:^{
        //                __strong typeof(weakRetView) strongRetView = weakRetView;
        //                // TODO: 支付成功的回调;
        //                [[ATReadingBookManager sharedInstance] paymentSuccessWithTransaction:randomTransactionID
        //                                                                              userID:userID
        //                                                                             levelID:levelID];
        //                [strongRetView removeFromSuperview];
        //            }];
        //            retView;
        //            // ======================================================================================================================= //
        //        })];
    }];
}

//MARK: - ABCtimeReadingBookProtocol
- (void)at_startRecordWithPageContent:(NSString *)pageContent {
    
    //开始录音打分
    [[ATVoiceEvalManager sharedInstance] startEvaluate:pageContent];
    
}

- (void)at_endRecordWithComplete:(ATVoiceEvalCompletedBlock)complete {
    
    self.evalCompletedBlock = complete;
    [[ATVoiceEvalManager sharedInstance] stopEvaluate];
    
}

- (void)at_cancelRecord {
    [[ATVoiceEvalManager sharedInstance] cancelEvaluate];
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL) shouldAutorotate {
    return YES;
}
@end
