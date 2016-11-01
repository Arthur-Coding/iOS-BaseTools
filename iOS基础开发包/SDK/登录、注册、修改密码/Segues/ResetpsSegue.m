//
//  ResetpsSegue.m
//  Cate
//
//  Created by ArthurShuai on 16/7/30.
//  Copyright © 2016年 qusu. All rights reserved.
//

#import "ResetpsSegue.h"

@interface ResetpsSegue ()

@end
@implementation ResetpsSegue

- (void)perform{
    NSString *authCode = [self.sourceViewController valueForKeyPath:@"vfCodeText.text"];
    if (authCode.length == 0) {
        
    }else{
        
    }
}

@end
