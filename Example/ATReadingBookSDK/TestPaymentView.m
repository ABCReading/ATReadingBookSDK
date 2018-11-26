//
//  TestPaymentView.m
//  ReadingBookDemo
//
//  Created by admin on 2018/9/26.
//  Copyright © 2018 Summer. All rights reserved.
//

#import "TestPaymentView.h"
@interface TestPaymentView()
@property(nonatomic, strong) UIButton *successCallBackButton;
@property(nonatomic, strong) UILabel *paymentInfoLabel;
@end

@implementation TestPaymentView
- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor purpleColor];
        //1. 支付信息展示
        [self addSubview:({
            UILabel *retLabel = [[UILabel alloc] init];
            retLabel.backgroundColor = [UIColor yellowColor];
            retLabel.textColor = [UIColor blackColor];
            retLabel.text = @"NULL";
            retLabel.font = [UIFont systemFontOfSize:16.f];
            _paymentInfoLabel = retLabel;
            retLabel;
        })];
        
        //2. 支付成功回调
        [self addSubview:({
            UIButton *retBtn = [[UIButton alloc] init];
            [retBtn setTitle:@"支付成功回调>>paymentSuccessWithTransaction" forState:UIControlStateNormal];
            [retBtn sizeToFit];
            retBtn.backgroundColor = [UIColor redColor];
            [retBtn addTarget:self action:@selector(p_paymentSuccess:) forControlEvents:UIControlEventTouchUpInside];
            _successCallBackButton = retBtn;
            retBtn;
        })];
    }
    return self;
}

- (void) setPaymentInfoStr:(NSString *) paymentInfo {
    self.paymentInfoLabel.text = paymentInfo;
    [self.paymentInfoLabel sizeToFit];
    self.paymentInfoLabel.frame = (CGRect){30.f, 30.f, self.paymentInfoLabel.frame.size};
    
    self.successCallBackButton.frame = (CGRect){30.f, 30.f + self.paymentInfoLabel.frame.size.height + 20.f, self.successCallBackButton.frame.size};
}

// 
- (void) p_paymentSuccess:(id)sender {
    NSLog(@"p_paymentSuccess callBack ... ...");
    if (self.payCallBack) {
        self.payCallBack();
    }
    
}
@end
