//
//  TestHostRedeemViewController.m
//  ReadingBookDemo
//
//  Created by Summer on 2019/4/8.
//  Copyright © 2019年 Summer. All rights reserved.
//

#import "TestHostRedeemViewController.h"

@interface TestHostRedeemViewController ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation TestHostRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    UITextField *retTextField;
    [self.view addSubview:({
        retTextField = [[UITextField alloc] initWithFrame:(CGRect){200,200,300,50}];
        retTextField.backgroundColor = [UIColor orangeColor];
        retTextField.textColor = [UIColor blackColor];
        _textField = retTextField;
        retTextField;
    })];
    
    [self.view addSubview:({
        UIButton *retButton = [[UIButton alloc] initWithFrame:(CGRect){200,300,100,100}];
        retButton.backgroundColor = [UIColor orangeColor];
        [retButton setTitle:@"立即兑换" forState:UIControlStateNormal];
        [retButton addTarget:self
                      action:@selector(p_redeemButtonAction:)
            forControlEvents:UIControlEventTouchUpInside];
        retButton;
    })];
    
    [self.view addSubview:({
        UIButton *retButton = [[UIButton alloc] initWithFrame:(CGRect){10,10,100,100}];
        retButton.backgroundColor = [UIColor orangeColor];
        [retButton setTitle:@"返回" forState:UIControlStateNormal];
        [retButton addTarget:self
                      action:@selector(p_backButtonAction:)
            forControlEvents:UIControlEventTouchUpInside];
        retButton;
    })];
}

- (void)p_redeemButtonAction:(UIButton *)sender {
    [self.textField resignFirstResponder];
    if (self.redeemBlock) {
        self.redeemBlock(self.textField.text);
    }
}

- (void)p_backButtonAction:(UIButton *)sender {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
}

@end
