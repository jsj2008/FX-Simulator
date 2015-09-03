//
//  SetStartTimeViewController.m
//  FX Simulator
//
//  Created  on 2015/05/02.
//  
//

#import "SetStartTimeViewController.h"

#import "FXSTimeRange.h"
#import "Time.h"
#import "NSDate+FXSDateData.h"
#import "SaveData.h"
#import "Setting.h"

typedef struct PickerRowSet {
    NSUInteger yearRow;
    NSUInteger monthRow;
    NSUInteger dayRow;
} PickerRowSet;

@interface SetStartTimeViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@end

@implementation SetStartTimeViewController {
    NSDate *_minStartDate;
    NSDate *_maxStartDate;
    NSMutableArray *_displayPickerYearStringArray;
    NSMutableArray *_displayPickerMonthStringArray;
    NSMutableArray *_displayPickerDayStringArray;
}

// TODO: Default

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    _minStartDate = [Setting rangeForCurrencyPair:self.saveData.currencyPair timeScale:self.saveData.timeFrame].start.date;
    _maxStartDate = [Setting rangeForCurrencyPair:self.saveData.currencyPair timeScale:self.saveData.timeFrame].end.date;
    
    _displayPickerYearStringArray = [NSMutableArray array];
    _displayPickerMonthStringArray = [NSMutableArray array];
    _displayPickerDayStringArray = [NSMutableArray array];
    
    for (int i = _minStartDate.fxs_year; i <= _maxStartDate.fxs_year; i++) {
        [_displayPickerYearStringArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    for (int i = 1; i <= 12; i++) {
        [_displayPickerMonthStringArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    for (int i = 1; i <= 31; i++) {
        [_displayPickerDayStringArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self selectRowForDate:self.saveData.startTime.date];
    
    /*NSUInteger index = [_currencyPairList indexOfObject:self.delegate.currencyPair];
    [self.pickerView selectRow:index inComponent:0 animated:NO];*/
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_displayPickerYearStringArray count];
            break;
        case 1:
            return [_displayPickerMonthStringArray count];
            break;
        case 2:
            return [_displayPickerDayStringArray count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            NSString *title = [_displayPickerYearStringArray objectAtIndex:row];
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            return attString;
            break;
        }
        case 1:
        {
            NSString *title = [_displayPickerMonthStringArray objectAtIndex:row];
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            return attString;
            break;
        }
        case 2:
        {
            NSString *title = [_displayPickerDayStringArray objectAtIndex:row];
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            return attString;
            break;
        }
        default:
            return 0;
            break;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDate *selectedDate = [self getDateByYear:[_displayPickerYearStringArray objectAtIndex:[self.pickerView selectedRowInComponent:0]] month:[_displayPickerMonthStringArray objectAtIndex:[self.pickerView selectedRowInComponent:1]] day:[_displayPickerDayStringArray objectAtIndex:[self.pickerView selectedRowInComponent:2]]];
    
    NSComparisonResult result1 = [selectedDate compare:_minStartDate];
    NSComparisonResult result2 = [selectedDate compare:_maxStartDate];
    
    if (result1 == NSOrderedAscending) {
        // selectedDateの方が小さいとき。
        [self selectRowForDate:_minStartDate];
        selectedDate = _minStartDate;
    } else if (result2 == NSOrderedDescending) {
        // selectedDateの方が大きいとき。
        [self selectRowForDate:_maxStartDate];
        selectedDate = _maxStartDate;
    }
    
    self.saveData.startTime = [[Time alloc] initWithDate:selectedDate];
}

/**
 NSDateをもとに、PickerのRowをそれぞれ選択する。
**/

-(void)selectRowForDate:(NSDate*)date
{
    PickerRowSet set = [self getPickerRowSetOfDate:date];
    
    [self.pickerView selectRow:set.yearRow inComponent:0 animated:YES];
    [self.pickerView selectRow:set.monthRow inComponent:1 animated:YES];
    [self.pickerView selectRow:set.dayRow inComponent:2 animated:YES];
}

-(NSDate*)getDateByYear:(NSString*)year month:(NSString*)month day:(NSString*)day
{
    NSString* dateString = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [formatter dateFromString:dateString];
}

/**
 そのDateのYear,Month,DayのそれぞれがPickerのどのRowかを取得。
**/

-(PickerRowSet)getPickerRowSetOfDate:(NSDate*)date
{
    PickerRowSet pickerRowSet;
    
    pickerRowSet.yearRow = date.fxs_year - ((NSString*)[_displayPickerYearStringArray firstObject]).integerValue;
    pickerRowSet.monthRow = date.fxs_month - ((NSString*)[_displayPickerMonthStringArray firstObject]).integerValue;
    pickerRowSet.dayRow = date.fxs_day - ((NSString*)[_displayPickerDayStringArray firstObject]).integerValue;
    
    return pickerRowSet;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
