//
//  ABCtimeReadingBookProtocol.h
//  ABCtimeReadingBookSDK
//
//  Created by Summer on 2018/9/18.
//  Copyright © 2018年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 跟读打分回调block

 @param evalResultDic 跟读结果
                   格式：@{@"score" : 跟读得分, @"audioPath" : 本次录音地址}
 @param success 是否成功
 */
typedef void(^ATVoiceEvalCompletedBlock)(NSDictionary *evalResultDic ,BOOL success);

@protocol ABCtimeReadingBookProtocol <NSObject>

/**
 开始录音

 @param pageContent 录音内容
 */
- (void)at_startRecordWithPageContent:(NSString *)pageContent;

/**
 结束录音并等待App返回打分结果

 @param complete 打分结果block
 */
- (void)at_endRecordWithComplete:(ATVoiceEvalCompletedBlock)complete;

/**
 取消本次录音(结束本次跟读打分不接受分数)
 */
- (void)at_cancelRecord;
@end
