//
//  SetTimeScaleViewController.m
//  FX Simulator
//
//  Created  on 2015/05/12.
//  
//

#import "SetTimeScaleViewController.h"

#import "NewStartViewController.h"
#import "MarketTimeScale.h"
#import "Setting.h"

@interface SetTimeScaleViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation SetTimeScaleViewController {
    NSArray *_timeScaleList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _timeScaleList = [Setting timeScaleList];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUInteger index = [_timeScaleList indexOfObject:self.delegate.timeScale];
    [self.pickerView selectRow:index inComponent:0 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [_timeScaleList count];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [(MarketTimeScale*)[_timeScaleList objectAtIndex:row] toDisplayString];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.delegate.timeScale = [_timeScaleList objectAtIndex:row];
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
