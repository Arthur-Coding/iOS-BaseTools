//
//  EmailSegue.m
//  Cate
//
//  Created by ArthurShuai on 16/7/30.
//  Copyright © 2016年 qusu. All rights reserved.
//

#import "EmailSegue.h"

@interface EmailSegue ()

@end
@implementation EmailSegue

- (void)perform{
    NSString *email = [self.sourceViewController valueForKeyPath:@"emailText.text"];
    if (email.length == 0) {
        
    }else{
        
    }
}

@end
