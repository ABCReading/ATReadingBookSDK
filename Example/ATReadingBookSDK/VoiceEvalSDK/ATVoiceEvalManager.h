//
//  ATVoiceEvalManager.h
//  ABCtimeVoiceEvalTest
//
//  Created by Vicky on 20/11/2017.
//  Copyright © 2017 Vicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TALVoiceEvalSDK/TALVoiceEvalSDK.h>

@interface ATVoiceEvalManager : NSObject

@property (nonatomic, strong) TALAILabVEEManager *voiceManager;
@property (nonatomic, copy) void (^evalResultBlock)(id result, BOOL isSuccess);

//QH_SINGLETON_DEF
+ (instancetype)sharedInstance;

/**
 开始测评
 @pram oralContent 测评的原始数据, 对于ABCtime就是绘本的文本
 */
- (void)startEvaluate: (NSString *)oralContent;

/**
 停止测评
 */
- (void)stopEvaluate;

/**
 取消测评
 */
- (void)cancelEvaluate;

/**
 根据tokenid获取录音的路径
 
 @param token 先声返回的token
 @return 录音的路径
 */
- (NSString *)getRecordPathWithToken:(NSString *)token;

/**
 释放引擎
 */
- (void)releaseEngine;

/**
 清除所有录音
 */
- (BOOL)clearAllRecord;

@end


// --------------------------------------------------------------------------- //
// MARK: -  TAL Eval resultDic to ATVoiceEvalResultModel

/**
 跟读得分类型

 - ATReadingScoreTypeExcellent: cool音效 [85,100]
 - ATReadingScoreTypeGood: good音效 (20,85)
 - ATReadingScoreTypeTryAgain: try again音效 (0,20]
 */
typedef NS_ENUM(NSUInteger, ATReadingScoreType) {
    ATReadingScoreTypeExcellent,
    ATReadingScoreTypeGood,
    ATReadingScoreTypeTryAgain,
};

@interface ATVoiceEvalResultModel : NSObject

@property (nonatomic, copy) NSString *recordId;             // 音频文件的唯一标识
@property (nonatomic, copy) NSString *tokenId;              // 用户请求的唯一标识
@property (nonatomic, copy) NSString *score;                // 分数
@property (nonatomic, copy) NSString *audioPath;            // 音频全路径

@property (nonatomic, assign) NSInteger scoreIntValue;      //分数整数格式；


/**
 解析先声返回的结果，model属性可以根据需要添加
 @param result 先声的返回结果
 */
- (void) transfromFromEvalResult: (NSDictionary *)result;

- (BOOL) isEmptyResult;

- (NSInteger) scoreIntValue;

- (BOOL) isExcellentScore;

/**
 跟读得分类型

 @return 跟读得分类型
 */
- (ATReadingScoreType)readingScoreType;

/**
 跟读得分音效

 @return 跟读得分音效
 */
- (NSString *)readingScoreVoiceName;

@end
