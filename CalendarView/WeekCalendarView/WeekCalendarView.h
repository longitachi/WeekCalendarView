//
//  WeekCalendarView.h
//  CalendarView
//
//  Created by long on 16/5/11.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CalendarRedPointState) {
    //显示红点
    CalendarRedPointStateShow = 0,
    //不显示
    CalendarRedPointStateHide
};

@protocol WeekCalendarViewDelegate <NSObject>

@optional
/**点击上一周按钮回调*/
- (void)weekCalendarViewChangeToPreviousWeek:(NSArray<NSDate *> *)previousWeek;
/**点击下一周按钮回调*/
- (void)weekCalendarViewChangeToNextWeek:(NSArray<NSDate *> *)nextWeek;
/**点击本周按钮回调*/
- (void)weekCalendarViewChangeToCurrentWeek:(NSArray<NSDate *> *)currentWeek;
/**点击日期回调*/
- (void)weekCalendarViewClickDate:(NSDate *)date;

@end

@interface WeekCalendarView : UIView

@property (nonatomic, assign) id<WeekCalendarViewDelegate> delegate;

/**上一周按钮是否可点击，default is yes*/
@property (nonatomic, assign) BOOL previousWeekBtnEnabled;
/**本周按钮是否可点击，default is yes*/
@property (nonatomic, assign) BOOL currentWeekBtnEnabled;
/**下一周按钮是否可点击，default is yes*/
@property (nonatomic, assign) BOOL nextWeekBtnEnabled;
/**是否显示日历翻页效果，default is yes*/
@property (nonatomic, assign) BOOL showPageCurlAnimation;
/**是否显示当前选中天的指示器，default is yes*/
@property (nonatomic, assign) BOOL showIndicator;
/**指示器显示颜色，default is rgb(98, 184, 255)*/
@property (nonatomic, strong) UIColor *indicatorColor;
/**第一次直接显示下周日历，default is no*/
@property (nonatomic, assign) BOOL firstShowNextWeek;
/**是否隐藏三个按钮（上下周、本周），default is no*/
@property (nonatomic, assign) BOOL hideToggleBtns;
/**每周中每天的红点状态 key:当天天数 value:PlanState的int值对应的NSNumber对象 ex:@{@"23": @(CalendarRedPointStateShow)} */
@property (nonatomic, strong) NSDictionary *dicRedPointState;

/*!
 @brief 获取周历当前显示的周
 */
- (NSArray<NSDate *> *)getNowShowWeekdays;

@end
