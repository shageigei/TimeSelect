//
//  LQMenuView.h
//  LQMenuView
//
//  Created by Leo on 2017/10/17.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LQMenuViewSelectionStyle) {
    
    LQMenuViewSelectionStyleRed = 0,
    LQMenuViewSelectionStyleNone
};

/**
 多列表切换菜单栏
 */
@class LQMenuView;

@protocol LQMenuViewDelegate <NSObject>

@optional

- (void)menuClickedButtonAtIndex:(NSInteger)aIndex;
- (void)menuClickedButtonAtIndex:(NSInteger)aIndex menuView:(UIView *)mView;

@end


@interface LQMenuView : UIView

@property (nonatomic, weak) id <LQMenuViewDelegate> delegate;

@property (nonatomic, strong) UIFont                     *titleFont;
@property (nonatomic, strong) UIFont                     *selectTitleFont;
@property (nonatomic, strong) UIColor                    *titleColor;
@property (nonatomic, strong) UIColor                    *selectTitleColor;
@property (nonatomic, strong) NSArray                    *imageNormalArray;
@property (nonatomic, strong) NSArray                    *imageSelectArray;
@property (nonatomic, strong) UIColor                    *verticalBarColor;
@property (nonatomic, strong) UIColor                    *separatorColor;
@property (nonatomic, assign) CGSize                     separatorSize;
@property (nonatomic, assign) float                      width;
@property (nonatomic, assign) CGFloat                    itemWidth;
@property (nonatomic, assign) NSInteger                  maxNum;
@property (nonatomic, assign) LQMenuViewSelectionStyle   selectionStyle;

@property (nonatomic, strong) NSMutableArray             *lineLableArray;
- (void)changeColor:(UIColor *)color;

/**
 初始化菜单
 */
- (id)initLineStyleWithFrame:(CGRect)frame;
- (id)initNoLineStyleWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame buttonItems:(NSArray *)aItemsArray;
- (id)initWithFrame:(CGRect)frame isNav:(BOOL)isNav;
- (void)createMenuItems:(NSArray *)aItemsArray;

/**
 选中某个button
 */
- (void)clickButtonAtIndex:(NSInteger)aIndex;

/**
 改变第几个button为选中状态，不发送delegate
 */
- (void)changeButtonStateAtIndex:(NSInteger)aIndex;

/**
 隐藏下划线
 */
- (void)hideLineImageView;

/**
 改变按钮名称
 */
- (void)changeButtonName:(NSArray *)titleArray;

@end
