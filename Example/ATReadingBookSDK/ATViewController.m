//
//  ATViewController.m
//  ATReadingBookSDK
//
//  Created by Spaino on 11/22/2018.
//  Copyright (c) 2018 Spaino. All rights reserved.
//

#import "ATViewController.h"
#import <ABCtimeReadingBookSDK/ABCtimeReadingBookSDK.h>
#import "ATVoiceEvalManager.h"
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
    /**
     >> 这里目的在于: 调整宿主app横竖屏, 宿主根据自己情况修改代码; 默认竖屏;
     同时修改下面两个函数, 配合使用;
     - (UIInterfaceOrientationMask)supportedInterfaceOrientations {
     return UIInterfaceOrientationMaskPortrait;
     }
     - (BOOL) shouldAutorotate {
     return YES;
     }
     */
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:({
        UIButton *retButton = [[UIButton alloc] initWithFrame:(CGRect){100,100,100,100}];
        [retButton setTitle:@"进入SDK" forState:UIControlStateNormal];
        [retButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        retButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [retButton addTarget:self
                      action:@selector(p_enterSDK)
            forControlEvents:UIControlEventTouchUpInside];
        retButton;
    })];
    
    [self.view addSubview:({
        UIButton *retButton = [[UIButton alloc] initWithFrame:(CGRect){100,300,100,100}];
        [retButton setTitle:@"Alert弹窗" forState:UIControlStateNormal];
        [retButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        retButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [retButton addTarget:self
                      action:@selector(p_showAlert)
            forControlEvents:UIControlEventTouchUpInside];
        retButton;
    })];
    
    // ABCtime跟读打分, 处理打分回调
    __weak typeof(self) weakSelf = self;
    [ATVoiceEvalManager sharedInstance].evalResultBlock = ^(id result, BOOL isSuccess) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (result && [result isKindOfClass:ATVoiceEvalResultModel.class]) {
            if (strongSelf.evalCompletedBlock) {
                ATVoiceEvalResultModel *retEvalResultModel = result;
                NSDictionary *evalResultDic = @{
                                                @"score" : retEvalResultModel.score,
                                                @"audioPath" : retEvalResultModel.audioPath
                                                };
                strongSelf.evalCompletedBlock(evalResultDic, isSuccess);
            }
        }
    };
}

//    // 全量level列表
//    NSArray<NSDictionary *> *allLevelList = [ATReadingBookManager getAllBookLevelList];
//    NSLog(@"全部level列表：%@", allLevelList);


//MARK: - action
- (void)p_enterSDK {
    
    // 1. 注册ABCtimeReadingBookSDK >> 测试 appID & appSecret
    [ATReadingBookManager registAppID:@"sdk761200000001"
                            appSecret:@"a63623e86db5c31699cef42cffffffff"
                           serverType:EATServerTypePreRelease];
    
    // 测试使用的用户id
#define kATUserTestID      (@"90015")
    
    // 3. 用户login;
    [[ATReadingBookManager sharedInstance] setParentViewController:self
                                                 deviceOrientation:EATInterfaceOrientationLandscapeRight
                                                        withUserId:kATUserTestID
                                                          delegate:self];
    
    // 4. 点击payment入口掉起 宿主App的支付页面;
    [[ATReadingBookManager sharedInstance] setPaymentEnterBlock:^(NSString *userID,
                                                                  NSString *levelID,
                                                                  UINavigationController *atNavigationController) {
        // 模拟订单号;随机数;
        int y =100 +  (arc4random() % 101);
        NSString *randomTransactionID = [NSString stringWithFormat:@"userID_%@_levelID_%@_random_%d", userID, levelID, y];
        
        //TEST: 模拟显示主App支付页面
        TestHostPaymentViewController *showPaymentViewController = [[TestHostPaymentViewController alloc] init];
        [showPaymentViewController setBackBlock:^(BOOL allLevel, NSInteger type) {
            //1. 退出支付页面;
            [atNavigationController popViewControllerAnimated:YES];
            
            //2. 调用开通支付成功的level服务的接口!!!
            [[ATReadingBookManager sharedInstance] paymentSuccessWithTransaction:randomTransactionID
                                                                          userID:userID
                                                                         levelID:allLevel ? @"1000" : levelID
                                                                     subTimeType:type];
        }];
        [atNavigationController pushViewController:showPaymentViewController animated:YES];
    }];
}

- (void)p_showAlert {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title"
                                                        message:@"message"
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL) shouldAutorotate {
    return YES;
}
@end
