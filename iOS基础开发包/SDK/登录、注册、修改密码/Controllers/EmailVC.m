//
//  EmailVC.m
//
//  Created by ArthurShuai on 16/7/29.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "EmailVC.h"

@interface EmailVC ()

@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end

@implementation EmailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _emailText.layer.cornerRadius = 5;
    _finishBtn.layer.cornerRadius = 5;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
}

//键盘回车键点击
- (IBAction)inputDoneClick:(UITextField *)sender {
    [sender endEditing:YES];
}

@end
