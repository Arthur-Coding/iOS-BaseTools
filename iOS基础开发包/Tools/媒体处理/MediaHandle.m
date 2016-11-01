//
//  MediaHandle.m
//
//  Created by ArthurShuai on 16/10/30.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "MediaHandle.h"

@interface MediaHandle ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong)UIImagePickerController *picker;
@property (nonatomic)kMediaHandleType type;

@end
@implementation MediaHandle
- (void)setDelegate:(id<MeidaHandleDelegate>)delegate{
    _delegate = delegate;
    if ([delegate isKindOfClass:[UIViewController class]]) {
        [(UIViewController *)delegate presentViewController:_picker animated:YES completion:nil];
    }
}
- (void)setQualityType:(UIImagePickerControllerQualityType)qualityType{
    _qualityType = qualityType;
    _picker.videoQuality = qualityType;
}
- (void)setVideoMaximumDuration:(NSTimeInterval)videoMaximumDuration{
    _videoMaximumDuration = videoMaximumDuration;
    _picker.videoMaximumDuration = videoMaximumDuration;
}
- (instancetype)initWithType:(kMediaHandleType)type{
    if (self = [super init]) {
        _type = type;
        _picker = [[UIImagePickerController alloc] init];
        _picker.allowsEditing = YES;
        _picker.delegate = self;
        if (type == kMediaHandleTypePhoto) {
            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else if (type == KMediaHandleTypeVideo){
            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _picker.mediaTypes = @[@"public.movie"];
        }else{
            //判断相机是否可用
            //[UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear]判断后置摄像头是否可用
            //[UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceFront]判断前置摄像头是否可用
            if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
                [self.delegate isSupportCamera:NO];
                return nil;
            }else{
                [self.delegate isSupportCamera:YES];
            }
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            if (type == kMediaHandleTypePhotograph) {
                _picker.mediaTypes = @[@"public.image"];
            }else if (type == kMediaHandleTypeShootVideo){
                _picker.mediaTypes = @[@"public.movie"];
            }else{
                _picker.mediaTypes = @[@"public.image",@"public.movie"];
            }
        }
    }
    return self;
}
+ (instancetype)mediaWithType:(kMediaHandleType)type{
    return [[MediaHandle alloc] initWithType:type];
}
#pragma mark - imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    WeakObj(self)
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *editImg = info[UIImagePickerControllerEditedImage];
        if (_type == kMediaHandleTypePhotograph) {
            UIImageWriteToSavedPhotosAlbum(editImg, nil, nil, nil);
        }
        [picker dismissViewControllerAnimated:YES completion:^{
            if ([weakself.delegate respondsToSelector:@selector(mediaHandleResult:)]) {
                [weakself.delegate mediaHandleResult:editImg];
            }
        }];
    }else {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        if (_type == kMediaHandleTypeShootVideo || _type == kMediaHandleTypePhotographAndShootVideo) {
            UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, self, nil, nil);
        }
        [picker dismissViewControllerAnimated:YES completion:^{
            if ([weakself.delegate respondsToSelector:@selector(mediaHandleResult:)]) {
                [weakself.delegate mediaHandleResult:videoURL];
            }
        }];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
