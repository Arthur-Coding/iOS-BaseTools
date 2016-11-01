//
//  UIImage+mask.m
//
//  Created by ArthurShuai on 16/10/28.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "UIImage+mask.h"

@implementation UIImage (mask)

+ (UIImage *)maskImageWithMaskRect:(CGRect)maskRect clearRect:(CGRect)clearRect{
    UIGraphicsBeginImageContext(maskRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0,0,0,0.6);
    CGRect drawRect = maskRect;
    
    CGContextFillRect(ctx, drawRect);
    
    drawRect = clearRect;
    CGContextClearRect(ctx, drawRect);
    
    UIImage* returnimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnimage;
}

@end
