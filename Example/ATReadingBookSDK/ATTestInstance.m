//
//  ATTestInstance.m
//  ReadingBookDemo
//
//  Created by lianglibao on 2018/9/24.
//  Copyright © 2018年 Summer. All rights reserved.
//

#import "ATTestInstance.h"

@implementation ATTestInstance
    static ATTestInstance *_instance;
+ (instancetype)shareInsance {
    if (!_instance) {
        _instance = [self new];
    }
    return _instance;
}
    - (instancetype)init {
        if (!_instance) {
            _instance = [super init];
        }
        return _instance;
    }
    
    + (void)destory {
        _instance = nil;
    }
@end
