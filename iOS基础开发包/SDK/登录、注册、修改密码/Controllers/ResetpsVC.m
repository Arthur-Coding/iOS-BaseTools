//
//  ResetpsVC.m
//
//  Created by ArthurShuai on 16/7/30.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "ResetpsVC.h"

@interface ResetpsVC ()

@property (weak, nonatomic) IBOutlet UITextField *newpassword;
@property (weak, nonatomic) IBOutlet UITextField *newpasswordSure;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation ResetpsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _saveBtn.layer.cornerRadius = 5;
}
- (IBAction)saveNewPassword:(UIButton *)sender {
    
}

- (IBAction)inputDoneClick:(UITextField *)sender {
    [sender endEditing:YES];
}

@end
