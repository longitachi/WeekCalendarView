//
//  DateTimeUtils.m
//  vsfa
//
//  Created by long on 15/7/8.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "DateTimeUtils.h"

@implementation DateTimeUtils

+ (NSDate *)getNSDateWithString:(NSString *)dateString dateFormat:(NSString *)format
{
    @try {
        dateString = [dateString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        NSDate *date = [formatter dateFromString:dateString];
        if (date == nil) {
            NSLog(@"日期格式超出我们默认格式范围dateString:%@, format:%@", dateString, format);
        }
        return date;
    }
    @catch (NSException *exception) {
//        [CommonErrorHandler Handler:exception];
        return nil;
    }
}

+ (NSString *)getFormatWithDate:(NSDate *)date formatter:(NSString *)formatter
{
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:formatter];
    return [fm stringFromDate:date];
}

+ (NSDate *)getDateWithFormat:(NSDate *)date formatter:(NSString *)formatter
{
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:formatter];
    NSString *str = [self getFormatWithDate:date formatter:formatter];
    return [fm dateFromString:str];
}

+ (NSString *)getFormatWithDateString:(NSString *)dateString formatter:(NSString *)formatter
{
    return [self getFormatWithDate:[self getNSDateWithString:dateString dateFormat:Format_DB] formatter:formatter];
}

+ (NSString *)getDateTimeWithDate:(NSDate *)date
{
    return [self getFormatWithDate:date formatter:Format_DateTime];
}

+ (NSString *)getDateTimeWithDateString:(NSString *)dateString
{
    return [self getFormatWithDateString:dateString formatter:Format_DateTime];
}

+ (NSString *)getDateWithDate:(NSDate *)date
{
    return [self getFormatWithDate:date formatter:Format_Date];
}

+ (NSString *)getDateWithDateString:(NSString *)dateString
{
    return [self getFormatWithDateString:dateString formatter:Format_Date];
}

+ (NSString *)getTimeWithDate:(NSDate *)date
{
    return [self getFormatWithDate:date formatter:Format_Time];
}

+ (NSString *)getTimeWithDateString:(NSString *)dateString
{
    return [self getFormatWithDateString:dateString formatter:Format_Time];
}

+ (NSString *)getDateTimeNowWithFormat:(NSString *)formatter
{
    return [self getFormatWithDate:[NSDate date] formatter:formatter];
}

+ (NSTimeInterval)getTimeIntervalWithDateString:(NSString *)startTime sinceDateString:(NSString *)endTime format:(NSString *)formatter
{
    NSDate *startDate = [self getNSDateWithString:startTime dateFormat:formatter];
    NSDate *endDate = [self getNSDateWithString:endTime dateFormat:formatter];
    NSTimeInterval interval = [startDate timeIntervalSinceDate:endDate];
    return interval;
}

@end
