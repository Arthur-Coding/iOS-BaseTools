//
//  Configuration.h
//
//  Created by ArthurShuai on 16/10/26.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//
//  文件名称：操作配置文件

#ifndef Configuration_h
#define Configuration_h

//基础弹出提示框，obj为弹出对象，mes为提示信息
#define kAlert(obj,mes) \
    {\
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:mes preferredStyle:UIAlertControllerStyleAlert];\
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];\
        [alert addAction:action]; \
        [obj presentViewController:alert animated:YES completion:nil];\
    }

/**********************************
 *  加载图片
 *  type是png时,可以传入nil
 *  建议使用此方法，性能更高于[UIImage imageNamed:XXX]
 **********************************/
#define kLoadImage(imageName,type) ([UIImage imageWithContentsOfFile:[NSBundle mainBundle] pathForResource:imagename ofType:type == nil ? @"png" : type])

/**********************************
 *  颜色处理
 **********************************/
//rgb颜色转换（16进制->10进制）
#define kColorFromRGBValue(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0f])
#define kColorFromRGBValueAndAlpha(rgbValue,alpha) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha])
//带有RGBA的颜色
#define kColor(R, G, B, A) ([UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A])
#define kColorRGB(R,G,B) ([UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0f])

/**********************************
 *  语言
 **********************************/
#define kCurrentLanguage ([NSLocale preferredLanguages].firstObject)//当前系统语言

/**********************************
 *  自定义字体，不使用系统字体
 **********************************/
#define kFont(fontName,size) ([UIFont fontWithName:fontName size:size])

#endif /* Configuration_h */
