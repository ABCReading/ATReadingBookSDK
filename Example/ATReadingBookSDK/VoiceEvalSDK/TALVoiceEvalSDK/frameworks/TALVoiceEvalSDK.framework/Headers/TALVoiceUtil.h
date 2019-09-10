//
//  TALVoiceUtil.h
//  TALVoiceEvalSDK
//
//  Created by Baron on 2017/11/22.
//  Copyright © 2017年 Beijing Yidu Huida Education Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TALAILabConvertType) {
    TALAILabTypeIPA63   = 1,
    TALAILabTypeIPA88   = 2,
    TALAILabTypeKK      = 3,
};

@interface TALVoiceUtil : NSObject

+ (NSMutableArray*)VoiceConvert:(NSMutableArray*)inputArray convertType:(TALAILabConvertType)covertType;

@end
