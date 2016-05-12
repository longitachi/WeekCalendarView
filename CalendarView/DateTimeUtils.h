//
//  DateTimeUtils.h
//  vsfa
//
//  Created by long on 15/7/8.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Format_DB       @"yyyy-MM-dd HH:mm:ss.SSS"
#define Format_DateTime @"yyyy年MM月dd日 HH:mm"
#define Format_Date     @"yyyy年MM月dd日"
#define Format_Time     @"HH:mm"

@interface DateTimeUtils : NSObject

/**
 *@brief 传入时间字符串和格式，返回NSDate对象
 */
+ (NSDate *)getNSDateWithString:(NSString *)dateString dateFormat:(NSString *)format;

/**
 *@brief 传入日期和格式，返回日期格式化后的字符串
 */
+ (NSString *)getFormatWithDate:(NSDate *)date formatter:(NSString *)formatter;

/**
 *@brief 传入日期和格式，返回日期格式化后的日期
 */
+ (NSDate *)getDateWithFormat:(NSDate *)date formatter:(NSString *)formatter;

/**
 *@brief 传入日期字符串和格式，返回日期格式化后的字符串
 */
+ (NSString *)getFormatWithDateString:(NSString *)dateString formatter:(NSString *)formatter;

/**
 *@brief 格式化传入日期,返回格式"yyyy年MM月dd日 HH:mm"
 */
+ (NSString *)getDateTimeWithDate:(NSDate *)date;

/**
 *@brief 格式化所传入时间字符串,返回格式"yyyy年MM月dd日 HH:mm"
 */
+ (NSString *)getDateTimeWithDateString:(NSString *)dateString;

/**
 *@brief 获取传入日期的年月日,返回格式"yyyy年MM月dd日"
 */
+ (NSString *)getDateWithDate:(NSDate *)date;

/**
 *@brief 获取传入时间字符串的年月日,返回格式"yyyy年MM月dd日"
 */
+ (NSString *)getDateWithDateString:(NSString *)dateString;

/**
 *@brief 获取传入日期的时分,返回格式"HH:mm"
 */
+ (NSString *)getTimeWithDate:(NSDate *)date;

/**
 *@brief 获取传入时间字符串的时分,返回格式"HH:mm"
 */
+ (NSString *)getTimeWithDateString:(NSString *)dateString;

/**
 *@brief 以传入日期格式返回当前日期字符串
 */
+ (NSString *)getDateTimeNowWithFormat:(NSString *)formatter;

/**
 *@brief 根据传入格式，计算两个时间之间的时间差
 */
+ (NSTimeInterval)getTimeIntervalWithDateString:(NSString *)startTime sinceDateString:(NSString *)endTime format:(NSString *)formatter;

@end
