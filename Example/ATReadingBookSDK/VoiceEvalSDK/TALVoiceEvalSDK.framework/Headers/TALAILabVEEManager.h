//
//  TALAILabVEEManager.h
//  TALVoiceEvalSDK
//
//  Created by 张禹 on 2017/9/27.
//  Copyright © 2017年 Beijing Yidu Huida Education Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TALAILabVEEConfig.h"
#import "TALAILabVEEManagerConfig.h"

typedef NS_ENUM(NSInteger, TALAILabVEEType) {
    TALAILabVEETypeTypeOffLine   = 1,     //离线
    TALAILabVEETypeTypeLine      = 2,     //在线
    TALAILabVEETypeTypeMixed     = 3,    //混合模式
};

@protocol TALAILabVEEManagerDelegate <NSObject>

@optional

/**
 引擎初始化成功
 */
- (void)oralEvaluatingInitSuccess;

/**
 评测开始
 */
- (void)oralEvaluatingDidStart;
/**
 评测停止
 */
- (void)oralEvaluatingDidStop;
/**
 评测完成后的结果
 */
- (void)oralEvaluatingDidEndWithResult:(NSDictionary *)result;
/**
 评测失败回调
 */
- (void)oralEvaluatingDidEndError:(NSError *)error;

/**
 录音数据回调
 */
- (void)oralEvaluatingRecordingBuffer:(NSData *)recordingData;

/**
 录音音量大小回调
 */
- (void)oralEvaluatingDidUpdateVolume:(int)volume;

/**
 VAD(前置时间）超时回调
 */
- (void)oralEvaluatingDidVADFrontTimeOut;

/**
 VAD(后置时间）超时回调
 */
- (void)oralEvaluatingDidVADBackTimeOut;

/**
 录音即将超时（只支持在线模式，单词20s，句子40s)
 */
- (void)oralEvaluatingDidRecorderWillTimeOut;

@end



@interface TALAILabVEEManager : NSObject

@property (nonatomic, weak) id<TALAILabVEEManagerDelegate> delegate;

+ (instancetype)sharedInstance;

/**
 返回版本号
 
 @return 版本号
 */
+ (NSString *)version;

/**
 注册初始化参数
 
 @param config 初始化参数
 */
+ (void)registerEvaluatingManagerConfig:(TALAILabVEEManagerConfig *)config;

/**
 注册全局评测模式
 
 @param type 评测模式
 */
- (void)registerEvaluatingType:(TALAILabVEEType)type;

/**
 初始化对象
 
 @param config 初始化参数
 @param type 评测模式
 @return 对象
 */
- (instancetype)initWithManagerConfig:(TALAILabVEEManagerConfig *)config type:(TALAILabVEEType)type;

/**
 开始评测
 
 @param config 评测配置
 */
- (void)startEvaluateOralWithConfig:(TALAILabVEEConfig *)config;

/**
 开始评测
 
 @param config 评测配置
 @param storeWavPath 音频存储路径
 */
- (void)startEvaluateOralWithConfig:(TALAILabVEEConfig *)config storeWavPath:(NSString *)storeWavPath;

/**
 开始评测(本地音频文件)
 
 @param wavPath 本地音频文件地址
 */
- (void)startEvaluateOralWithWavPath:(NSString *)wavPath config:(TALAILabVEEConfig *)config;

/**
 停止评测，返回结果
 */
- (void)stopEvaluate;

/**
 取消评测
 */
- (void)cancelEvaluate;

/**
 引擎释放
 */
- (void)engineDealloc;

/**
 清除所有录音文件（只针对调用startEvaluateOralWithConfig:)
 
 @return YES is Success
 */
+ (BOOL)clearAllRecord;

/**
 返回录音文件地址 （只针对调用startEvaluateOralWithConfig:)
 
 @param tokenId 结果的tokenId
 @return 本地录音路径
 */
+ (NSString *)recordPathWithTokenId:(NSString *)tokenId;

@end
