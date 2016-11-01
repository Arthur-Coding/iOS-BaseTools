//
//  Launch.h
//
//  Created by ArthurShuai on 16/10/26.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//
//  系统名称：启动页
//  功能描述：自定义启动页面，请在对应的xib文件中添加控件
//  创建时间：刘帅     2016年10月26日


#import <UIKit/UIKit.h>

@interface LaunchVC : UIViewController

/**
 *  设置启动页停留时间,单位：S
 */
@property (nonatomic)NSInteger launchTimeInterval;

@end
