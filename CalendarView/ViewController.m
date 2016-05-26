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

@interface ViewController () <WeekCalendarViewDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    WeekCalendarView *view = [[WeekCalendarView alloc] initWithFrame:CGRectMake(10, 30, [UIScreen mainScreen].bounds.size.width-20, 150)];
//    view.firstShowNextWeek = YES;
//    view.showPageCurlAnimation = NO;
//    view.indicatorColor = [UIColor redColor];
    view.delegate = self;
    [self.view addSubview:view];
}

#pragma mark - calendar view delegate
- (void)weekCalendarViewClickDate:(NSDate *)date
{
    NSLog(@"当前点击日期:%@", [DateTimeUtils getFormatWithDate:date formatter:Format_Date]);
}

- (void)weekCalendarViewChangeToPreviousWeek:(NSArray<NSDate *> *)previousWeek
{
    [self log:previousWeek];
}

- (void)weekCalendarViewChangeToNextWeek:(NSArray<NSDate *> *)nextWeek
{
    [self log:nextWeek];
}

- (void)weekCalendarViewChangeToCurrentWeek:(NSArray<NSDate *> *)currentWeek
{
    [self log:currentWeek];
}

- (void)log:(NSArray<NSDate *> *)weekDays
{
    NSLog(@"----------当前周----------");
    for (NSDate *date in weekDays) {
        NSLog(@"%@", [DateTimeUtils getFormatWithDate:date formatter:Format_Date]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
