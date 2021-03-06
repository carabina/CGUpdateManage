//
//  UpdateManage.m
//  Up
//
//  Created by bamq on 16/7/19.
//  Copyright © 2016年 bamq. All rights reserved.
//

#import "UpdateManage.h"
#define UPDATE_TAG 0xFF
@implementation UpdateManage
{
    UIAlertView *_alertView;
}
+(instancetype)manage{
    static UpdateManage *m;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[UpdateManage alloc] init];
    });
    return m;
}
-(instancetype)init{
    self =[super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAction:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}
-(void)updateAction:(UIApplication *)application{
    if ([_alertView isVisible]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UpdatePolicy update = self.updateBlock();
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (update) {
                case UpdatePolicyRequired:
                {
                    _alertView =[[UIAlertView alloc] initWithTitle:@"提示" message:@"发现新的版本，请更新！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    _alertView.tag = UPDATE_TAG;
                    _alertView.delegate =self;
                    [_alertView show];
                    
                }
                    break;
                case UpdatePolicyOptional:
                {
                    _alertView =[[UIAlertView alloc] initWithTitle:@"提示" message:@"发现新的版本，是否更新？" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消", nil];
                    _alertView.tag = UPDATE_TAG;
                    _alertView.delegate =self;
                    [_alertView show];
                }
                    break;
                case UpdatePolicyNone:
                    break;
                default:
                    break;
            }
        });
    });
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == UPDATE_TAG) {
        if (buttonIndex ==0) {
            [[UIApplication sharedApplication] openURL:self.url];
        }
    }
}

@end
