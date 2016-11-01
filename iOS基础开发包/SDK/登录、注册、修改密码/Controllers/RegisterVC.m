//
//  RegisterVC.m
//
//  Created by ArthurShuai on 16/7/29.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()

//填写用户名与密码界面数据
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *nextStep;
//添加手机号，获取验证码注册界面数据
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UITextField *countryCodeText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *vfcodeText;
@property (weak, nonatomic) IBOutlet UIButton *getVFcode;
@property (weak, nonatomic) IBOutlet UIButton *finish;

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation RegisterVC{
    NSInteger _second;
    NSString *_registerUsername;
    NSString *_registerPassword;
}
- (void)config{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    _usernameText.layer.cornerRadius =5;
    _passwordText.layer.cornerRadius = 5;
    _nextStep.layer.cornerRadius = 5;
    
    _phoneView.layer.cornerRadius = 5;
    _vfcodeText.layer.cornerRadius = 5;
    _getVFcode.layer.cornerRadius = 5;
    _getVFcode.titleLabel.adjustsFontSizeToFitWidth = YES;
    _getVFcode.titleLabel.minimumScaleFactor = 0.5;
    _getVFcode.titleLabel.numberOfLines = 2;
    _finish.layer.cornerRadius = 5;
    _second = 60;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
}

- (IBAction)getVFcode:(UIButton *)sender {
    sender.enabled = NO;
    
}
- (void)getVFcodeCount:(NSTimer *)timer{
    _second--;
    if (_second == 0) {
        _second = 60;
        [_getVFcode setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getVFcode.backgroundColor = [UIColor orangeColor];
        _getVFcode.enabled = YES;
        [timer invalidate];
    }else{
        [_getVFcode setTitle:[@(_second).stringValue stringByAppendingString:@"s"] forState:UIControlStateNormal];
    }
}
- (IBAction)finishRegister:(UIButton *)sender {
    if (_phoneText.text.length == 0) {
        
    }else if (_vfcodeText.text.length == 0) {
        
    }else{
        
    }
}
//键盘回车键点击
- (IBAction)inputDoneClick:(UITextField *)sender {
    [sender endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"nextStep"]) {
        _registerUsername = _usernameText.text;
        _registerPassword = _passwordText.text;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_timer invalidate];
}

@end
