//
//  ViewController.m
//  时间选择器
//
//  Created by lang on 2017/10/18.
//  Copyright © 2017年 lang. All rights reserved.
//

#import "ViewController.h"
#import "GLDatePickView.h"
#import "LQMenuView.h"

@interface ViewController () <GLDatePickerViewDelegate,LQMenuViewDelegate, UIScrollViewDelegate>
{
    GLDatePickView *dateView;
}
//@property (weak, nonatomic) GLDatePickView *dateView;
@property (strong, nonatomic) UIButton *btn;

@property (nonatomic, strong) LQMenuView *menuView;
@property (nonatomic, assign) NSInteger selectIndex;
@end


#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupUI];
    
    [self setDatePickUI];
}


- (void)setDatePickUI{
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    self.btn.backgroundColor = [UIColor blueColor];
    //    self.btn.hidden = YES;
    [self.btn setTitle:@"时间选择器" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(timerBrnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.btn.alpha = 0.3;
    [self.view addSubview:self.btn];
    
    
//    GLDatePickView *dateView = [[GLDatePickView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300)];
    dateView = [[GLDatePickView alloc] init];
    dateView.delegate = self;
    dateView.title = @"请选择时间";
//    [self.view addSubview:dateView];
//    dateView = dateView;
}

// 显示
- (IBAction)timerBrnClick:(id)sender {
   
//    [UIView animateWithDuration:0.3 animations:^{
//        self.dateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
        [dateView show];
//    }];
}

#pragma mark - THDatePickerViewDelegate
/**
 
 @param timer 选择的数据
 */
- (void)datePickViewSaveBtnClickDelegate:(NSString *)timer {
    NSLog(@"选取的时间为：%@",timer);
}

/**
 取消按钮代理方法
 */
- (void)datePickViewCancelBtnClickDelegate {
    NSLog(@"取消点击");
}



- (void)setupUI {
    
    NSArray *orderItems = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价",@"待领取",@"已完成",@"已领完",@"有退款"];
    _menuView = [[LQMenuView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 40) buttonItems:orderItems];
    _menuView.delegate = self;
    _menuView.titleFont = [UIFont systemFontOfSize:15.f];
    _menuView.titleColor = [UIColor grayColor];
    _menuView.selectTitleFont = [UIFont systemFontOfSize:15.f];
    _menuView.selectTitleColor = [UIColor blueColor];
    _menuView.separatorColor = [UIColor greenColor];
    _menuView.imageNormalArray = @[@"tabbar_authentication_normal", @"tabbar_loan_normal", @"tabbar_mine_normal", @"tabbar_repay", @"tabbar_jishi", @"tabbar_saichang", @"tabbar_shequ", @"tabbar_shiping", @"tabbar_shouye"];
    _menuView.imageSelectArray = @[@"tabbar_authentication_selected", @"tabbar_loan_selected", @"tabbar_mine_selected", @"tabbar_repaycheck", @"tabbar_jishi_td", @"tabbar_saichang_td", @"tabbar_shequ_td", @"tabbar_shiping_td",@"tabbar_shouye_td"];
    [_menuView changeButtonStateAtIndex:0];
    //    [_menuView hideLineImageView];
    [self.view addSubview:_menuView];
}


#pragma mark -
#pragma mark - LQMenuViewDelegate

- (void)menuClickedButtonAtIndex:(NSInteger)aIndex {
    if (_selectIndex != aIndex) {
        _selectIndex = aIndex;
        [self selectItem:aIndex];
    }
}

- (void)selectItem:(NSInteger)aIndex {
    
    
    [_menuView changeColor:randomColor];
    //do something
    NSLog(@"do something---%ld", (long)aIndex);
}



@end
