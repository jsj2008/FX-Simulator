//
//  InputTradeLotViewController.m
//  FX Simulator
//
//  Created  on 2015/03/24.
//  
//

#import "InputTradeLotViewController.h"


#import "PositionSize.h"
#import "Lot.h"

@interface InputTradeLotViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputTradeLotTextField;
@end

@implementation InputTradeLotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.inputTradeLotTextField.text = [[self.saveData.tradePositionSize toLot] toDisplayString];
    self.inputTradeLotTextField.text = [self.defaultInputTradeLot toDisplayString];
    
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
    
    /*NSNumberFormatter *formatter = [NSNumberFormatter new];
    
    Lot *lot = [[Lot alloc] initWithLotValue:[[formatter numberFromString:self.inputTradeLotTextField.text] unsignedLongLongValue]];
    
    self.inputTradeLot = lot;*/
}

/*-(void)setInputTradeLot:(Lot *)inputTradeLot
{
    self.inputTradeLotTextField.text = inputTradeLot;
}*/

-(Lot*)inputTradeLot
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    
    Lot *lot = [[Lot alloc] initWithLotValue:[[formatter numberFromString:self.inputTradeLotTextField.text] unsignedLongLongValue]];
    
    return lot;
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
