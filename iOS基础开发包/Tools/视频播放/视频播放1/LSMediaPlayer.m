//
//  LSMediaPlayer.m
//
//  Created by ArthurShuai on 16/10/28.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "LSMediaPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LSMediaPlayerMaskView.h"

//枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, //横向移动
    PanDirectionVerticalMoved   //纵向移动
};

//播放器的几种状态
typedef NS_ENUM(NSInteger, ZFPlayerState) {
    ZFPlayerStateBuffering,  //缓冲中
    ZFPlayerStatePlaying,    //播放中
    ZFPlayerStateStopped,    //停止播放
    ZFPlayerStatePause       //暂停播放
};

@interface LSMediaPlayer ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerItem *playerItme;
@property(nonatomic,strong)AVPlayerLayer *playerLayer;

@property(nonatomic,strong)LSMediaPlayerMaskView *maskView;

@property(nonatomic)CGRect smallFrame;
@property(nonatomic)CGRect bigFrame;

/** 定义一个实例变量，保存枚举值 */
@property (nonatomic)PanDirection panDirection;
@property(nonatomic)ZFPlayerState playState;

@property(nonatomic)BOOL isDragSlider;
/** 是否被用户暂停 */
@property (nonatomic)BOOL isPauseByUser;

/** 滑杆 */
@property (nonatomic)UISlider *volumeViewSlider;

@end

