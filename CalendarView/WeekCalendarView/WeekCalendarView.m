//
//  WeekCalendarView.m
//  CalendarView
//
//  Created by long on 16/5/11.
//  Copyright © 2016年 long. All rights reserved.
//

#import "WeekCalendarView.h"
#import "WeekCalendarCell.h"
#import "DateTimeUtils.h"

#define TopH    40.0
#define MidH    30.0
#define BottomH TopH

@interface WeekCalendarView () <UICollectionViewDataSource, UICollectionViewDelegate>

/**当前日期label*/
@property (nonatomic, strong) UILabel *currentDateLabel;
@property (nonatomic, strong) UIButton *previousWeekBtn;
@property (nonatomic, strong) UIButton *currentWeekBtn;
@property (nonatomic, strong) UIButton *nextWeekBtn;

/**周一~周日标签父视图*/
@property (nonatomic, strong) UIView *weekView;

@property (nonatomic, strong) UICollectionView *collectionView;

/**日历操作对象*/
@property (nonatomic, strong) NSCalendar *calendar;
/**当前显示周第一天date，以每周的周一为第一天*/
@property (nonatomic, strong) NSDate *nowWeekMonday;
/**当前显示周数组*/
@property (nonatomic, strong) NSMutableArray *arrNowWeekDays;
/**当前选中日期*/
@property (nonatomic, strong) NSDate *selectDate;
/**当前选中日期的day*/
@property (nonatomic, assign) NSInteger selectDay;

@property (nonatomic, strong) UILabel *indicatorLabel;

@end

@implementation WeekCalendarView

- (void)awakeFromNib
{
    [self initUI];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (NSMutableArray *)arrNowWeekDays
{
    if (!_arrNowWeekDays) {
        _arrNowWeekDays = [NSMutableArray array];
    }
    return _arrNowWeekDays;
}

- (NSCalendar *)calendar
{
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (NSDate *)nowWeekMonday
{
    if (!_nowWeekMonday) {
        //第一次去获取本周的周一日期
        _nowWeekMonday = [self getNowWeekMonday];
    }
    return _nowWeekMonday;
}

- (NSDate *)getNowWeekMonday
{
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger diff = components.weekday-2;
    
    components.day -= (diff>=0?diff:diff+7);
    
    NSDate *nowWeekMonday = [self.calendar dateFromComponents:components];
    return nowWeekMonday;
}

- (UILabel *)indicatorLabel
{
    if (!_indicatorLabel) {
        _indicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TopH+MidH, BottomH, BottomH)];
        _indicatorLabel.backgroundColor = self.indicatorColor?:[UIColor colorWithRed:98/255.0 green:184/255.0 blue:255/255.0 alpha:1];
        _indicatorLabel.alpha = 0.4;
        _indicatorLabel.layer.cornerRadius = BottomH/2;
        _indicatorLabel.layer.masksToBounds = YES;
        [self addSubview:_indicatorLabel];
    }
    return _indicatorLabel;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    //获取数据源
    if (self.firstShowNextWeek) {
        [self getNextWeekDays];
    } else {
        [self getNowWeekDays];
    }
}

- (void)initUI
{
    self.previousWeekBtnEnabled = YES;
    self.currentWeekBtnEnabled = YES;
    self.nextWeekBtnEnabled = YES;
    self.showPageCurlAnimation = YES;
    self.showIndicator = YES;
    self.firstShowNextWeek = NO;
    self.selectDate = [NSDate date];
    
    //当前年月label
    self.currentDateLabel = [[UILabel alloc] init];
    self.currentDateLabel.text = [DateTimeUtils getDateTimeNowWithFormat:@"yyyy年MM月"];
    self.currentDateLabel.font = [UIFont systemFontOfSize:16];
    self.currentDateLabel.textAlignment = NSTextAlignmentCenter;
    self.currentDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.currentDateLabel];
    //右边上下周、本周父视图view
    UIView *topRightView = [self getTopRightView];
    [self addSubview:topRightView];
    //周一~周日标签view
    self.weekView = [[UIView alloc] init];
    self.weekView.backgroundColor = [UIColor lightGrayColor];
    self.weekView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.weekView];
    //collectionView
    [self initCollectionView];
    [self addSubview:self.collectionView];
    
    NSDictionary *viewDic = @{@"curDateLabel" : self.currentDateLabel,
                              @"trView" : topRightView,
                              @"weekView" : self.weekView,
                              @"colView" : self.collectionView};
    NSDictionary *metrics = @{@"topH" : @(TopH),
                              @"midH" : @(MidH),
                              @"bottomH": @(BottomH)};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[curDateLabel(==topH)]" options:0 metrics:metrics views:viewDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[curDateLabel(==100)][trView]|" options:0 metrics:nil views:viewDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[trView(==topH)]" options:0 metrics:metrics views:viewDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[curDateLabel][weekView(==midH)]" options:0 metrics:metrics views:viewDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[weekView]|" options:0 metrics:nil views:viewDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[weekView][colView(==bottomH)]" options:0 metrics:metrics views:viewDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[colView]|" options:0 metrics:nil views:viewDic]];
}

