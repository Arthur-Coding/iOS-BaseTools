//
//  UIImage+mask.h
//
//  Created by ArthurShuai on 16/10/28.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (mask)
/**
 *  遮罩层, RGBA=(0, 0, 0, 0.6)
 *
 *  @param maskRect  遮罩层的Rect
 *  @param clearRect 镂空的Rect
 *
 *  @return 遮罩层图片
 */
+ (UIImage *)maskImageWithMaskRect:(CGRect)maskRect clearRect:(CGRect)clearRect;

@end
