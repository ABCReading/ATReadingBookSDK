//
//  TestHostPaymentViewController.h
//  ReadingBookDemo
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018 Summer. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^kPayBackBlock)(void);
@interface TestHostPaymentViewController : UIViewController
@property(nonatomic, copy) kPayBackBlock backBlock;
@end
