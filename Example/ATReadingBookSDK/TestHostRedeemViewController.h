//
//  TestHostRedeemViewController.h
//  ReadingBookDemo
//
//  Created by Summer on 2019/4/8.
//  Copyright © 2019年 Summer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RedeemBlock)(NSString *code);
typedef void(^BackBlock)(void);

@interface TestHostRedeemViewController : UIViewController
@property (nonatomic, copy) RedeemBlock redeemBlock;
@property (nonatomic, copy) BackBlock backBlock;
@end

NS_ASSUME_NONNULL_END
