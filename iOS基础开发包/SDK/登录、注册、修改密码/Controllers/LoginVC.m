//
//  LoginVC.m
//
//  Created by ArthurShuai on 16/7/29.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic,strong)UIView *coverView;

@end

@implementation LoginVC
static BOOL isHold;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _loginBtn.enabled = YES;
}
- (void)setupCoverView{
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 45)];
    _coverView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.navigationController.navigationBar addSubview:_coverView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isHold = YES;
    _loginBtn.layer.cornerRadius = 5;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (IBAction)holdPassword:(UIButton *)sender {
    sender.selected = !sender.selected;
    isHold = !isHold;
}
- (IBAction)login:(UIButton *)sender {
    sender.enabled = NO;
}

//键盘回车键点击
- (IBAction)inputDoneClick:(UITextField *)sender {
    [sender endEditing:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_coverView removeFromSuperview];
}

@end