- (UIView *)getTopRightView
{
    UIView *topRightView = [[UIView alloc] init];
    topRightView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //上一周按钮
    self.previousWeekBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.previousWeekBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.previousWeekBtn setTitle:@"<  上一周" forState:UIControlStateNormal];
    [self.previousWeekBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.previousWeekBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.previousWeekBtn addTarget:self action:@selector(previousWeekBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topRightView addSubview:self.previousWeekBtn];
    //下一周按钮
    self.nextWeekBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nextWeekBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.nextWeekBtn setTitle:@"下一周  >" forState:UIControlStateNormal];
    [self.nextWeekBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.nextWeekBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nextWeekBtn addTarget:self action:@selector(nextWeekBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topRightView addSubview:self.nextWeekBtn];
    //本周按钮
    self.currentWeekBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.currentWeekBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.currentWeekBtn setTitle:@"本周" forState:UIControlStateNormal];
    [self.currentWeekBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.currentWeekBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.currentWeekBtn addTarget:self action:@selector(currentWeekBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topRightView addSubview:self.currentWeekBtn];
    
    NSDictionary *viewDic = @{@"preBtn" : self.previousWeekBtn,
                              @"nextBtn" : self.nextWeekBtn,
                              @"currentBtn" : self.currentWeekBtn};
    NSDictionary *metrics = @{@"btnWidth" : @(75)};
    [topRightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[preBtn]-5-|" options:0 metrics:nil views:viewDic]];
    [topRightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[preBtn(==btnWidth)]" options:0 metrics:metrics views:viewDic]];
    [topRightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[nextBtn]-5-|" options:0 metrics:nil views:viewDic]];
    [topRightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[nextBtn(==btnWidth)]|" options:0 metrics:metrics views:viewDic]];
    
    [topRightView addConstraint:[NSLayoutConstraint constraintWithItem:self.currentWeekBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:topRightView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
    [topRightView addConstraint:[NSLayoutConstraint constraintWithItem:self.currentWeekBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:topRightView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
    [topRightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[currentBtn(==40)]" options:0 metrics:nil views:viewDic]];
    
    self.previousWeekBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.previousWeekBtn.layer.borderWidth = 0.5;
    self.nextWeekBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.nextWeekBtn.layer.borderWidth = 0.5;
    self.currentWeekBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.currentWeekBtn.layer.borderWidth = 0.5;
    
    return topRightView;
}

- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.frame.size.width/7, BottomH);
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.collectionView.layer.borderWidth = 0.5;
    [self.collectionView registerNib:[UINib nibWithNibName:@"WeekCalendarCell" bundle:nil] forCellWithReuseIdentifier:@"WeekCalendarCell"];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //添加滑动手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipe.numberOfTouchesRequired = 1;
    [self.collectionView addGestureRecognizer:leftSwipe];
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];;
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    leftSwipe.numberOfTouchesRequired = 1;
    [self.collectionView addGestureRecognizer:rightSwipe];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(self.frame.size.width/7, BottomH);
    if (self.weekView.subviews.count == 0) {
        NSArray *weekArr = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
        UILabel *preLbl = nil;
        CGFloat weekMargin = 15;
        NSString *firstStr = weekArr[0];
        CGRect strRect = [firstStr boundingRectWithSize:CGSizeMake(FLT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:nil context:nil];
        CGFloat itemCount = (CGFloat)weekArr.count;
        CGFloat weekGap = (self.bounds.size.width-2*weekMargin-itemCount*strRect.size.width)/(itemCount-1);
        for (int i = 0; i < weekArr.count ; i++) {
            UILabel *lbl = [[UILabel alloc] init];
            lbl.translatesAutoresizingMaskIntoConstraints = NO;
            lbl.font = [UIFont systemFontOfSize:12.0f];
            lbl.text = weekArr[i];
            lbl.textColor = [UIColor blackColor];
            [lbl sizeToFit];
            [self.weekView addSubview:lbl];
            [self.weekView addConstraint:[NSLayoutConstraint constraintWithItem:lbl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.weekView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
            if (preLbl==nil) {
                [self.weekView addConstraint:[NSLayoutConstraint constraintWithItem:lbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_weekView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:weekMargin]];
            } else {
                [_weekView addConstraint:[NSLayoutConstraint constraintWithItem:lbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:preLbl attribute:NSLayoutAttributeRight multiplier:1.0f constant:weekGap]];
            }
            preLbl = lbl;
        }
    }
}

- (void)updateCurrentDateLabelText
{
    self.currentDateLabel.text = [DateTimeUtils getFormatWithDate:self.selectDate formatter:@"yyyy年MM月"];
}

#pragma mark - btn action
- (void)previousWeekBtnClick
{
    if (!self.previousWeekBtnEnabled) return;
    [self getPreviousWeekDays];
    [self.collectionView.layer addAnimation:[self addAnimationWithType:@"pageUnCurl" duration:0.4] forKey:nil];
    [self.collectionView reloadData];
    [self updateCurrentDateLabelText];
}

- (void)nextWeekBtnClick
{
    if (!self.nextWeekBtnEnabled) return;
    [self getNextWeekDays];
    [self.collectionView.layer addAnimation:[self addAnimationWithType:@"pageCurl" duration:0.4] forKey:nil];
    [self.collectionView reloadData];
    [self updateCurrentDateLabelText];
}

- (void)currentWeekBtnClick
{
    if (!self.currentWeekBtnEnabled) return;
    [self getNowWeekDays];
    [self.collectionView reloadData];
    [self updateCurrentDateLabelText];
}

- (void)swipeAction:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self nextWeekBtnClick];
    } else if (swipe.direction==UISwipeGestureRecognizerDirectionRight) {
        [self previousWeekBtnClick];
    }
}

- (CATransition*)addAnimationWithType:(NSString*)type duration:(NSTimeInterval)time
{
    if (!self.showPageCurlAnimation) return nil;
    CATransition *animate = [CATransition animation];
    
    [animate setDuration:time];
    [animate setType:type];
    [animate setTimingFunction:UIViewAnimationCurveEaseInOut];
    return animate;
}

#pragma mark - 日历相关
/**获取当前周*/
- (void)getNowWeekDays
{
    _nowWeekMonday = nil;
    [self getAllWeekDays];
    //获取当前周的便不能直接默认选择当前周周一，这里要默认选择当天
    NSDateComponents *components = [self.calendar components:NSCalendarUnitDay fromDate:[NSDate date]];
    self.selectDay = components.day;
    self.selectDate = [NSDate date];
}

/**获取上周*/
- (void)getPreviousWeekDays
{
    [self setNowWeekMondayWithDiff:-7];
    [self getAllWeekDays];
}

/**获取下周*/
- (void)getNextWeekDays
{
    [self setNowWeekMondayWithDiff:7];
    [self getAllWeekDays];
}

- (void)getAllWeekDays
{
    NSLog(@"华丽的分割线");
    [self.arrNowWeekDays removeAllObjects];
    
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.nowWeekMonday];
    self.selectDay = components.day;
    self.selectDate = [self.calendar dateFromComponents:components];
    for (int i = 0; i < 7; i++) {
        components.day += i;
        NSDate *date = [self.calendar dateFromComponents:components];
        NSLog(@"%@", [DateTimeUtils getDateTimeWithDate:date]);
        [self.arrNowWeekDays addObject:date];
        components.day -= i;
    }
}

- (void)setNowWeekMondayWithDiff:(NSInteger)diff
{
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self.nowWeekMonday];
    components.day += diff;
    self.nowWeekMonday = [self.calendar dateFromComponents:components];
}

#pragma mark - collection view datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrNowWeekDays.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeekCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeekCalendarCell" forIndexPath:indexPath];
    NSDateComponents *com = [self.calendar components:NSCalendarUnitDay fromDate:self.arrNowWeekDays[indexPath.row]];
    cell.labTitle.text = [NSString stringWithFormat:@"%ld", com.day];
    if (com.day == self.selectDay) {
        cell.labTitle.textColor = [UIColor brownColor];
        CGRect convertRect = [self.collectionView convertRect:cell.frame toView:self];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.indicatorLabel.center = CGPointMake(CGRectGetMidX(convertRect), CGRectGetMidY(convertRect));
        }];
    } else {
        cell.labTitle.textColor = [UIColor blackColor];
    }
    
    if (!cell.selectedBackgroundView) {
        UIView *selectedView = [[UIView alloc] initWithFrame:cell.bounds];
        selectedView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
        cell.selectedBackgroundView = selectedView;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    WeekCalendarCell *cell = (WeekCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.selectDate = self.arrNowWeekDays[indexPath.row];
    self.selectDay = cell.labTitle.text.integerValue;
    [self.collectionView reloadData];
    [self updateCurrentDateLabelText];
    //回调
    if (self.completion) self.completion(self.selectDate);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
