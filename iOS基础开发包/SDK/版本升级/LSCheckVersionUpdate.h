//
//  LSCheckVersionUpdate.h
//
//  Created by ArthurShuai on 16/10/31.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//
//  系统名称：检查系统版本

#import <Foundation/Foundation.h>



@interface LSCheckVersionUpdate : NSObject

@property (nonatomic,strong)NSString *version;
@property (nonatomic,strong)NSString *descriptions;

- (void)showAlertView;

@end
