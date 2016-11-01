//
//  PhoneVC.m
//
//  Created by ArthurShuai on 16/7/30.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "PhoneVC.h"

@interface PhoneVC ()

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UITextField *countryCode;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *vfCodeText;
@property (weak, nonatomic) IBOutlet UIButton *getVFcode;
@property (weak, nonatomic) IBOutlet UIButton *finish;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic)NSInteger second;

@end

@implementation PhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    _phoneView.layer.cornerRadius = 5;
    _vfCodeText.layer.cornerRadius = 5;
    _getVFcode.layer.cornerRadius = 5;
    _getVFcode.titleLabel.adjustsFontSizeToFitWidth = YES;
    _getVFcode.titleLabel.minimumScaleFactor = 0.5;
    _getVFcode.titleLabel.numberOfLines = 2;
    _finish.layer.cornerRadius = 5;
    _second = 60;
}

- (IBAction)getAuthCode:(UIButton *)sender {
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

- (IBAction)inputDoneClick:(UITextField *)sender {
    [sender endEditing:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_timer invalidate];
}

@end
