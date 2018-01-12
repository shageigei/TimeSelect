//
//  LQMenuView.m
//  LQMenuView
//
//  Created by Leo on 2017/10/17.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "LQMenuView.h"

@interface UIImage (LQImageHelper)
    
+ (UIImage *)imageWithColor:(UIColor *)color;

@end

@implementation UIImage (LQImageHelper)

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@interface UIColor (LQColorHelper)

+ (UIColor *)colorWithHexString:(NSString *)color;

@end

@implementation UIColor (LQColorHelper)

+ (UIColor *)colorWithHexString:(NSString *)color {
    
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end

//RGB颜色值 两种参数
#define RGB(r,g,b)   [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:1]
//#define kMenuRed RGB(245, 182, 23)
#define kMenuRed     [UIColor redColor]
#define kMenuBlack   [UIColor colorWithHexString:@"#666666"]
#define kDevideGray  [UIColor colorWithHexString:@"#dddddd"]//分割线灰色
//设备高度
#define DEVICE_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//设备宽度
#define DEVICE_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface LQMenuView () {
    
    UIScrollView    *myScrollView;
    
    NSMutableArray  *mButtonArray;
    UIImageView     *signLineImgView;
    CGRect          rect;
    BOOL            isNav;//区分是否是加在导航控制器
}
@end

@implementation LQMenuView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        rect = frame;
        if (mButtonArray == nil) {
            mButtonArray = [NSMutableArray array];
        }
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (id)initLineStyleWithFrame:(CGRect)frame {
    
    self = [self initWithFrame:frame];
    if (self) {
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
        line.image = [UIImage imageWithColor:kDevideGray];
        [self addSubview:line];
    }
    return self;
}

- (id)initNoLineStyleWithFrame:(CGRect)frame {
    
    self = [self initWithFrame:frame];
    if (self) {
        
        rect = frame;
        if (mButtonArray == nil) {
            mButtonArray = [NSMutableArray array];
        }
        
        self.backgroundColor = [UIColor whiteColor];
        _selectionStyle = LQMenuViewSelectionStyleRed;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame buttonItems:(NSArray *)aItemsArray {
    
    self = [self initWithFrame:frame];
    if (self) {
        UIImageView *lineTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        lineTop.image = [UIImage imageWithColor:kDevideGray];
        [self addSubview:lineTop];
        UIImageView *lineBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
        lineBottom.image = [UIImage imageWithColor:kDevideGray];
        [self addSubview:lineBottom];
        [self createMenuItems:aItemsArray];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame isNav:(BOOL)isNav {
    
    self = [self initWithFrame:frame];
    if (self) {
        isNav = isNav;
    }
    
    return self;
}

- (void)createMenuItems:(NSArray *)aItemsArray {
    
    if (mButtonArray == nil) {
        mButtonArray = [NSMutableArray array];
    }
    
    _maxNum = MAX(4, _maxNum);
    if (aItemsArray.count <= _maxNum) {
        int i = 0;
        for (NSString *title in aItemsArray) {
            
            float buttonWidth = (rect.size.width > 0 ? rect.size.width : _width) / aItemsArray.count;
            if (self.itemWidth) {
                buttonWidth = self.itemWidth;
            }
            UIButton *vButton = [self itemForMenuWithIndex:i withWidth:buttonWidth];
            [vButton setTitle:title forState:UIControlStateNormal];
            [self addSubview:vButton];
            [mButtonArray addObject:vButton];
            
            if (i != aItemsArray.count - 1) {
                UILabel *separatorLineLB = [self separatorLineBetweenItemWithIndex:i Width:buttonWidth];
                [self addSubview:separatorLineLB];
            }
            i++;
        }
        signLineImgView = [self signLineWithWidth:((rect.size.width > 0 ? rect.size.width : _width) / aItemsArray.count - 30)];
        [self addSubview:signLineImgView];
    } else {
        myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, (rect.size.width > 0 ? rect.size.width : _width), self.frame.size.height)];
        
        float buttonWidth = (rect.size.width > 0 ? rect.size.width : _width) / _maxNum;
        
        if (self.itemWidth) {
            buttonWidth = self.itemWidth;
        }
        myScrollView.contentSize = CGSizeMake(buttonWidth * aItemsArray.count, self.frame.size.height);
        myScrollView.showsVerticalScrollIndicator = NO;
        myScrollView.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i < aItemsArray.count; i++) {
            
            NSString *title = [aItemsArray objectAtIndex:i];
            UIButton *vButton = [self itemForMenuWithIndex:i withWidth:buttonWidth];
            [vButton setTitle:title forState:UIControlStateNormal];
            [myScrollView addSubview:vButton];
            [mButtonArray addObject:vButton];
            
            if (i != aItemsArray.count - 1) {
                UILabel *separatorLineLB = [self separatorLineBetweenItemWithIndex:i Width:buttonWidth];
                [myScrollView addSubview:separatorLineLB];
            }
        }
        signLineImgView = [self signLineWithWidth:(buttonWidth - 30)];
        [myScrollView addSubview:signLineImgView];
        [self addSubview:myScrollView];
    }
}

- (UIButton *)itemForMenuWithIndex:(NSInteger)aIndex withWidth:(CGFloat)width{
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    [item setFrame:CGRectMake(width * aIndex, 0, width, self.frame.size.height)];
    [item.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [item setTitleColor:kMenuBlack forState:UIControlStateNormal];
    if (_titleFont) {
        [item.titleLabel setFont:_titleFont];
    }
    if (_titleColor) {
        [item setTitleColor:_titleColor forState:UIControlStateNormal];
    }
    if (_imageNormalArray.count) {
        [item setImage:[UIImage imageNamed:[_imageNormalArray objectAtIndex:aIndex]] forState:UIControlStateNormal];
    }
    item.tag = aIndex;
    [item addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return item;
}

- (UILabel *)separatorLineBetweenItemWithIndex:(NSInteger)aIndex Width:(float)width {
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(width * (aIndex + 1), 10, 0.5, self.frame.size.height - 20)];
    if (_separatorSize.height > 0) {
        line.frame = CGRectMake(width * aIndex + width, (self.frame.size.height-_separatorSize.height)/2, _separatorSize.width, _separatorSize.height);
    }
    if (_verticalBarColor) {
        line.backgroundColor = _verticalBarColor;
    } else {
        line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    }
    
    [self.lineLableArray addObject:line];
    
    return line;
}

- (UIImageView *)signLineWithWidth:(CGFloat)width {
    UIColor *lineColor = kMenuRed;
    if (_separatorColor) {
        lineColor = _separatorColor;
    }
    UIImageView *signImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.frame.size.height - 0.6, width, 2)];
    signImgView.image = [UIImage imageWithColor:lineColor];
    return signImgView;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    signLineImgView.image = [UIImage imageWithColor:separatorColor];
}

