//
//  WeekCalendarCell.m
//  CalendarView
//
//  Created by long on 16/5/11.
//  Copyright © 2016年 long. All rights reserved.
//

#import "WeekCalendarCell.h"

@interface WeekCalendarCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineWidthConstraint;

@end

@implementation WeekCalendarCell

- (void)awakeFromNib {
    [self.lineWidthConstraint setConstant:0.5];
    self.labPoint.layer.masksToBounds = YES;
    self.labPoint.layer.cornerRadius = 3.0f;
}

@end
