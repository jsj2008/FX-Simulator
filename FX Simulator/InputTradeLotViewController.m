//
//  InputTradeLotViewController.m
//  FX Simulator
//
//  Created  on 2015/03/24.
//  
//

#import "InputTradeLotViewController.h"

#import "Lot.h"
#import "PositionSize.h"

@interface InputTradeLotViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputTradeLotTextField;
@end

@implementation InputTradeLotViewController {
    PositionSize *_defaultTradePositionSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Lot *lot = [[Lot alloc] initWithPositionSize:_defaultTradePositionSize positionSizeOfLot:self.positionSizeOfLot];
    self.inputTradeLotTextField.text = lot.toDisplayString;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.inputTradeLotTextField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.inputTradeLotTextField resignFirstResponder];
}

- (void)setDefaultTradePositionSize:(PositionSize *)positionSize
{
    _defaultTradePositionSize = positionSize;
}

- (PositionSize *)tradePositionSize
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    
    Lot *lot = [[Lot alloc] initWithLotValue:[[formatter numberFromString:self.inputTradeLotTextField.text] unsignedLongLongValue] positionSizeOfLot:self.positionSizeOfLot];
    
    return [lot toPositionSize];
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
