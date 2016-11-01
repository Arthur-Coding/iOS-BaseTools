//
//  ChangePasswordVC.m
//
//  Created by ArthurShuai on 16/10/14.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "ChangePasswordVC.h"

@interface ChangePasswordVC ()

@property (weak, nonatomic) IBOutlet UITextField *originalPassword;
@property (weak, nonatomic) IBOutlet UITextField *newpassword;
@property (weak, nonatomic) IBOutlet UITextField *reNewPassword;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _saveBtn.layer.cornerRadius = 5;
}
- (IBAction)saveButtonClick:(UIButton *)sender {
    if (_originalPassword.text.length == 0) {
        kAlert(self, @"原密码不能为空")
    }else if (_originalPassword.text.length < 6 || _originalPassword.text.length > 20){
        kAlert(self, @"原密码位数不对")
    }else if (_newpassword.text.length == 0){
        kAlert(self, @"新密码不能为空")
    }else if (_newpassword.text.length < 6 || _newpassword.text.length > 20){
        kAlert(self, @"新密码位数不对")
    }else if (_reNewPassword.text.length == 0){
        kAlert(self, @"重复新密码不能为空")
    }else if (_reNewPassword.text.length < 6 || _reNewPassword.text.length > 20){
        kAlert(self, @"重复新密码位数不对")
    }else if (![_newpassword.text isEqualToString:_reNewPassword.text]){
        kAlert(self, @"新密码与重复新密码不相同")
    }else{
        
    }
}

@end
