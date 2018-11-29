//
//  TALAILabVEEConfig.h
//  TALVoiceEvalSDK
//
//  Created by 张禹 on 2017/9/26.
//  Copyright © 2017年 Beijing Yidu Huida Education Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//评测的题型
typedef NS_ENUM(NSInteger, TALAILabVEECoreType) {
    TALAILabVEECoreTypeWord = 1,                               //单词
    TALAILabVEECoreTypeSentence,                               //语句
    TALAILabVEECoreTypeParagraph,                              //段落
    TALAILabVEECoreTypeChoose,                                 //选择题
    TALAILabVEECoreTypeEssayQuestion,                          //问答题
    TALAILabVEECoreTypePicture,                                //看图作文
    TALAILabVEECoreTypeChineseWord,                            //中文单词，只支持在线
    TALAILabVEECoreTypeChineseSentence,                        //中文句子，只支持在线
    TALAILabVEECoreTypeAlpha,                                  //字母评测
    TALAILabVEECoreTypeRec,                                    //自由识别
    TALAILabVEECoreTypePcha,                                   //句子选读
    TALAILabVEECoreTypeRetell,                                 //故事复述
    
};

//评分精确度
typedef NS_ENUM(NSInteger, TALAILabEvaluatingPrecision) {
    TALAILabEvaluatingPrecisionSmall,     //0.1
    TALAILabEvaluatingPrecisionMedium,    //0.5
    TALAILabEvaluatingPrecisionHigh,      //1
};
//混合模式下强制选择在线评测，离线评测。
typedef NS_ENUM(NSInteger, TALAILabMixedType) {
    TALAILabMixedTypeDefault,   //默认情况有网用在线，无网用离线
    TALAILabMixedTypeOnline,   //强制使用在线
    TALAILabMixedTypeOffline,   //强制使用离线
};

@class TALAILabEvaluatingAnswer;

@interface TALAILabVEEConfig : NSObject
/**
 声音格式 defaults is "wav"
 */
@property (nonatomic, copy) NSString *audioType;

/**
 采样率 defaults is 16000,
 Options are 8000,16000,44000.
 */
@property (nonatomic, assign) NSInteger sampleRate;
/**
 题型(必选）
 */
@property (nonatomic, assign) TALAILabVEECoreType coreType;

/**
 混合模式下强制选择在线评测，离线评测。
 */
@property (nonatomic, assign) TALAILabMixedType mixedType;

/**
 内容(非必选）
 */
@property (nonatomic, copy) NSString *oralContent;

/**
 分值(非必选 default:100）
 */
@property (nonatomic, assign) NSUInteger rank;

/**
 用户ID(非必选 default:@"this-is-user-id"）
 */
@property (nonatomic, copy) NSString *userId;

/**
 评分精确度(非必选 default:EvaluatingPrecisionHigh）EvaluatingPrecisionSmall:0.1 EvaluatingPrecisionMedium:0.5 EvaluatingPrecisionHigh:1
 */
@property (nonatomic, assign) TALAILabEvaluatingPrecision precision;

/**
 评分松紧度，范围0.8~1.5，数值越小，打分越严厉
 */
@property (nonatomic, assign) CGFloat rateScale;

/**
 评分松紧度，可传 1，2，3，4。越来越松，1最严格，4最松。和rateScale不能同时传
 */
@property (nonatomic, assign) NSUInteger typeThres;

/**
 答案（非必选）
 */
@property (nonatomic, strong) NSArray<__kindof TALAILabEvaluatingAnswer *> *answerArray;

/**
 关键字数组（非必选）
 */
@property (nonatomic, strong) NSArray<__kindof NSString *> *keywordArray;

/**
 要点数组（非必选）
 */
@property (nonatomic, strong) NSArray<__kindof NSString *> *pointsArray;

/**
 问题 （非必选）\
 */
@property (nonatomic, copy) NSString *question;

/**
 录音文本（非必选）
 */
@property (nonatomic, copy) NSString *recorderContent;

/**
 句子评测中是否输出每个单词的音标分
 */
@property (nonatomic, assign) BOOL isOutputPhonogramForSentence;

/**
 重传机制类型：
 0是默认值，不重传；
 1表示重传，出现这类异常时，等待测评时间很短，重传不会影响用户体验。
 2表示重传，出现这类异常时，等待测评的时间很长，重传可能会导致用户等待很久。（2包含1重传的情况）
 */
@property (nonatomic, assign) NSInteger enableRetry;

/**
 评测音节信息，只支持单词评测，YES/1表示使用此功能，默认NO不使用
 */
@property (nonatomic, assign) BOOL isSyllable;

@end



@interface TALAILabEvaluatingAnswer : NSObject

/**
 分值
 */
@property (nonatomic, assign) CGFloat rank;

/**
 答案
 */
@property (nonatomic, copy) NSString *answer;

@end
