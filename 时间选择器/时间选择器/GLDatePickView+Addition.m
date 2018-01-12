//
//  GLDatePickView+Addition.m
//  时间选择器
//
//  Created by lang on 2017/10/18.
//  Copyright © 2017年 lang. All rights reserved.
//

#import "GLDatePickView+Addition.h"

@implementation GLDatePickView (Addition)

//获取视图所对应的控制器 -- 下一个相应者
- (UIViewController *)nextCtrl
{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        } else {
            next = [next nextResponder];
        }
    } while (next != nil);
    
    return nil;
}

@end
