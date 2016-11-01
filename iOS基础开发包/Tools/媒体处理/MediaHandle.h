//
//  MediaHandle.h
//
//  Created by ArthurShuai on 16/10/30.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//
//  系统名称：媒体处理
//  功能描述：1.支持从相册读取图片、从相册读取视频、调用相机拍摄图片、调用相机拍摄视频等；
//          2.需在Info.plist文件中添加NSCameraUsageDescription和NSPhotoLibraryUsageDescription；

#import <Foundation/Foundation.h>

@protocol MeidaHandleDelegate <NSObject>

@required

/**
 结果处理

 @param result 图片或者视频url
 */
- (void)mediaHandleResult:(id)result;

@optional


/**
 设备是否支持相机（摄像头）

 @param isSupport YES or NO
 */
- (void)isSupportCamera:(BOOL)isSupport;

@end

typedef NS_ENUM(NSUInteger, kMediaHandleType) {
    kMediaHandleTypePhoto = 0, //读取图片
    KMediaHandleTypeVideo = 1, //读取视频
    kMediaHandleTypePhotograph = 2, //拍照
    kMediaHandleTypeShootVideo = 3, //拍摄视频
    kMediaHandleTypePhotographAndShootVideo = 4, //拍照和拍摄视频
};

@interface MediaHandle : NSObject

@property (nonatomic)id<MeidaHandleDelegate> delegate;

/**
 以下两个属性，只在支持拍摄视频功能时设置
 */
@property (nonatomic)UIImagePickerControllerQualityType qualityType;//视频拍摄质量，默认为中等
@property (nonatomic)NSTimeInterval videoMaximumDuration;//视频拍摄最大时长，默认为10分钟

- (instancetype)initWithType:(kMediaHandleType)type;
+ (instancetype)mediaWithType:(kMediaHandleType)type;

@end
