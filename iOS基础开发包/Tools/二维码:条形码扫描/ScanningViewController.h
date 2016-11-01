//
//  ScanningViewController.h
//
//  Created by ArthurShuai on 16/10/28.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//
//  系统名称：二维码/条形码扫描

#import <UIKit/UIKit.h>


@interface ScanningViewController : UIViewController

/**
 *  获取扫描结果
 */
@property (nonatomic,copy)void(^scanResultBlk)(NSString *);

@end
