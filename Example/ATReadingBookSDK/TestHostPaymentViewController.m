//
//  TestHostPaymentViewController.m
//  ReadingBookDemo
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018 Summer. All rights reserved.
//

#import "TestHostPaymentViewController.h"

@interface TestHostPaymentViewController ()

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIButton *button5;
@property (nonatomic, strong) UIButton *button6;

@end

@implementation TestHostPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:({
        UIButton *retButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40.f)];
        retButton.backgroundColor = [UIColor purpleColor];
        [retButton setTitle:@"购买全level一个月" forState:UIControlStateNormal];
        [retButton sizeToFit];
        _button1 = retButton;
        [retButton addTarget:self action:@selector(p_back:) forControlEvents:UIControlEventTouchUpInside];
        retButton;
    })];
    
    [self.view addSubview:({
        UIButton *retButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 40.f)];
        retButton.backgroundColor = [UIColor purpleColor];
        [retButton setTitle:@"购买全level半年" forState:UIControlStateNormal];
        [retButton sizeToFit];
        _button2 = retButton;
        [retButton addTarget:self action:@selector(p_back:) forControlEvents:UIControlEventTouchUpInside];
        retButton;
    })];
    
    [self.view addSubview:({
        UIButton *retButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 40.f)];
        retButton.backgroundColor = [UIColor purpleColor];
        [retButton setTitle:@"购买全level一年" forState:UIControlStateNormal];
        [retButton sizeToFit];
        _button3 = retButton;
        [retButton addTarget:self action:@selector(p_back:) forControlEvents:UIControlEventTouchUpInside];
        retButton;
    })];
    
    [self.view addSubview:({
        UIButton *retButton = [[UIButton alloc] initWithFrame:CGRectMake(300, 100, 100, 40.f)];
        retButton.backgroundColor = [UIColor purpleColor];
        [retButton setTitle:@"购买指定level一个月" forState:UIControlStateNormal];
        [retButton sizeToFit];
        _button4 = retButton;
        [retButton addTarget:self action:@selector(p_back:) forControlEvents:UIControlEventTouchUpInside];
        retButton;
    })];
    
    [self.view addSubview:({
        UIButton *retButton = [[UIButton alloc] initWithFrame:CGRectMake(300, 200, 100, 40.f)];
        retButton.backgroundColor = [UIColor purpleColor];
        [retButton setTitle:@"购买指定level半年" forState:UIControlStateNormal];
        [retButton sizeToFit];
        _button5 = retButton;
        [retButton addTarget:self action:@selector(p_back:) forControlEvents:UIControlEventTouchUpInside];
        retButton;
    })];
    
    [self.view addSubview:({
        UIButton *retButton = [[UIButton alloc] initWithFrame:CGRectMake(300, 300, 100, 40.f)];
        retButton.backgroundColor = [UIColor purpleColor];
        [retButton setTitle:@"购买指定level一年" forState:UIControlStateNormal];
        [retButton sizeToFit];
        _button6 = retButton;
        [retButton addTarget:self action:@selector(p_back:) forControlEvents:UIControlEventTouchUpInside];
        retButton;
    })];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) p_back:(UIButton *)sender {
    if (sender == self.button1) {   //全level一个月
        self.backBlock(YES, 3);
    } else if (sender == self.button2) {    //全level半年
        self.backBlock(YES, 1);
    } else if (sender == self.button3) {    //全level一年
        self.backBlock(YES, 2);
    } else if (sender == self.button4) {    //指定level一个月
        self.backBlock(NO, 3);
    } else if (sender == self.button5) {    //指定level半年
        self.backBlock(NO, 1);
    } else {    //指定level一年
        self.backBlock(NO, 2);
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
