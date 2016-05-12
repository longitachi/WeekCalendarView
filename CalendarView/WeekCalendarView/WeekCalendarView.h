//
//  WeekCalendarView.h
//  CalendarView
//
//  Created by long on 16/5/11.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekCalendarView : UIView

/**上一周按钮是否可点击*/
@property (nonatomic, assign) BOOL previousWeekBtnEnabled;
/**本周按钮是否可点击*/
@property (nonatomic, assign) BOOL currentWeekBtnEnabled;
/**下一周按钮是否可点击*/
@property (nonatomic, assign) BOOL nextWeekBtnEnabled;
/**是否显示日历翻页效果*/
@property (nonatomic, assign) BOOL showPageCurlAnimation;
/**是否显示当前选中天的指示器*/
@property (nonatomic, assign) BOOL showIndicator;
/**指示器显示颜色*/
@property (nonatomic, strong) UIColor *indicatorColor;
/**第一次直接显示下周日历*/
@property (nonatomic, assign) BOOL firstShowNextWeek;

@property (nonatomic, copy)   void (^completion)(NSDate *date);

@end
