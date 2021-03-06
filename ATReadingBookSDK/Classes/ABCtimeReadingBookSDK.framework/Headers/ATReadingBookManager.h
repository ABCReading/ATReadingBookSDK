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

// ================================================================================================================ //
// Block Defines
/**
 支付页面的触发;
 @param userID 用户id;
 @param levelID 绘本level等级id;
 @param atNavigationController sdk主导航;
 */
typedef void(^kATReadingBookPaymentBlock)(NSString *userID, NSString *levelID, UINavigationController *atNavigationController);

/**
 取消订单的回调;
 @param success 是否订单取消成功;
 */
typedef void(^kATReadingBookCancelTransactionBlock)(BOOL success, NSError *error);

// ================================================================================================================ //
@interface ATReadingBookManager : NSObject
@property(nonatomic, copy) kATReadingBookPaymentBlock paymentEnterBlock;                        // 展示支付页面的回调;

/**
 ABCtime入口单例;
 @return 单例对象;
 */
+ (ATReadingBookManager *) sharedInstance;

/**
 ABCtimeReadingBookSDK注册;
 @param appID 主App在ABCtime的业务ID;
 @param appSecret 主App在ABCtime对应的秘钥;
 */
+ (void) registAppID:(NSString *) appID appSecret:(NSString *) appSecret;

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
                      withUserId:(NSString *) userId
                        delegate:(id<ABCtimeReadingBookProtocol>)delegate;

/**
 设置服务器环境
 @param serverType 服务器type
 */
+ (void)setServerType:(EATServerType)serverType;

/**
 获取服务器环境
 @return 服务器环境type
 */
+ (EATServerType)getServerType;

/**
 宿主App支付页面 >> 调用开通权限接口, <默认每次只能购买一个level有效期1年的服务, 如果重复购买, 后台累加有效期>
 在支付页面支付完毕后调用
 @param transactionID 订单id
 @param userID 用户id
 @param levelID 开通levelID
 */
- (void)paymentSuccessWithTransaction:(NSString *) transactionID
                                userID:(NSString *) userID
                               levelID:(NSString *) levelID;

/**
 取消level绘本的服务;
 @param transactionID 购买level服务的订单号;
 @param completedBlock 取消成功失败的回调;
 */
- (void)cancelLevelServiceWithTransaction:(NSString *) transactionID
                                completed:(kATReadingBookCancelTransactionBlock) completedBlock;
@end
