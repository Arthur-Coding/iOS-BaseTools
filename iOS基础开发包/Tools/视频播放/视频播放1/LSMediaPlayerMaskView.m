//
//  LSMediaPlayerMaskView.m
//
//  Created by ArthurShuai on 16/10/28.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "LSMediaPlayerMaskView.h"


@interface LSMediaPlayerMaskView ()

/** bottom渐变层*/
@property (nonatomic, strong)CAGradientLayer *bottomGradientLayer;
/** top渐变层 */
@property (nonatomic, strong)CAGradientLayer *topGradientLayer;

@end

@implementation LSMediaPlayerMaskView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.topImageView = [[UIImageView alloc]init];
        self.bottomImageView = [[UIImageView alloc]init];
        self.bottomImageView.userInteractionEnabled = YES;
        self.coverView = [[UIView alloc] init];
        self.coverView.backgroundColor = [UIColor clearColor];
        
        self.startBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,50,50)];
        [self.startBtn setImage:[UIImage imageNamed:@"kr-video-player-play"] forState:UIControlStateNormal];
        [self.startBtn setImage:[UIImage imageNamed:@"kr-video-player-pause"] forState:UIControlStateSelected];
        
        self.fullScreenBtn = [[UIButton alloc]init];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"kr-video-player-fullscreen"] forState:UIControlStateNormal];
        
        self.currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10,60, 30)];
        self.currentTimeLabel.text = @"00:00";
        self.currentTimeLabel.textColor = [UIColor whiteColor];
        self.currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.currentTimeLabel.font = [UIFont systemFontOfSize:15];
        self.totalTimeLabel = [[UILabel alloc]init];
        self.totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.totalTimeLabel.font = [UIFont systemFontOfSize:15];
        self.totalTimeLabel.textColor = [UIColor whiteColor];
        self.totalTimeLabel.text = @"00:00";
        
        self.progressView = [[UIProgressView alloc] init];
        self.progressView.progressTintColor = [UIColor whiteColor];
        self.progressView.trackTintColor = [UIColor lightTextColor];
        
        self.volumeProgress = [[UIProgressView alloc] init];
        self.volumeProgress.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.volumeProgress.progressTintColor = [UIColor whiteColor];
        self.volumeProgress.trackTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        
        // 设置slider
        self.videoSlider = [[UISlider alloc]init];
        [self.videoSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
        self.videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        self.videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
        
        [self addSubview:self.coverView];
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        // 初始化渐变层
        [self initCAGradientLayer];
        
        self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.bottomImageView addSubview:self.startBtn];
        [self.bottomImageView addSubview:self.fullScreenBtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        [self.bottomImageView addSubview:self.progressView];
        [self.bottomImageView addSubview:self.videoSlider];
        [self.coverView addSubview:self.volumeProgress];
        [self makeVolumeButton];
        
        [self addSubview:self.activity];
    
        NSError *error;
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    }
    return self;
}
//添加音量调节按钮
- (void)makeVolumeButton{
    UIButton *volumeUpBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [volumeUpBtn setImage:[UIImage imageNamed:@"voiceMax"] forState:UIControlStateNormal];
    [volumeUpBtn addTarget:self action:@selector(volume:) forControlEvents:UIControlEventTouchUpInside];
    volumeUpBtn.tag = 100;
    [self.coverView addSubview:volumeUpBtn];
    
    UIButton *volumeDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [volumeDownBtn setImage:[UIImage imageNamed:@"voiceMin"] forState:UIControlStateNormal];
    [volumeDownBtn addTarget:self action:@selector(volume:) forControlEvents:UIControlEventTouchUpInside];
    volumeDownBtn.tag = 101;
    [self.coverView addSubview:volumeDownBtn];
}
//音量btn事件
-(void)volume:(UIButton *)sender{
    [sender setShowsTouchWhenHighlighted:YES];//亮度
    CGFloat volume = 0;
    if (sender.tag == 100) {//加
        if (_volumeControlBlk) {
            volume = _volumeControlBlk(YES);
        }
    }else{//减
        if (_volumeControlBlk) {
            volume = _volumeControlBlk(NO);
        }
    }
    self.volumeProgress.progress = volume/2;
}
//手机音量按键调节音量
- (void)volumeChanged:(NSNotification *)notification {
    // service logic here.
    NSString *valueStr = notification.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"];
    self.volumeProgress.progress = [valueStr floatValue];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.coverView.frame = self.bounds;
    self.topImageView.frame = CGRectMake(0, 0,width, 50);
    self.bottomImageView.frame = CGRectMake(0,height-50, width, 50);
    self.bottomGradientLayer.frame = self.bottomImageView.bounds;
    self.topGradientLayer.frame    = self.topImageView.bounds;
    
    self.fullScreenBtn.frame = CGRectMake(width-50,0,50,50);
    
    CGFloat progressWidth = width-2*(self.startBtn.frame.size.width+self.currentTimeLabel.frame.size.width);
    
    self.progressView.frame = CGRectMake(0,0,progressWidth,20);
    self.progressView.center = CGPointMake(width/2, 25);
    self.totalTimeLabel.frame = CGRectMake(width-110,10,60,30);
    self.videoSlider.frame = self.progressView.frame;
    self.activity.center = CGPointMake(width/2, height/2);
    self.volumeProgress.bounds = CGRectMake(0, 0,100,30);
    self.volumeProgress.center = CGPointMake(40,height/2);
    [self.coverView viewWithTag:100].frame = CGRectMake(30, height/2-80, 20, 20);
    [self.coverView viewWithTag:101].frame = CGRectMake(32, height/2+60, 20, 20);
}

- (void)initCAGradientLayer {
    //初始化Bottom渐变层
    self.bottomGradientLayer            = [CAGradientLayer layer];
    [self.bottomImageView.layer addSublayer:self.bottomGradientLayer];
    //设置渐变颜色方向
    self.bottomGradientLayer.startPoint = CGPointMake(0, 0);
    self.bottomGradientLayer.endPoint   = CGPointMake(0, 1);
    //设定颜色组
    self.bottomGradientLayer.colors     = @[(__bridge id)[UIColor clearColor].CGColor,
                                            (__bridge id)[UIColor blackColor].CGColor];
    //设定颜色分割点
    self.bottomGradientLayer.locations  = @[@(0.0f) ,@(1.0f)];
    
    
    //初始Top化渐变层
    self.topGradientLayer               = [CAGradientLayer layer];
    [self.topImageView.layer addSublayer:self.topGradientLayer];
    //设置渐变颜色方向
    self.topGradientLayer.startPoint    = CGPointMake(1, 0);
    self.topGradientLayer.endPoint      = CGPointMake(1, 1);
    //设定颜色组
    self.topGradientLayer.colors        = @[ (__bridge id)[UIColor blackColor].CGColor,
                                             (__bridge id)[UIColor clearColor].CGColor];
    //设定颜色分割点
    self.topGradientLayer.locations     = @[@(0.0f) ,@(1.0f)];
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

@end
