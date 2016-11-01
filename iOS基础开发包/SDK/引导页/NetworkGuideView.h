//
//  NetworkGuideView.h
//
//  Created by ArthurShuai on 16/4/14.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//
//  系统名称：加载网络图片引导页
//  功能描述：1.支持加载网络图片实现引导页
//          2.必须确保工程中添加的有SDWebImage第三方库(或用 cocoaPods 添加),也建议添加SDWebImage第三方库,可以优化因加载网络图片造成的界面卡顿与延迟等问题
//          3.reloadData 刷新数据的方法,可以刷新引导页中数据

#import <UIKit/UIKit.h>

@interface NetworkGuideView : UIScrollView

/**
 传递当前显示的图片的索引
 */
@property (nonatomic,copy)void(^pageIndexBlk)(NSInteger pageIndex);

/**
 初始化方法

 @param frame     frame
 @param imgArr    图片链接地址数组
 @param imageName 占位图

 @return 实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                          and:(NSArray *)imgArr
          andPlaceholderImage:(NSString *)imageName;


/**
 开启自动轮播

 @param timeInterval 切换时间
 */
- (void)openCarouselWithTimeInterval:(NSInteger)timeInterval;

/**
 刷新方法
 */
- (void)reloadData;

@end
