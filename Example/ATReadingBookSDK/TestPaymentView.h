//
//  TestPaymentView.h
//  ReadingBookDemo
//
//  Created by admin on 2018/9/26.
//  Copyright © 2018 Summer. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^kATPaymentSuccessCallBackBlock)(void);

@interface TestPaymentView : UIView
@property(nonatomic, copy) kATPaymentSuccessCallBackBlock payCallBack;
- (void) setPaymentInfoStr:(NSString *) paymentInfo;
@end
