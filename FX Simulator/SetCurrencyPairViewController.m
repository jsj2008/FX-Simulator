//
//  SelectCurrencyPairViewController.m
//  FX Simulator
//
//  Created  on 2015/04/26.
//  
//

#import "SetCurrencyPairViewController.h"

#import "CurrencyPair.h"
#import "Setting.h"

@interface SetCurrencyPairViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@end

@implementation SetCurrencyPairViewController {
    NSArray *_currencyPairList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currencyPairList = [Setting currencyPairList];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUInteger index = [_currencyPairList indexOfObject:self.delegate.currencyPair];
    [self.pickerView selectRow:index inComponent:0 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [_currencyPairList count];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [(CurrencyPair*)[_currencyPairList objectAtIndex:row] toDisplayString];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.delegate.currencyPair = [_currencyPairList objectAtIndex:row];
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
