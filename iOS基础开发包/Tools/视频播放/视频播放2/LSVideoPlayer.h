//
//  LSVideoPlayer.h
//
//  Created by ArthurShuai on 16/10/31.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//  系统名称：视频播放

#import <Foundation/Foundation.h>

@interface LSVideoPlayer : NSObject

+ (instancetype)shared;
/**
 视频播放视图

 @param videoUrl 视频URL
 @param frame    视图视图尺寸

 @return 视频播放视图
 */
+ (UIView *)videoPlayerWithURL:(NSURL *)videoUrl andFrame:(CGRect)frame;

@end
