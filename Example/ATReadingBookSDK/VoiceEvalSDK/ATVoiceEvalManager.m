//
//  ATVoiceEvalManager.m
//  ABCtimeVoiceEvalTest
//
//  Created by Vicky on 20/11/2017.
//  Copyright © 2017 Vicky. All rights reserved.
//

#import "ATVoiceEvalManager.h"
#import <AVFoundation/AVFoundation.h>

/** ABCtimeReadingBook_支持趣配音_语音评测
 appKey : @"a342"
 secretKey : @"c11163aa6c834a028da4a4b30955be23"
 */
static NSString *const evalAppKey = @"a342";//@"a155";
static NSString *const evalSecretKey = @"c11163aa6c834a028da4a4b30955be23";//@"c11163aa6c834a028da4a4b30955bc34";

// 语音测评管理工具类
@interface ATVoiceEvalManager() <TALAILabVEEManagerDelegate>
@end

@implementation ATVoiceEvalManager

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id __singleton__;
    dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } );
    return __singleton__; 
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.voiceManager = [TALAILabVEEManager sharedInstance];
        
        // TAL AILab SDK 初始化配置;
        [TALAILabVEEManager registerEvaluatingManagerConfig:[self p_managerConfig]];
        [[TALAILabVEEManager sharedInstance] registerEvaluatingType:TALAILabVEETypeTypeOffLine];
        [TALAILabVEEManager sharedInstance].delegate = self;
    }
    return self;
}

// MARK: -  文件配置, evalManager配置, 固定配置不会更改
- (TALAILabVEEManagerConfig *) p_managerConfig {
    TALAILabVEEManagerConfig *config = [[TALAILabVEEManagerConfig alloc] init];

    config.appKey = evalAppKey;
    config.secretKey = evalSecretKey;
    
    return config;
}

// 测评配置
- (TALAILabVEEConfig *)p_voiceConfig: (NSString *)oralContent {
    TALAILabVEEConfig *config = [[TALAILabVEEConfig alloc] init];
    config.coreType = TALAILabVEECoreTypeSentence;  // 题型(必选）
    
    //  内容(非必选）评测的原始数据, 根据我们提供的文本数据进行打分
    config.oralContent = oralContent;
    
    // 评分松紧度，范围0.8~1.5，数值越小，打分越严厉
    config.rateScale = 1.1;
    
    /**
     重传机制类型：
     0是默认值，不重传；
     1表示重传，出现这类异常时，等待测评时间很短，重传不会影响用户体验。
     2表示重传，出现这类异常时，等待测评的时间很长，重传可能会导致用户等待很久。（2包含1重传的情况）
     */
    config.enableRetry = 1;
    return config;
}

// 开始测评方法
- (void)startEvaluate: (NSString *)oralContent {
    [self.voiceManager startEvaluateOralWithConfig:[self p_voiceConfig:oralContent]];
}

// 停止测评方法
- (void)stopEvaluate {
    [self.voiceManager stopEvaluate];
}

// 取消测评
- (void)cancelEvaluate {
    [self.voiceManager cancelEvaluate];
}

// 释放引擎
- (void)releaseEngine {
    // 释放引擎后, block置空
    if (self.evalResultBlock) {
        self.evalResultBlock = nil;
    }
}

// 录音文件本地的绝对路径;
- (NSString *)getRecordPathWithToken:(NSString *)token {
    return [TALAILabVEEManager recordPathWithTokenId:token];
}

/**
 清除所有录音文件（只针对调用startEvaluateOralWithConfig:)
 @return YES is Success
 */
- (BOOL)clearAllRecord {
    return [TALAILabVEEManager clearAllRecord];
}

// MARK: -  TALAILabVEEManagerDelegate
// 引擎初始化成功
- (void)oralEvaluatingInitSuccess {
    //NSLog(@"引擎初始化成功! >>");
}

// 评测开始
- (void)oralEvaluatingDidStart {
    //NSLog(@"开始测评 >>");
}

// 评测停止
- (void)oralEvaluatingDidStop {
    //NSLog(@"测评停止 >> oralEvaluatingDidStop");
    if (self.evalResultBlock) {
        NSError *error = [NSError errorWithDomain:@"com.eval.error"
                                             code:-2396
                                         userInfo:@{NSLocalizedDescriptionKey:@"测评意外停止了!"}];
        self.evalResultBlock(error, NO);
    }
}

// 评测完成后的结果
- (void)oralEvaluatingDidEndWithResult:(NSDictionary *)result {

    if ([result[@"result"][@"wavetime"] intValue] < 300) {
        // 录音时间过短
        if (self.evalResultBlock) {
            // Domin与errorcode 随意定义的，以后有规范的话再修改
            NSError *error = [NSError errorWithDomain:@"com.eval.error"
                                                 code:-2395
                                             userInfo:@{NSLocalizedDescriptionKey:@"录音时间过短!"}];
            self.evalResultBlock(error, NO);
        }
    } else {
        if (self.evalResultBlock) {
            // 将结果的字典转成model
            ATVoiceEvalResultModel *model = [[ATVoiceEvalResultModel alloc] init];
            [model transfromFromEvalResult:result];
            self.evalResultBlock(model, YES);
        }
    }
}

