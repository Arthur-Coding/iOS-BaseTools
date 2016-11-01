//
//  NextStepSegue.m
//  Cate
//
//  Created by qusu on 16/7/30.
//  Copyright © 2016年 qusu. All rights reserved.
//

#import "NextStepSegue.h"

@interface NextStepSegue ()

@end
@implementation NextStepSegue

- (void)perform{
    UITextField *usernameText = [self.sourceViewController valueForKey:@"usernameText"];
    UITextField *passwordText = [self.sourceViewController valueForKey:@"passwordText"];
    if (usernameText.text.length < 6) {
        
    }else if (passwordText.text.length < 6){
        
    }else{
        [self.sourceViewController showViewController:self.destinationViewController sender:self];
    }
}

@end