@implementation LSMediaPlayer
#pragma mark - Setter
-(void)setPlayState:(ZFPlayerState)playState {
    if (playState != ZFPlayerStateBuffering) {
        [self.maskView.activity stopAnimating];
    }
    _playState = playState;
}
-(void)setVideoURL:(NSURL *)videoURL{
    //将之前的监听时间移除掉。
    [self.playerItme removeObserver:self forKeyPath:@"status"];
    [self.playerItme removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItme removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItme removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    self.playerItme = nil;
    
    self.playerItme = [AVPlayerItem playerItemWithURL:videoURL];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItme];
    // AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    // 监听播放状态
    [self.playerItme addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听loadedTimeRanges属性
    [self.playerItme addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    // Will warn you when your buffer is empty
    [self.playerItme addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    // Will warn you when your buffer is good to go again.
    [self.playerItme addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    self.playState = ZFPlayerStateBuffering;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.smallFrame = frame;
        self.bigFrame = CGRectMake(0, 0,kScreenH, kScreenW);
        
        self.player = [AVPlayer playerWithURL:[NSURL URLWithString:@""]];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
        //控制内容的填充方式 //代优化
        if([self.playerLayer.videoGravity isEqualToString:AVLayerVideoGravityResizeAspect]){
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        }else{
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        }
        [self.layer insertSublayer:self.playerLayer atIndex:0];
        
        self.maskView = [[LSMediaPlayerMaskView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.maskView];
        
        // 音量控制按钮点击回调
        __weak typeof(self) weakSelf = self;
        self.maskView.volumeControlBlk = ^CGFloat(BOOL isVolumeUp){
            if (isVolumeUp) {//加音量
                if(weakSelf.player.volume < 2){
                    weakSelf.player.volume += 0.3;
                }else{
                    weakSelf.player.volume = 2;
                }
            }else{//减音量
                if (weakSelf.player.volume > 0) {
                    weakSelf.player.volume -= 0.3;
                }else{
                    weakSelf.player.volume = 0;
                }
            }
            return weakSelf.player.volume;
        };
        // 全屏按钮点击事件
        [self.maskView.fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        // 播放按钮点击事件
        [self.maskView.startBtn addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // slider开始滑动事件
        [self.maskView.videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [self.maskView.videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [self.maskView.videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        
        // app退到后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        //监控屏幕旋转
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        [self setTheProgressOfPlayTime];
        [self getVolumeVolue];
        
        // 添加平移手势，用来控制音量、亮度、快进快退
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
        pan.delegate                = self;
        [self addGestureRecognizer:pan];
        
        //添加点击手势，控制状态栏、音量进度条等的显示和隐藏
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
- (void)tapAction:(UITapGestureRecognizer *)tap {
    WeakObj(self)
    if (self.maskView.coverView.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            weakself.maskView.coverView.alpha = 0;
            weakself.maskView.topImageView.alpha = 0;
            weakself.maskView.bottomImageView.alpha = 0;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            weakself.maskView.coverView.alpha = 1;
            weakself.maskView.topImageView.alpha = 1;
            weakself.maskView.bottomImageView.alpha = 1;
        }];
    }
}
#pragma mark - 屏幕滑动手势方法
-(void)horizontalMoved:(CGFloat)value {
    self.maskView.videoSlider.value += value/10000;
}
- (void)verticalMoved:(CGFloat)value {
    if (value > 0) {
        if (self.player.volume > 0) {
            self.player.volume -= 0.3;
        }else{
            self.player.volume = 0;
        }
    }else{
        if(self.player.volume < 2){
            self.player.volume += 0.3;
        }else{
            self.player.volume = 2;
        }
    }
    self.maskView.volumeProgress.progress = self.player.volume/2;
    // 更改系统的音量
    self.volumeViewSlider.value      -= value / 10000;// 越小幅度越小
}
- (void)panDirection:(UIPanGestureRecognizer *)pan {
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                self.panDirection           = PanDirectionHorizontalMoved;
                self.isDragSlider = YES;
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    [self progressSliderValueChanged:self.maskView.videoSlider];
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self progressSliderTouchEnded:self.maskView.videoSlider];
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Volume 系统音量
-(void)getVolumeVolue {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            [self addSubview:_volumeViewSlider];
         break;
        }
    }
    _volumeViewSlider.frame = CGRectMake(-1000, -1000, 100, 100);

    /* 马上获取不到值 */
    [self performSelector:@selector(afterOneSecond) withObject:nil afterDelay:1];
}
-(void)afterOneSecond {
    self.maskView.volumeProgress.progress = _volumeViewSlider.value;
}

#pragma mark - slider事件
// slider开始滑动事件
- (void)progressSliderTouchBegan:(UISlider *)slider {
    self.isDragSlider = YES;
}
// slider滑动中事件
- (void)progressSliderValueChanged:(UISlider *)slider {
    CGFloat total = (CGFloat)self.playerItme.duration.value / self.playerItme.duration.timescale;
    
    CGFloat current = total*slider.value;
    //秒数
    NSInteger proSec = (NSInteger)current%60;
    //分钟
    NSInteger proMin = (NSInteger)current/60;
    self.maskView.currentTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
}
// slider结束滑动事件
- (void)progressSliderTouchEnded:(UISlider *)slider {
    //计算出拖动的当前秒数
    CGFloat total           = (CGFloat)self.playerItme.duration.value / self.playerItme.duration.timescale;
    
    NSInteger dragedSeconds = floorf(total * slider.value);
    
    //转换成CMTime才能给player来控制播放进度
    
    CMTime dragedCMTime     = CMTimeMake(dragedSeconds, 1);

    [self endSlideTheVideo:dragedCMTime];
    
    WeakObj(self)
    if (self.maskView.coverView.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            weakself.maskView.coverView.alpha = 0;
            weakself.maskView.topImageView.alpha = 0;
            weakself.maskView.bottomImageView.alpha = 0;
        }];
    }
}

// 滑动结束视频跳转
- (void)endSlideTheVideo:(CMTime)dragedCMTime {
    [self.player pause];
    [self.maskView.activity startAnimating];
    
    [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
        // 如果点击了暂停按钮
        [self.maskView.activity stopAnimating];
        if (self.isPauseByUser) {
            self.isDragSlider = NO;
            return ;
        }
//        [_player play];
//        if (!self.playerItme.isPlaybackLikelyToKeepUp) {
//            self.playState = ZFPlayerStateBuffering;
//            //NSLog(@"显示菊花");
//            [self.maskView.activity startAnimating];
//        }
        if ((self.maskView.progressView.progress - self.maskView.videoSlider.value) > 0.01) {
            [self.maskView.activity stopAnimating];
            [self.player play];
        }else{
            [self bufferingSomeSecond];
            
        }
        self.isDragSlider = NO;
    }];
}

//设置播放进度和时间
-(void)setTheProgressOfPlayTime {
    WeakObj(self)
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //如果是拖拽slider中就不执行
        if (weakself.isDragSlider) {
            return ;
        }
        
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([weakself.playerItme duration]);
        
        if (current) {
            [weakself.maskView.videoSlider setValue:(current/total) animated:YES];
        }
        
        //秒数
        NSInteger proSec = (NSInteger)current%60;
        //分钟
        NSInteger proMin = (NSInteger)current/60;
        
        //总秒数和分钟
        NSInteger durSec = (NSInteger)total%60;
        NSInteger durMin = (NSInteger)total/60;
        weakself.maskView.currentTimeLabel.text    = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        weakself.maskView.totalTimeLabel.text      = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    } ];
}

#pragma mark - 底部按钮点击事件
// 播放、暂停
- (void)startAction:(UIButton *)button {
    WeakObj(self)
    button.selected = !button.selected;
    if (button.selected) {
        self.isPauseByUser = NO;
        [_player play];
        self.playState = ZFPlayerStatePlaying;
        //播放时，3秒钟将状态栏等隐藏
        if (self.maskView.coverView.alpha == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    weakself.maskView.coverView.alpha = 0;
                    weakself.maskView.topImageView.alpha = 0;
                    weakself.maskView.bottomImageView.alpha = 0;
                }];
            });
        }
    } else {
        [_player pause];
        self.isPauseByUser = YES;
        self.playState = ZFPlayerStatePause;
        if (self.maskView.coverView.alpha == 0) {
            self.maskView.coverView.alpha = 1;
            self.maskView.topImageView.alpha = 1;
            self.maskView.bottomImageView.alpha = 1;
        }
    }
}
-(void)fullScreenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        self.frame = self.smallFrame;
    }else{
        self.frame = self.bigFrame;
    }
    [self interfaceOrientation:(sender.selected == YES)?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait];
}
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
#pragma mark - 监听设备旋转方向
- (void)onDeviceOrientationChange{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    [self transformScreenDirection:orientation];
}
//根据屏幕方向更改尺寸
-(void)transformScreenDirection:(UIDeviceOrientation)direction {
    if (direction == UIDeviceOrientationPortrait) {
        self.frame = self.smallFrame;
    }else if(direction == UIDeviceOrientationLandscapeRight || direction == UIDeviceOrientationLandscapeLeft){
        self.frame = self.bigFrame;
    }
}

