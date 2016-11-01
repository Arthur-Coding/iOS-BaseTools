//
//  ScanningViewController.m
//
//  Created by ArthurShuai on 16/10/28.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "ScanningViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIImage+mask.h"

#define kScanViewWidth 0.8*kScreenW
#define kScanViewHeight kScanViewWidth

@interface ScanningViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong)AVCaptureSession *session;

@end

@implementation ScanningViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatBackGroundView];
    UIImageView *scanView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenW-kScanViewWidth)/2,(kScreenH-kScanViewHeight)/2,kScanViewWidth,kScanViewHeight)];
    scanView.image = [UIImage imageNamed:@"scanscanBg"];
    [self.view addSubview:scanView];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenW-kScanViewWidth)/2, (kScreenH-kScanViewHeight)/2, kScanViewWidth,5)];
    line.tag = 100;
    line.image = [UIImage imageNamed:@"scanLine@3x.png"];
    [self.view addSubview:line];
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
        line.frame = CGRectMake((kScreenW-kScanViewWidth)/2, (kScreenH+kScanViewHeight)/2-5, kScanViewWidth,5);
    } completion:nil];
    
    [self setupCamera];
}
/**
 背景遮罩
 */
- (void)creatBackGroundView{
    UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    maskView.image = [UIImage maskImageWithMaskRect:maskView.frame clearRect:CGRectMake((kScreenW-kScanViewWidth)/2, (kScreenH-kScanViewHeight)/2, kScanViewWidth, kScanViewHeight)];
    [self.view addSubview:maskView];
}
/**
 设置相机
 */
- (void)setupCamera{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    output.rectOfInterest = [self rectOfInterestByScanViewRect:CGRectMake((kScreenW-kScanViewWidth)/2,(kScreenH-kScanViewHeight)/2,kScanViewWidth,kScanViewHeight)];
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:input]){
        [_session addInput:input];
    }
    if ([_session canAddOutput:output]){
        [_session addOutput:output];
    }
    //条形码/二维码
    output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code,
                                   AVMetadataObjectTypeQRCode];
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame = self.view.bounds;
    [self.view.layer insertSublayer:preview atIndex:0];
    // Start
    [_session startRunning];
}
- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat x = (height - CGRectGetHeight(rect)) / 2 / height;
    CGFloat y = (width - CGRectGetWidth(rect)) / 2 / width;
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
    return CGRectMake(x, y, w, h);
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *result = nil;
    if (metadataObjects.count >0){
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        result = metadataObject.stringValue;
        AudioServicesPlaySystemSound(1009);
        [[self.view viewWithTag:100].layer removeAllAnimations];
        [[self.view viewWithTag:100] removeFromSuperview];
        if (_scanResultBlk) {
            _scanResultBlk(result);
        }
        //如果是网址，跳转
        if ([result hasPrefix:@"https://"] || [result hasPrefix:@"http://"]) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:result]];
        }
    }
    [_session stopRunning];
}

@end
