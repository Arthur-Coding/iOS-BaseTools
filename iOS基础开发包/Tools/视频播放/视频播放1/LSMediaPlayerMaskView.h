//
//  LSMediaPlayerMaskView.h
//
//  Created by ArthurShuai on 16/10/28.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LSMediaPlayerMaskView : UIView

/** bottomView*/
@property (nonatomic, strong)UIImageView     *bottomImageView;
/** topView */
@property (nonatomic, strong)UIImageView     *topImageView;
/** 开始播放按钮 */
@property (strong, nonatomic)UIButton       *startBtn;
/** 当前播放时长label */
@property (strong, nonatomic)UILabel        *currentTimeLabel;
/** 视频总时长label */
@property (strong, nonatomic)UILabel        *totalTimeLabel;
/** 缓冲进度条 */
@property (strong, nonatomic)UIProgressView *progressView;
/** 滑杆 */
@property (strong, nonatomic)UISlider       *videoSlider;
/** 全屏按钮 */
@property (strong, nonatomic)UIButton       *fullScreenBtn;
@property (strong, nonatomic)UIButton       *lockBtn;

/** 画面背景控件视图 */
@property (nonatomic,strong)UIView *coverView;

/** 音量进度 */
@property (nonatomic,strong) UIProgressView   *volumeProgress;

/** 系统加载图 */
@property (nonatomic,strong)UIActivityIndicatorView *activity;

@property (nonatomic,copy)CGFloat(^volumeControlBlk)(BOOL);

@end
