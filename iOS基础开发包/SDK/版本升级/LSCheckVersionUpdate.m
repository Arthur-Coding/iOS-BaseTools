//
//  LSCheckVersionUpdate.h
//
//  Created by ArthurShuai on 16/10/31.
//  Copyright © 2016年 ArthurShuai. All rights reserved.
//

#import "LSCheckVersionUpdate.h"
#import "LSVersionUpdateVIew.h"

typedef void(^UpdateBlock)(NSString *str, NSArray *DataArr);

@interface LSCheckVersionUpdate ()

@property (nonatomic, copy)UpdateBlock updateBlock;

@end
@implementation LSCheckVersionUpdate{
    LSVersionUpdateVIew *_versionUpdateView;
}

- (void)CheckVerion:(UpdateBlock)updateblock{
    NSArray *dataArr = [LSCheckVersionUpdate separateToRow:_descriptions];
    if (updateblock) {
        updateblock(_version,dataArr);
    }
}

//+ (BOOL)versionlessthan:(NSString *)newver{
//    if ([OLDVERSION isEqualToString:newver]) {
//        return YES;
//    }else{
//        if ([OLDVERSION compare:newver options:NSNumericSearch] == NSOrderedDescending){
//            return YES;
//        }else{
//            return NO;
//        }
//    }
//    return NO;
//}

+ (NSArray *)separateToRow:(NSString *)describe{
    NSArray *array= [describe componentsSeparatedByString:@"\n"];
    return array;
}

- (void)showAlertView{
    WeakObj(self)
    [self CheckVerion:^(NSString *str, NSArray *DataArr) {
        if (!_versionUpdateView) {
            _versionUpdateView = [[LSVersionUpdateVIew alloc] initWith:[NSString stringWithFormat:@"版本:%@",str] Describe:DataArr];
            _versionUpdateView.GoTOAppstoreBlock = ^{
                [weakself goToAppStore];
            };
            _versionUpdateView.removeUpdateViewBlock = ^{
                [weakself removeVersionUpdateView];
            };
        }
    }];
}
- (void)goToAppStore{
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/%@",APPID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}
- (void)removeVersionUpdateView{
    [_versionUpdateView removeFromSuperview];
    _versionUpdateView = nil;
}

@end
