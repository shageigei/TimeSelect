//
//  GLDatePickView.h
//  时间选择器
//
//  Created by lang on 2017/10/18.
//  Copyright © 2017年 lang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLDatePickerViewDelegate <NSObject>

/**
 *  保存按钮代理方法
 *  @param timer 选择的数据
 */

- (void)datePickViewSaveBtnClickDelegate:(NSString *)timer;

/**
 *  取消按钮代理方法
 *
 */
- (void)datePickViewCancelBtnClickDelegate;

@end

@interface GLDatePickView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) id<GLDatePickerViewDelegate>delegate;


//显示
- (void)show;


@end