/**
 取消所有button的点击状态
 */
- (void)changeButtonsToNormalState {
    
    for (int i = 0; i < mButtonArray.count; i++) {
        UIButton *button = [mButtonArray objectAtIndex:i];
        [button setTitleColor:kMenuBlack forState:UIControlStateNormal];
        if (_titleColor) {
            [button setTitleColor:_titleColor forState:UIControlStateNormal];
        }
        if (_imageNormalArray.count) {
            [button setImage:[UIImage imageNamed:[_imageNormalArray objectAtIndex:i]] forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        }
    }
}

- (void)clickButtonAtIndex:(NSInteger)aIndex {
    UIButton *button = [mButtonArray objectAtIndex:aIndex];
    [self menuButtonClicked:button];
}

- (void)changeButtonStateAtIndex:(NSInteger)aIndex {
    
    UIButton *vbutton = [mButtonArray objectAtIndex:aIndex];
    [self changeButtonsToNormalState];
    
    [vbutton setTitleColor:kMenuRed forState:UIControlStateNormal];
    
    if (self.selectTitleColor && self.selectTitleFont ) {
        
        for (UIButton *button in mButtonArray) {
            if (button == vbutton) {
                [vbutton setTitleColor:self.selectTitleColor forState:UIControlStateNormal];
                [vbutton.titleLabel setFont:self.selectTitleFont];
                if (_imageSelectArray.count > 0) {
                   [vbutton setImage:[UIImage imageNamed:[_imageSelectArray objectAtIndex:aIndex]] forState:UIControlStateNormal];
                }
                
            } else {
                [button setTitleColor:self.titleColor forState:UIControlStateNormal];
                [button.titleLabel setFont:self.titleFont];
            }
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rects = signLineImgView.frame;
        
        rects.size.width = [self widthForText:vbutton.currentTitle font:vbutton.titleLabel.font maxHeight:rects.size.height];
        rects.size.width = MIN(rects.size.width, vbutton.frame.size.width);
        signLineImgView.frame = rects;
        signLineImgView.center = CGPointMake(vbutton.center.x, self.frame.size.height - 1);
    }];
    
    //计算偏移量
    CGFloat offsetX = vbutton.center.x - DEVICE_WIDTH * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    //获取最大滚动范围
    CGFloat maxOffsetX = myScrollView.contentSize.width - DEVICE_WIDTH;
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    //滚动标题滚动条
    [myScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (CGFloat)widthForText:(NSString *)text
                   font:(UIFont *)font
              maxHeight:(CGFloat)maxHeight
{
    
    CGRect stringRect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,maxHeight)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{ NSFontAttributeName : font }
                                           context:nil];
    CGSize textSize = CGRectIntegral(stringRect).size;
    
    return textSize.width;
}

- (void)hideLineImageView {
    signLineImgView.hidden = YES;
}

- (void)changeButtonName:(NSArray *)titleArray {
    
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [mButtonArray objectAtIndex:i];
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
    }
}

- (void)menuButtonClicked:(UIButton *)aButton {
    if (_selectionStyle == LQMenuViewSelectionStyleRed) {
        [self changeButtonStateAtIndex:aButton.tag];
    }
    id <LQMenuViewDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(menuClickedButtonAtIndex:)]) {
        [delegate menuClickedButtonAtIndex:aButton.tag];
    }
    if ([delegate respondsToSelector:@selector(menuClickedButtonAtIndex:menuView:)]) {
        [delegate menuClickedButtonAtIndex:aButton.tag menuView:self];
    }
}

- (void)changeColor:(UIColor *)color{
    
    for (UILabel *line in self.lineLableArray) {
        line.backgroundColor = color;
    }
}

- (void)dealloc {
    
    [mButtonArray removeAllObjects];
    mButtonArray = nil;
    
}

- (NSMutableArray *)lineLableArray{
    if (_lineLableArray == nil) {
        _lineLableArray = [NSMutableArray new];
    }
    return _lineLableArray;
}

@end
