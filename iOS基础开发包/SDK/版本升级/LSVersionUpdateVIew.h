//
//  LSVersionUpdateVIew.h
//
//  Created by ArthurShuai on 16/10/31.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//
//  系统名称：版本升级提示界面

#import <UIKit/UIKit.h>

typedef void(^RemoveUpdateViewBlock)();

@interface LSVersionUpdateVIew : UIView

@property (nonatomic, copy)RemoveUpdateViewBlock removeUpdateViewBlock;

@property (nonatomic, copy)dispatch_block_t GoTOAppstoreBlock;

-(instancetype)initWith:(NSString *)version Describe:(NSArray *)describeArr;

@end