#pragma mark - NSNotification Action
// 播放完了
- (void)moviePlayDidEnd:(NSNotification *)notification {
    WeakObj(self)
    [_player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finish){
        [weakself.maskView.videoSlider setValue:0.0 animated:YES];
        weakself.maskView.currentTimeLabel.text = @"00:00";
    }];
    self.playState = ZFPlayerStateStopped;
    self.maskView.startBtn.selected = NO;
}

// 应用退到后台
- (void)appDidEnterBackground {
    [_player pause];
    self.maskView.startBtn.selected = NO;
    self.playState = ZFPlayerStatePause;
    if (self.maskView.coverView.alpha == 0) {
        self.maskView.coverView.alpha = 1;
        self.maskView.topImageView.alpha = 1;
        self.maskView.bottomImageView.alpha = 1;
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.playerItme) {
        if ([keyPath isEqualToString:@"status"]) {
            if (self.player.status == AVPlayerStatusReadyToPlay) {
                self.playState = ZFPlayerStatePlaying;
            }else if (self.player.status == AVPlayerStatusFailed){
                [self.maskView.activity startAnimating];
            }
        }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
            CMTime duration             = self.playerItme.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            [self.maskView.progressView setProgress:timeInterval / totalDuration animated:NO];
            float total = CMTimeGetSeconds(self.playerItme.duration);
            //总秒数和分钟
            NSInteger durSec = (NSInteger)total%60;
            NSInteger durMin = (NSInteger)total/60;
            self.maskView.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
        }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            // 当缓冲是空的时候
            if (self.playerItme.playbackBufferEmpty) {
                self.playState = ZFPlayerStateBuffering;
                [self bufferingSomeSecond];
            }
            
        }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            // 当缓冲好的时候
            if (self.playerItme.playbackLikelyToKeepUp){
                self.playState = ZFPlayerStatePlaying;
            }
        }
    }
}
- (void)bufferingSomeSecond {
    [self.maskView.activity startAnimating];
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    static BOOL isBuffering = NO;
    if (isBuffering) {
        return;
    }
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    WeakObj(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (weakself.isPauseByUser) {
            isBuffering = NO;
            return;
        }
       
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        
        //播放缓冲区已满的时候 在播放否则继续缓冲
//         [self.player play];
       
        /** 是否缓冲好的标准 （系统默认是1分钟。不建议用 ）*/
        //self.playerItme.isPlaybackLikelyToKeepUp
        
        if ((weakself.maskView.progressView.progress - weakself.maskView.videoSlider.value) > 0.01) {
            weakself.playState = ZFPlayerStatePlaying;
            [weakself.player play];
        }else{
            [weakself bufferingSomeSecond];
        }
    });
}
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.playerLayer.frame = self.bounds;
    self.maskView.frame = self.bounds;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.playerItme removeObserver:self forKeyPath:@"status"];
    [self.playerItme removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItme removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItme removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
}

@end
