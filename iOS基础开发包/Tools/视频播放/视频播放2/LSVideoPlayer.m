//
//  LSVideoPlayer.m
//
//  Created by ArthurShuai on 16/10/31.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "LSVideoPlayer.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LSVideoPlayer ()

@property (nonatomic,strong)AVPlayer *player;

@end
@implementation LSVideoPlayer

+ (instancetype)shared{
    static LSVideoPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[LSVideoPlayer alloc] init];
    });
    return player;
}

+ (UIView *)videoPlayerWithURL:(NSURL *)videoUrl andFrame:(CGRect)frame{
    AVPlayer *player = [AVPlayer playerWithURL:videoUrl];
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    playerVC.player = player;
    playerVC.showsPlaybackControls = YES;
    playerVC.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerVC.view.frame = frame;
    return playerVC.view;
}

@end
