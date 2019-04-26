//
//  ATReadingBookManager.h
//  ABCtimeReadingBookSDK
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCtimeReadingBookProtocol.h"

typedef NS_ENUM(NSUInteger, EATServerType) {    // 服务器环境类型;
    EATServerTypePreRelease = 0,                // 预发布测试环境;
    EATServerTypeProduction,                    // 正式环境;
};

typedef NS_ENUM(NSInteger, EATSubTimeType) {
    EATSubTimeTypeHalfYear = 1,             // 半年
    EATSubTimeTypeYear = 2,                 // 1年
    EATSubTimeTypeMonth = 3,                // 1个月
};

typedef NS_ENUM(NSUInteger, EATInterfaceOrientation) {
    EATInterfaceOrientationLandscapeLeft = 1,
    EATInterfaceOrientationLandscapeRight,
};

/**
 兑换开通VIP错误码

 - EATRedeemErrorCodeInvalidParameters: 参数无效 <<< 参数为空字符串或nil
 - EATRedeemErrorCodeExpired: 兑换码已过期
 - EATRedeemErrorCodeNotExist: 兑换码不存在
 - EATRedeemErrorCodeInvalidCode: 兑换码无效 <<< 1.兑换码被退回 2.用单level兑换码来开通全量level会返回兑换码无效
 - EATRedeemErrorCodeFailed: 兑换失败 <<< SDK调用兑换接口失败，请用户重试即可
 - EATRedeemErrorCodeUsed: 兑换码已使用
 */
typedef NS_ENUM(NSUInteger, EATRedeemErrorCode) {
    EATRedeemErrorCodeInvalidParameters = -999,
    EATRedeemErrorCodeExpired = 1205,
    EATRedeemErrorCodeNotExist = 1206,
    EATRedeemErrorCodeInvalidCode = 1207,
    EATRedeemErrorCodeFailed = 1208,
    EATRedeemErrorCodeUsed = 1209,
};

// ================================================================================================================ //
// Block Defines
/**
 支付页面的触发;
 @param userID 用户id;
 @param levelID 绘本level等级id;
 @param atNavigationController sdk主导航;
 */
typedef void(^kATReadingBookPaymentBlock)(NSString *userID,
                                          NSString *levelID,
                                          UINavigationController *atNavigationController);

/**
 兑换页面的触发

 @param userID 用户id
 @param levelID 绘本level等级id
 @param atNavigationController sdk主导航
 */
typedef void(^ATReadingBookRedeemBlock)(NSString *userID,
                                        NSString *levelID,
                                        UINavigationController *atNavigationController);

/**
 兑换结果回调

 @param isSuccess 是否兑换成功
 @param error 错误信息
 */
typedef void(^ATReadingBookRedeemResultBlock)(BOOL isSuccess, NSError *error);

/**
 取消订单的回调;
 @param success 是否订单取消成功;
 */
typedef void(^kATReadingBookCancelTransactionBlock)(BOOL success, NSError *error);

// ================================================================================================================ //
@interface ATReadingBookManager : NSObject

/** 展示支付页面 */
@property(nonatomic, copy) kATReadingBookPaymentBlock paymentEnterBlock;

/** 展示兑换页面 */
@property (nonatomic, copy) ATReadingBookRedeemBlock redeemEnterBlock;

/**
 ABCtime入口单例;
 @return 单例对象;
 */
+ (ATReadingBookManager *) sharedInstance;

/**
 ABCtimeReadingBookSDK注册;
 @param appID 主App在ABCtime的业务ID;
 @param appSecret 主App在ABCtime对应的秘钥;
 @param serverType 服务器环境配置;
 */
+ (void) registAppID:(NSString *) appID appSecret:(NSString *) appSecret serverType:(EATServerType) serverType;

/**
 获取所有绘本的level信息
 "levelID" = 4;      //level唯一标识
 "levelName" = A;    //level名称
 @return level列表
 */
+ (NSArray<NSDictionary *> *) getAllBookLevelList;

/**
 初始化sdk的交互VC
 @param parentViewController 父亲viewController, 用来present ABCtime绘本界面;
 @param userId 对应的用户id
 @param delegate 宿主App需要实现的delegate
 */
- (void)setParentViewController:(__kindof UIViewController *)parentViewController
              deviceOrientation:(EATInterfaceOrientation)deviceOrientation
                      withUserId:(NSString *) userId
                        delegate:(id<ABCtimeReadingBookProtocol>)delegate;

/**
 获取服务器环境
 @return 服务器环境type
 */
+ (EATServerType) getServerType;

/**
 宿主App支付页面 >> 调用开通权限接口, <重复购买, 后台累加有效期>
 在支付页面支付完毕后调用
 @param transactionID 订单id
 @param userID 用户id
 @param levelID 开通levelID(购买全level的话传@"1000")
 @param subTimeType 开通类型 半年、一年、一个月
 */
- (void)paymentSuccessWithTransaction:(NSString *) transactionID
                               userID:(NSString *) userID
                              levelID:(NSString *) levelID
                          subTimeType:(EATSubTimeType) subTimeType;

/**
 宿主App兑换页面 >> 调用兑换接口, <重复购买，后台累加有效期>

 @param code 兑换码
 @param userID 用户ID
 @param levelID 兑换levelID
 @param resultBlock 开通结果异步回调block
 */
- (void)at_redeemWithCode:(NSString *)code
                   userID:(NSString *)userID
                  levelID:(NSString *)levelID
               completion:(ATReadingBookRedeemResultBlock)resultBlock;

/**
 取消兑换VIP操作
 */
- (void)at_cancelRedeemRequest;

/**
 更新当前用户信息
 */
- (void)at_updateUserInfo;

/**
 取消level绘本的服务;
 @param transactionID 购买level服务的订单号;
 @param completedBlock 取消成功失败的回调;
 */
- (void)cancelLevelServiceWithTransaction:(NSString *) transactionID
                                completed:(kATReadingBookCancelTransactionBlock) completedBlock;
@end