/**
 评测失败回调
 */
- (void)oralEvaluatingDidEndError:(NSError *)error {
    NSLog(@"测评失败: %@", error.description);
    if (self.evalResultBlock) {
        // 返回error的result
        self.evalResultBlock(error, NO);
    }
}

/**
 录音数据回调
 */
- (void)oralEvaluatingRecordingBuffer:(NSData *)recordingData {
//    NSLog(@"录音数据回调");
}

/**
 录音音量大小回调
 */
- (void)oralEvaluatingDidUpdateVolume:(int)volume {
//    NSLog(@"录音音量大小回调");
}

/**
 VAD(前置时间）超时回调
 */
- (void)oralEvaluatingDidVADFrontTimeOut {
//    NSLog(@"VAD(前置时间）超时回调");
}

/**
 VAD(后置时间）超时回调
 */
- (void)oralEvaluatingDidVADBackTimeOut {
//    NSLog(@"VAD(后置时间）超时回调");
}

@end

// ======================================================================================== //
// MARK: -  ATVoiceEvalResultModel 先声结果model类
// ======================================================================================== //

#define ATReadingExcellentScore     (85)
#define ATReadingTryAgainScore      (20)
@interface ATVoiceEvalResultModel()<NSCoding>
@end

@implementation ATVoiceEvalResultModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _score = @"-1";
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.recordId = [aDecoder decodeObjectForKey:@"recordIdKey"];
        self.tokenId = [aDecoder decodeObjectForKey:@"tokenIdKey"];
        self.score = [aDecoder decodeObjectForKey:@"scoreKey"];
        self.audioPath = [aDecoder decodeObjectForKey:@"audioPathKey"];
        self.scoreIntValue = [aDecoder decodeIntegerForKey:@"scoreIntValueKey"];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.recordId forKey:@"recordIdKey"];
    [aCoder encodeObject:self.tokenId forKey:@"tokenIdKey"];
    [aCoder encodeObject:self.score forKey:@"scoreKey"];
    [aCoder encodeObject:self.audioPath forKey:@"audioPathKey"];
    [aCoder encodeInteger:self.scoreIntValue forKey:@"scoreIntValueKey"];
}

- (BOOL) isEmptyResult {
    return [_score isEqualToString:@"-1"];
}

- (NSInteger) scoreIntValue {
    if (![self isEmptyResult] && [_score isKindOfClass:NSString.class]) {
        return [_score integerValue];
    }
    return -1;
}

- (BOOL) isExcellentScore {
    return _score.doubleValue >= ATReadingExcellentScore;
}

- (ATReadingScoreType)readingScoreType {
    
    if (_score.doubleValue >= ATReadingExcellentScore) {
        return ATReadingScoreTypeExcellent;
    } else if (_score.doubleValue < ATReadingExcellentScore
               && _score.doubleValue > ATReadingTryAgainScore) {
        return ATReadingScoreTypeGood;
    } else {
        return ATReadingScoreTypeTryAgain;
    }
    
}

- (NSString *)readingScoreVoiceName {
    
    if (_score.doubleValue >= ATReadingExcellentScore) {
        return @"gethighscore.mp3";
    } else if (_score.doubleValue < ATReadingExcellentScore
               && _score.doubleValue > ATReadingTryAgainScore) {
        return @"getnormalscore.mp3";
    } else {
        return @"getlowscore.mp3";
    }
    
}

- (NSString *) description {
    return [NSString stringWithFormat:@"score : %@, audioPath : %@, tokenId : %@, recordId : %@",
            self.score,
            self.audioPath,
            self.tokenId,
            self.recordId];
}

//MARK: TAL Eval 返回的resultDic parse to ATVoiceEvalResultModel
- (void)transfromFromEvalResult: (NSDictionary *)result {
    if (!result || ![result isKindOfClass:NSDictionary.class]) {
        NSLog(@"EvalResult is invalid dictionary >> %@", result);
        return;
    }

    NSNumber *retNum = result[@"result"][@"overall"];

    //  跟读规则：所有页面跟读成绩必须大于0才会显示跟读按钮 此处最低得分设置为1 减少相应的处理逻辑
    if (retNum.integerValue == 0) {
        self.score = @"1";
    }else {
        self.score = [NSString stringWithFormat:@"%ld", (long)retNum.integerValue];
    }

    self.recordId = result[@"recordId"] == nil ? @"" : result[@"recordId"];
    self.tokenId = result[@"tokenId"] == nil ? @"" : result[@"tokenId"];
    
    self.audioPath = [[ATVoiceEvalManager sharedInstance] getRecordPathWithToken:self.tokenId] ? : @"";
}

// TAL Eval 录音文件的本地绝对路径;
- (NSString *)audioFullPath {
    return self.audioPath;
}

@end
