//
//  Public.h
//
//  Created by ArthurShuai on 16/10/26.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//
//  文档名称：基础开发公共头文件
//  文档说明：1.文档中头文件对应文档的修改，请于对应文档内修改；
//          2.个别变量、常数等定义可直接于此文档中添加，如百度地图appid:#define kMapAppId @"123456"
//          3.变量、常数等定义必须按照开发规范

#ifndef Public_h
#define Public_h

#define APPID @""//应用APPID
#define OLDVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]//当前应用版本

#define WeakObj(obj) __weak typeof(obj) weak##obj = obj;//弱引用对象
#define kWeakSelf __weak typeof(self) weakSelf = self;
#define StrongObj(obj) __strong typeof(obj) weak##obj = obj;//强引用对象
#define kStrongSelf __strong typeof(self) strongSelf = self;

#import "AppDelegate.h"
#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)//应用代理对象

/**********************************
 *  获取设置信息
 *  屏幕尺寸：iPhone 7 Plus  414*736
            iPhone 7       375*667
            iPhone 6S Plus 414*736
            iPhone 6S      375*667
            iPhone 6 Plus  414*736
            iPhone 6       375*667
            iPhone SE      320*568
            iPhone 5S      320*568
            iPhone 5       320*568
 **********************************/
#define kScreenW ([UIScreen mainScreen].bounds.size.width)//屏幕宽度
#define kScreenH ([UIScreen mainScreen].bounds.size.height)//屏幕高度
#define kScreen_RESOLUTION (kScreenW * kScreenH * [UIScreen mainScreen].scale)//屏幕分辨率
#define kDevice (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone")//判断当前设备是iPod或iPhone
#define SYSTEM_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])//当前系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device do something
#endif
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator do something
#endif

/**********************************
 *  打印日志
 *  DEBUG 模式下打印日志与当前行
 **********************************/
#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...)
#endif


#endif /* Public_h */
