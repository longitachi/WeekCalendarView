//
//  ViewController.m
//  CalendarView
//
//  Created by long on 16/5/10.
//  Copyright © 2016年 long. All rights reserved.
//

#import "ViewController.h"
#import "DateTimeUtils.h"
#import "WeekCalendarView.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    WeekCalendarView *view = [[WeekCalendarView alloc] initWithFrame:CGRectMake(10, 30, [UIScreen mainScreen].bounds.size.width-20, 150)];
//    view.firstShowNextWeek = YES;
//    view.showPageCurlAnimation = NO;
//    view.indicatorColor = [UIColor redColor];
    [view setCompletion:^(NSDate *date) {
        NSLog(@"%@", date);
    }];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
