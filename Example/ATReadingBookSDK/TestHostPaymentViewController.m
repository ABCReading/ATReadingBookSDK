//
//  TestHostPaymentViewController.m
//  ReadingBookDemo
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018 Summer. All rights reserved.
//

#import "TestHostPaymentViewController.h"

@interface TestHostPaymentViewController ()

@end

@implementation TestHostPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:({
        UIButton *retButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40.f)];
        retButton.backgroundColor = [UIColor purpleColor];
        [retButton setTitle:@"支付页面backBtn" forState:UIControlStateNormal];
        [retButton sizeToFit];
        [retButton addTarget:self action:@selector(p_back) forControlEvents:UIControlEventTouchUpInside];
        retButton;
    })];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) p_back {
    if (self.backBlock) {
        self.backBlock();
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
