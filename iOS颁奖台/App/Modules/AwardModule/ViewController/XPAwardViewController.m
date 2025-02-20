//
//  XPAwardViewController.m
//  XPApp
//
//  Created by xinpinghuang on 12/31/15.
//  Copyright 2015 ShareMerge. All rights reserved.
//

#import "XPAwardViewController.h"
#import <XPKit/XPKit.h>
#import <XPViewPager/XPViewPager.h>
#import <MJRefresh/MJRefresh.h>
#import <XPShouldPop/UINavigationController+XPShouldPop.h>
@interface XPAwardViewController ()<UINavigationControllerShouldPop>

@property (nonatomic, strong) XPViewPager *viewPager;

@property (nonatomic, strong)UITableViewController* get;


@end

@implementation XPAwardViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.viewPager];
    [self.viewPager didSelectedBlock:^(XPViewPager *viewPager, NSInteger index) {
//        XPViewPager
//        UITableViewController* tabViewController=
//        [tabViewController.tableView.mj_header beginRefreshing ];
    }];
}
//-(void)viewDidAppear:(BOOL)animated{
//    for(UITableViewController* tableViewController in )
//}
#pragma mark - Delegate

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Public Interface

#pragma mark - Getter & Setter
- (XPViewPager *)viewPager
{
    if(_viewPager == nil) {
        UIViewController *get = [self instantiateViewControllerWithStoryboardName:@"Award" identifier:@"Get"];
        self.get=get;
        UIViewController *receive = [self instantiateViewControllerWithStoryboardName:@"Award" identifier:@"Receive"];
        UIViewController *use = [self instantiateViewControllerWithStoryboardName:@"Award" identifier:@"Use"];
        _viewPager = [[XPViewPager alloc] initWithFrame:ccr(0, 20+44+35, self.view.width, self.view.height-20-44-35) titles:@[@"待领取", @"待收货", @"待使用",@"待使用",@"待使用"] icons:nil selectedIcons:nil views:@[get, receive, use,use,use]];
        _viewPager.showVLine = NO;
        _viewPager.tabTitleColor = [UIColor blackColor];
        _viewPager.tabSelectedTitleColor = [UIColor colorWithRed:0.627 green:0.176 blue:0.169 alpha:1.000];
        _viewPager.tabSelectedArrowBgColor = [UIColor colorWithRed:0.784 green:0.259 blue:0.251 alpha:1.000];
        _viewPager.tabArrowBgColor = [UIColor colorWithWhite:0.929 alpha:1.000];
        
    }
    return _viewPager;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.get.tableView.mj_header beginRefreshing];
}
#pragma mark - Delegate
- (BOOL)navigationControllerShouldPop:(UINavigationController *)navigationController
{
    if(!self.isAutomaticShake) {
        return YES;
    }
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self popToRoot];
    });
    return NO;
}

- (BOOL)navigationControllerShouldStartInteractivePopGestureRecognizer:(UINavigationController *)navigationController
{
    if(!self.isAutomaticShake) {
        return YES;
    }
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self popToRoot];
    });
    return NO;
}
@end
