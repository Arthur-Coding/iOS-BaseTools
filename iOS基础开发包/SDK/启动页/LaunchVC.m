//
//  Launch.m
//
//  Created by ArthurShuai on 16/10/26.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "LaunchVC.h"

@interface LaunchVC ()

@end

@implementation LaunchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_launchTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /**
         *  此处执行启动页面启动完毕后的事件
         */
    });
}

@end
